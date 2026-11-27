import { and, count, eq, isNull } from "drizzle-orm";
import { getContext } from "telefunc";
import { createDrizzleDb } from "@/database/drizzle";
import { card, order, productSku, productV2 } from "@/database/drizzle/schema";
import { appError } from "@/lib/app-error";
import { PRODUCT_TRANSLATION_FIELDS, SKU_TRANSLATION_FIELDS, localizeContentText, readContentTranslations } from "@/lib/content-translations";
import { resolveExternalPayUrl } from "@/lib/external-pay";
import { formatMinor, isCurrencyCode } from "@/lib/money";
import { normalizeOrderEmail } from "@/lib/local-orders";
import { isStorefrontLocale, type StorefrontLocale } from "@/lib/i18n/locale";
import { reportUnexpectedServerError } from "@/server/error-handling";
import { enqueueOrderEvent } from "@/server/email/order-events";
import { closePendingOrder, confirmOrderPayment, createOrder, type CreateOrderInput } from "@/server/order/service";
import { getEnabledPaymentProvider } from "./config";
import { getSiteSettings } from "@/server/site/public-settings";
import { getProviderDefinition, resolvePaymentUrls } from "./registry";
import { PaymentLogService } from "./log-service";
import { paymentRepository } from "./repository";
import type { PaymentCreateInput, PaymentCreateResult } from "./types";
import type { PaymentChannel, PaymentProviderKind } from "./registry";

type RuntimeContext = {
  env?: Record<string, unknown> & { DB?: D1Database };
  user?: { id: string } | null;
};

function safePaymentCreateError(cause: unknown) {
  if (!(cause instanceof Error)) return "PAYMENT_CREATE_FAILED";
  if (/^[A-Z][A-Z0-9_:-]+$/.test(cause.message) && cause.message.length <= 120) return cause.message;
  const name = cause.name.toUpperCase().replace(/[^A-Z0-9]+/g, "_").replace(/^_|_$/g, "");
  const detail = cause.message.replace(/https?:\/\/[^\s]+/gi, "[url]").replace(/[A-Za-z0-9_-]{32,}/g, "[token]").replace(/\s+/g, " ").trim().slice(0, 100);
  return name ? `PAYMENT_RUNTIME_${name}${detail ? `:${detail}` : ""}` : "PAYMENT_CREATE_FAILED";
}

function paymentSubject(locale: StorefrontLocale | undefined, orderNo: string) {
  if (locale === "en-US") return `Order ${orderNo}`;
  if (locale === "zh-TW") return `訂單 ${orderNo}`;
  return `订单 ${orderNo}`;
}

function paymentReturnUrl(value: unknown, orderNo: string) {
  const raw = String(value ?? "").trim();
  if (!raw) return "";
  const url = new URL(raw);
  url.search = "";
  url.hash = "";
  url.searchParams.set("orderNo", orderNo);
  return url.toString();
}

function orderAccess(ownerUserId: string | null, email?: string) {
  const normalizedEmail = normalizeOrderEmail(email ?? "");
  if (normalizedEmail) {
    return and(
      isNull(order.ownerUserId),
      eq(order.contactType, "EMAIL"),
      eq(order.contactEmailNormalized, normalizedEmail),
    );
  }
  return ownerUserId ? eq(order.ownerUserId, ownerUserId) : null;
}

export class PaymentFlowService {
  constructor(private readonly database: D1Database, private readonly runtime: Record<string, unknown> = {}) {}

