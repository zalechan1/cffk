const ALLOWED_PROTOCOLS = new Set(["http:", "https:"]);
const MAX_EXTERNAL_PAY_URL_LENGTH = 2_000;

export function normalizeExternalPayUrl(value: unknown, errorCode = "EXTERNAL_PAY_URL_INVALID"): string | null {
  if (value === undefined || value === null) return null;
  const normalized = String(value).trim();
  if (!normalized) return null;
  if (normalized.length > MAX_EXTERNAL_PAY_URL_LENGTH) {
    throw new Error(errorCode);
  }

  try {
    const url = new URL(normalized);
    if (!ALLOWED_PROTOCOLS.has(url.protocol)) {
      throw new Error(errorCode);
    }
    return normalized;
  } catch {
    throw new Error(errorCode);
  }
}

export function normalizeSourceUrl(value: unknown, errorCode = "PRODUCT_SOURCE_URL_INVALID"): string | null {
  return normalizeExternalPayUrl(value, errorCode);
}

export type ExternalPayContext = {
  orderNo?: string;
  slug?: string;
  product?: string;
  sku?: string;
  price?: string;
  quantity?: number;
  email?: string;
};

export function resolveExternalPayUrl(params: {
  skuUrl?: string | null;
  productUrl?: string | null;
  siteUrl?: string | null;
  context?: ExternalPayContext;
}): string | null {
  const raw = params.skuUrl?.trim() || params.productUrl?.trim() || params.siteUrl?.trim() || "";
  if (!raw) return null;

  let candidate: string;
  try {
    const parsed = new URL(raw);
    if (!ALLOWED_PROTOCOLS.has(parsed.protocol)) return null;
    candidate = raw;
  } catch {
    return null;
  }

  const ctx = params.context ?? {};
  const replacements: Record<string, string> = {
    orderNo: ctx.orderNo ?? "",
    slug: ctx.slug ?? "",
    product: ctx.product ?? "",
    sku: ctx.sku ?? "",
    price: ctx.price ?? "",
    quantity: ctx.quantity !== undefined ? String(ctx.quantity) : "",
    email: ctx.email ?? "",
  };

  return candidate.replace(/\{(orderNo|slug|product|sku|price|quantity|email)\}/g, (_, key: string) => {
    return encodeURIComponent(replacements[key] ?? "");
  });
}