  private async buildExternalPayUrl(params: {
    productId: number | null;
    productSkuId: number | null;
    orderNo: string;
    amount: number;
    currency: string;
    quantity: number;
    email?: string | null;
    locale?: StorefrontLocale;
    fallbackProductName?: string;
    fallbackSkuName?: string | null;
  }): Promise<string> {
    const db = createDrizzleDb(this.database);
    const [productRow, skuRow, site] = await Promise.all([
      params.productId
        ? db.select({ slug: productV2.slug, name: productV2.name, translationsJson: productV2.translationsJson, externalPayUrl: productV2.externalPayUrl }).from(productV2).where(eq(productV2.id, params.productId)).limit(1).then((rows) => rows[0] ?? null)
        : Promise.resolve(null),
      params.productSkuId
        ? db.select({ name: productSku.name, translationsJson: productSku.translationsJson, externalPayUrl: productSku.externalPayUrl }).from(productSku).where(eq(productSku.id, params.productSkuId)).limit(1).then((rows) => rows[0] ?? null)
        : Promise.resolve(null),
      getSiteSettings(this.database),
    ]);

    const productDisplayName = productRow
      ? (localizeContentText(productRow.name, readContentTranslations(productRow.translationsJson, PRODUCT_TRANSLATION_FIELDS), params.locale, "name") ?? productRow.name)
      : (params.fallbackProductName ?? "");
    const skuDisplayName = skuRow
      ? (localizeContentText(skuRow.name, readContentTranslations(skuRow.translationsJson, SKU_TRANSLATION_FIELDS), params.locale, "name") ?? skuRow.name)
      : (params.fallbackSkuName ?? "");
    const formattedPrice = formatMinor(params.amount, isCurrencyCode(params.currency) ? params.currency : "CNY");
    const resolved = resolveExternalPayUrl({
      skuUrl: skuRow?.externalPayUrl,
      productUrl: productRow?.externalPayUrl,
      siteUrl: site.externalPayUrl,
      context: {
        orderNo: params.orderNo,
        slug: productRow?.slug ?? "",
        product: productDisplayName,
        sku: skuDisplayName,
        price: formattedPrice,
        quantity: params.quantity,
        email: params.email?.trim() ?? "",
      },
    });
    if (!resolved) appError("EXTERNAL_PAY_URL_INVALID");
    return resolved;
  }

  async create(input: PaymentCreateInput, ownerUserId: string | null, locale?: StorefrontLocale, clientIp?: string | null): Promise<PaymentCreateResult> {
    if (input.paymentProvider === "EXTERNAL_LINK") {
      // Confirm an external link is actually configured before reserving stock or creating a pending order.
      const db = createDrizzleDb(this.database);
      const [productRow, skuRow, site] = await Promise.all([
        db.select({ externalPayUrl: productV2.externalPayUrl }).from(productV2).where(eq(productV2.id, input.productId)).limit(1).then((rows) => rows[0] ?? null),
        db.select({ externalPayUrl: productSku.externalPayUrl }).from(productSku).where(eq(productSku.id, input.productSkuId)).limit(1).then((rows) => rows[0] ?? null),
        getSiteSettings(this.database),
      ]);
      const hasUrl = Boolean(skuRow?.externalPayUrl?.trim() || productRow?.externalPayUrl?.trim() || site.externalPayUrl?.trim());
      if (!hasUrl) appError("EXTERNAL_PAY_URL_INVALID");

      const created = await createOrder(this.database, { ...input, locale, paymentProvider: "EXTERNAL_LINK", paymentChannel: "external_link", allowPendingPayment: true } as CreateOrderInput, ownerUserId);
      const logs = new PaymentLogService(this.database);
      if (created.amount === 0) {
        try {
          const outcome = await this.confirm(created.orderNo, "ZERO_AMOUNT");
          if (outcome !== "CONFIRMED" && outcome !== "ALREADY_PAID" && outcome !== "DELIVERY_PENDING") {
            if (outcome === "DELIVERY_FAILED") appError(created.fulfillmentSource === "SUPPLIER" ? "SUPPLIER_PURCHASE_UNAVAILABLE" : "ORDER_DELIVERY_FAILED");
            appError("PAYMENT_CONFIRM_FAILED");
          }
          return { ...created, payment: null, paymentStatus: "PAID" };
        } catch (cause) {
          await closePendingOrder(this.database, created.id, { eventType: "CLOSE_ON_FAILURE", message: "0 元订单确认失败，已关闭并释放库存与优惠券" }).catch((closeCause) => reportUnexpectedServerError("payment-close-zero-order-failed", closeCause, { orderId: created.id, orderNo: created.orderNo }));
          throw cause;
        }
      }

      const externalUrl = await this.buildExternalPayUrl({
        productId: input.productId,
        productSkuId: input.productSkuId,
        orderNo: created.orderNo,
        amount: created.amount,
        currency: created.currency,
        quantity: input.quantity,
        email: input.contactValue,
        locale,
      });
      await logs.writeBestEffort({
        orderId: created.id,
        provider: "EXTERNAL_LINK",
        orderNo: created.orderNo,
        eventType: "CREATE",
        verifyStatus: "PENDING",
        message: "已创建外部支付订单，等待买家付款与管理员确认收款",
        payload: { url: externalUrl, currency: created.currency, exchangeRate: created.exchangeRate },
      });
      return { ...created, payment: { mode: "redirect", url: externalUrl } };
    }

    const definition = getProviderDefinition(input.paymentProvider);
    if (!definition) appError("PAYMENT_PROVIDER_NOT_AVAILABLE");
    const provider = await getEnabledPaymentProvider(this.database, input.paymentProvider);
    if (!provider) appError("PAYMENT_PROVIDER_NOT_AVAILABLE");
    const channel = input.paymentChannel ?? provider.channels[0];
    if (provider.channels.length > 0 && (!channel || !provider.channels.includes(channel))) appError("PAYMENT_CHANNEL_INVALID");
    const created = await createOrder(this.database, { ...input, locale, paymentChannel: channel, allowPendingPayment: true } as CreateOrderInput, ownerUserId);
    const logs = new PaymentLogService(this.database);
    if (created.amount === 0) {
      try {
        const outcome = await this.confirm(created.orderNo, "ZERO_AMOUNT");
        if (outcome !== "CONFIRMED" && outcome !== "ALREADY_PAID" && outcome !== "DELIVERY_PENDING") {
          if (outcome === "DELIVERY_FAILED") appError(created.fulfillmentSource === "SUPPLIER" ? "SUPPLIER_PURCHASE_UNAVAILABLE" : "ORDER_DELIVERY_FAILED");
          appError("PAYMENT_CONFIRM_FAILED");
        }
        return { ...created, payment: null, paymentStatus: "PAID" };
      } catch (cause) {
        await closePendingOrder(this.database, created.id, { eventType: "CLOSE_ON_FAILURE", message: "0 元订单确认失败，已关闭并释放库存与优惠券" }).catch((closeCause) => reportUnexpectedServerError("payment-close-zero-order-failed", closeCause, { orderId: created.id, orderNo: created.orderNo }));
        throw cause;
      }
    }
    const repository = paymentRepository(this.database);
    const attemptId = await repository.createAttempt({ orderId: created.id, provider: provider.provider, channel });
    if (attemptId === null) {
      await closePendingOrder(this.database, created.id, { eventType: "CLOSE_ON_FAILURE", message: "支付尝试创建失败，订单已关闭并释放库存" }).catch((cause) => reportUnexpectedServerError("payment-attempt-create-close-failed", cause, { orderId: created.id, orderNo: created.orderNo }));
      appError("PAYMENT_CREATE_FAILED");
    }
    try {
      const config = JSON.parse(provider.configJson) as Record<string, unknown>;
      const site = await getSiteSettings(this.database);
      const urls = resolvePaymentUrls(provider.provider, site.siteUrl, config);
      const adapter = definition.createAdapter(config);
      const result = await adapter.create({ orderNo: created.orderNo, amount: created.amount, subject: paymentSubject(locale, created.orderNo), channel, notifyUrl: urls.notifyUrl, returnUrl: paymentReturnUrl(urls.returnUrl, created.orderNo), clientIp: clientIp ?? undefined });
      await repository.completeAttempt(attemptId, result.paymentOrderNo);
      await logs.writeBestEffort({ orderId: created.id, provider: provider.provider, orderNo: created.orderNo, paymentOrderNo: result.paymentOrderNo, eventType: "CREATE", verifyStatus: "PENDING", payload: { ...result, currency: created.currency, exchangeRate: created.exchangeRate } });
      return { ...created, payment: result };
    } catch (cause) {
      reportUnexpectedServerError("payment-create", cause, { orderId: created.id, orderNo: created.orderNo, provider: provider.provider });
      await repository.failAttempt(attemptId).catch(() => undefined);
      await logs.writeBestEffort({ orderId: created.id, provider: provider.provider, orderNo: created.orderNo, eventType: "CREATE_FAILED", verifyStatus: "FAILED", message: safePaymentCreateError(cause), payload: { error: safePaymentCreateError(cause) } });
      await closePendingOrder(this.database, created.id, { eventType: "CLOSE_ON_FAILURE", message: "支付请求创建失败，订单已关闭并释放库存" }).catch((closeCause) => reportUnexpectedServerError("payment-close-failed-order", closeCause, { orderId: created.id, orderNo: created.orderNo }));
      appError("PAYMENT_CREATE_FAILED");
    }
  }

  async resume(orderNo: string, ownerUserId: string | null, email?: string, locale?: StorefrontLocale, clientIp?: string | null): Promise<PaymentCreateResult> {
    const access = orderAccess(ownerUserId, email);
    if (!orderNo.trim() || !access) appError("ORDER_NOT_FOUND");
    const db = createDrizzleDb(this.database);
    const [record] = await db
      .select({ id: order.id, orderNo: order.orderNo, amount: order.amount, currency: order.currency, exchangeRate: order.exchangeRate, quantity: order.quantity, productId: order.productId, productSkuId: order.productSkuId, productNameSnapshot: order.productNameSnapshot, productSkuNameSnapshot: order.productSkuNameSnapshot, contactValue: order.contactValue, deliveryType: order.deliveryTypeSnapshot, physicalStockReserved: order.physicalStockReserved, paymentProvider: order.paymentProvider, paymentChannel: order.paymentChannel, locale: order.locale })
      .from(order)
      .where(and(eq(order.orderNo, orderNo.trim()), access, eq(order.status, "PENDING"), eq(order.paymentStatus, "UNPAID")))
      .limit(1);
    if (!record) appError("ORDER_NOT_FOUND");

    if (record.deliveryType === "CARD_AUTO") {
      if (record.productSkuId === null) appError("PRODUCT_SKU_NOT_AVAILABLE");
      const [stock] = await db.select({ available: count() }).from(card).where(and(eq(card.productSkuId, record.productSkuId), eq(card.status, "UNUSED")));
      if ((stock?.available ?? 0) < record.quantity) appError("PRODUCT_STOCK_NOT_ENOUGH");
    } else if ((record.deliveryType === "MANUAL" || record.deliveryType === "EXPRESS") && !record.physicalStockReserved) {
      if (record.productSkuId === null) appError("PRODUCT_SKU_NOT_AVAILABLE");
      const [sku] = await db.select({ physicalStock: productSku.physicalStock }).from(productSku).where(eq(productSku.id, record.productSkuId)).limit(1);
      if (sku?.physicalStock !== null && (sku?.physicalStock ?? 0) < record.quantity) appError("PRODUCT_STOCK_NOT_ENOUGH");
    }

    if (record.paymentProvider === "EXTERNAL_LINK") {
      const externalUrl = await this.buildExternalPayUrl({
        productId: record.productId,
        productSkuId: record.productSkuId,
        orderNo: record.orderNo,
        amount: record.amount,
        currency: record.currency,
        quantity: record.quantity,
        email: record.contactValue,
        locale: locale ?? (isStorefrontLocale(record.locale) ? record.locale : undefined),
        fallbackProductName: record.productNameSnapshot,
        fallbackSkuName: record.productSkuNameSnapshot,
      });
      await new PaymentLogService(this.database).writeBestEffort({
        orderId: record.id,
        provider: "EXTERNAL_LINK",
        orderNo: record.orderNo,
        eventType: "RESUME",
        verifyStatus: "PENDING",
        message: "用户重新打开外部支付链接",
        payload: { url: externalUrl, currency: record.currency, exchangeRate: record.exchangeRate },
      });
      return { orderNo: record.orderNo, amount: record.amount, currency: record.currency, paymentStatus: "UNPAID", payment: { mode: "redirect", url: externalUrl } };
    }

    const provider = await getEnabledPaymentProvider(this.database, record.paymentProvider as PaymentProviderKind, isCurrencyCode(record.currency) ? record.currency : "CNY");
    const definition = provider && getProviderDefinition(provider.provider);
    if (!provider || !definition) appError("PAYMENT_PROVIDER_NOT_AVAILABLE");

    const repository = paymentRepository(this.database);
    const attemptId = await repository.createAttempt({ orderId: record.id, provider: provider.provider, channel: record.paymentChannel });
    if (attemptId === null) appError("PAYMENT_CREATE_FAILED");
    try {
      const config = JSON.parse(provider.configJson) as Record<string, unknown>;
      const site = await getSiteSettings(this.database);
      const urls = resolvePaymentUrls(provider.provider, site.siteUrl, config);
      const payment = await definition.createAdapter(config).create({ orderNo: record.orderNo, amount: record.amount, subject: paymentSubject(locale ?? (isStorefrontLocale(record.locale) ? record.locale : undefined), record.orderNo), channel: record.paymentChannel as PaymentChannel | undefined, notifyUrl: urls.notifyUrl, returnUrl: paymentReturnUrl(urls.returnUrl, record.orderNo), clientIp: clientIp ?? undefined });
      await repository.completeAttempt(attemptId, payment.paymentOrderNo);
      await new PaymentLogService(this.database).writeBestEffort({ orderId: record.id, provider: provider.provider, orderNo: record.orderNo, paymentOrderNo: payment.paymentOrderNo, eventType: "RESUME", verifyStatus: "PENDING", payload: { ...payment, currency: record.currency, exchangeRate: record.exchangeRate } });
      return { orderNo: record.orderNo, amount: record.amount, currency: record.currency, paymentStatus: "UNPAID", payment };
    } catch (cause) {
      reportUnexpectedServerError("payment-resume", cause, { orderId: record.id, orderNo: record.orderNo, provider: provider.provider });
      await repository.failAttempt(attemptId).catch(() => undefined);
      await new PaymentLogService(this.database).writeBestEffort({ orderId: record.id, provider: provider.provider, orderNo: record.orderNo, eventType: "RESUME_FAILED", verifyStatus: "FAILED", message: safePaymentCreateError(cause), payload: { error: safePaymentCreateError(cause) } });
      appError("PAYMENT_CREATE_FAILED");
    }
  }

  async confirm(orderNo: string, source: string, amount?: number, paymentAttemptId?: number) {
    const repository = paymentRepository(this.database);
    const record = await repository.findOrder(orderNo);
    if (!record) appError("ORDER_NOT_FOUND");
    if (amount !== undefined && amount !== record.amount) appError("PAYMENT_AMOUNT_MISMATCH");
    const attempt = paymentAttemptId ? await repository.findAttempt(paymentAttemptId) : null;
    if (paymentAttemptId && (!attempt || attempt.orderId !== record.id)) appError("PAYMENT_CALLBACK_INVALID");
    const duplicatePayment = Boolean(paymentAttemptId && attempt?.status !== "PAID" && await repository.hasOtherPaidAttempt(record.id, paymentAttemptId));
    const result = await confirmOrderPayment(this.database, record.id);
    if (paymentAttemptId && result.outcome !== "NOT_PAYABLE") await repository.markAttemptPaid(paymentAttemptId);

    let outcome = result.outcome;
    let exceptionMessage: string | null = null;
    if (result.outcome === "PAYMENT_EXCEPTION") exceptionMessage = "订单关闭后收到付款，请人工核对支付流水并退款或处理。";
    else if (duplicatePayment) {
      outcome = "PAYMENT_EXCEPTION";
      exceptionMessage = "同一订单收到多个支付尝试的付款，请人工核对并处理重复收款。";
    }
    if (exceptionMessage && paymentAttemptId) {
      await enqueueOrderEvent(this.database, { eventKey: `payment-exception:${paymentAttemptId}`, orderId: record.id, scene: "PAYMENT_EXCEPTION", errorMessage: exceptionMessage });
    }
    await new PaymentLogService(this.database).writeBestEffort({ orderId: record.id, provider: record.paymentProvider as never, orderNo, eventType: "CONFIRM", verifyStatus: outcome === "NOT_PAYABLE" ? "FAILED" : "VERIFIED", message: result.deliveryError ? `${outcome}:${result.deliveryError}` : outcome, payload: { source, paymentAttemptId, exceptionMessage } });
    return outcome;
  }

  async query(orderNo: string, ownerUserId: string | null, email?: string) {
    const queriedOrder = await (await import("@/server/order/service")).getOrderForQuery(this.database, orderNo, ownerUserId, email);
    if (!queriedOrder || queriedOrder.paymentStatus !== "UNPAID") return queriedOrder;
    const record = await paymentRepository(this.database).findOrder(orderNo);
    if (!record || record.paymentProvider === "EXTERNAL_LINK") return queriedOrder;
    const provider = await getEnabledPaymentProvider(this.database, record.paymentProvider as never);
    const definition = provider && getProviderDefinition(provider.provider);
    if (!provider || !definition) return queriedOrder;
    try {
      const adapter = definition.createAdapter(JSON.parse(provider.configJson) as Record<string, unknown>);
      if (!adapter.query) return queriedOrder;
      const attempt = await paymentRepository(this.database).latestAttempt(record.id);
      const result = await adapter.query({ orderNo, paymentOrderNo: attempt?.paymentOrderNo ?? undefined, amount: record.amount });
      if (result.verified && result.status === "PAID" && result.amount === record.amount) {
        await this.confirm(orderNo, "QUERY", result.amount, attempt?.id);
        return (await import("@/server/order/service")).getOrderForQuery(this.database, orderNo, ownerUserId, email);
      }
    } catch {
      // A query failure must leave the local pending order queryable and retryable.
    }
    return queriedOrder;
  }
}

export function requirePaymentFlowService() {
  const context = getContext<RuntimeContext>();
  if (!context.env?.DB) appError("DATABASE_UNAVAILABLE");
  return new PaymentFlowService(context.env.DB, context.env);
}
