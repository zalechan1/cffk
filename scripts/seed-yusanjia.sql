-- AI 御三家（ChatGPT / Claude / Gemini）精选主订阅商品幂等初始化脚本（含 15% 加价与后台私密货源映射）
-- 严格幂等：不会覆盖管理员已自定义的支付配置、站点设置或历史订单数据。

-- 仅当站点仍处于默认初始名称 CFFK-Shop 时，更新为御三家默认品牌信息。
UPDATE `siteSetting` SET
  `siteName` = 'AI 御三家订阅中心',
  `siteSubtitle` = 'ChatGPT · Claude · Gemini 正规官方订阅与独享账号',
  `notice` = '专注 ChatGPT、Claude、Gemini 官方正价直充与独享成品号，下单前请仔细阅读对应规格说明。',
  `supportContact` = '售后支持|请在订单页查询订单状态或联系客服处理',
  `footerText` = '© 2026 AI 御三家订阅中心',
  `externalPayButtonText` = COALESCE(NULLIF(TRIM(`externalPayButtonText`), ''), '立即前往支付'),
  `updatedAt` = unixepoch('now') * 1000
WHERE `id` = 1 AND `siteName` = 'CFFK-Shop';

INSERT INTO `category` (`name`, `slug`, `description`, `sort`, `status`, `createdAt`, `updatedAt`) VALUES ('ChatGPT / OpenAI', 'chatgpt', 'ChatGPT Go / Plus / Pro 官方正价直充与独享成品账号', 10, 'ACTIVE', unixepoch('now') * 1000, unixepoch('now') * 1000) ON CONFLICT(`slug`) DO NOTHING;
INSERT INTO `category` (`name`, `slug`, `description`, `sort`, `status`, `createdAt`, `updatedAt`) VALUES ('Claude / Anthropic', 'claude', 'Claude Pro / Max 5x / Max 20x 官方直充与独享成品账号', 20, 'ACTIVE', unixepoch('now') * 1000, unixepoch('now') * 1000) ON CONFLICT(`slug`) DO NOTHING;
INSERT INTO `category` (`name`, `slug`, `description`, `sort`, `status`, `createdAt`, `updatedAt`) VALUES ('Gemini / Google AI', 'gemini', 'Google AI Pro / Ultra 5x / Ultra 20x 官方直充与独享账号', 30, 'ACTIVE', unixepoch('now') * 1000, unixepoch('now') * 1000) ON CONFLICT(`slug`) DO NOTHING;

-- 商品：ChatGPT 官方正价直充 · Go / Plus / 年卡
INSERT INTO `product_v2` (`categoryId`, `name`, `slug`, `subtitle`, `description`, `coverImage`, `status`, `manualDeliveryHint`, `sort`, `purchaseNote`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `category` WHERE `slug` = 'chatgpt'), 'ChatGPT 官方正价直充 · Go / Plus / 年卡', 'chatgpt-plus-topup', '支持 Go 月卡、Plus 菲区/美区 iOS 官充及年卡，直充个人账号', '<h3>产品介绍</h3>
<p>为您的个人 ChatGPT / OpenAI 账号提供正规官方渠道直充服务，涵盖高性价比 Go 会员、标准 Plus 月卡与全年官方订阅，支持新开与到期续费。</p>
<h3>可选规格说明</h3>
<ul>
  <li><strong>Go 月卡官方直充（¥35）</strong>：正规渠道 30 天订阅，适合日常高频对话与基础辅助使用。</li>
  <li><strong>Plus 半价资格专属直充（¥72）</strong>：仅限账号自身已获得官方半价优惠资格的用户下单充值。</li>
  <li><strong>Plus 菲区卡充月卡（¥134）</strong>：正规外币卡一卡一付，质保 30 天不掉订阅。</li>
  <li><strong>Plus 美区 iOS 官充月卡（¥152）</strong>：Apple 美区官方内购渠道，稳定度高，支持新开与续费。</li>
  <li><strong>Plus 美区 iOS 官方年卡（¥1518）</strong>：一次充值 12 个月官方订阅，省去每月续费烦恼。</li>
</ul>
<h3>使用须知</h3>
<ul>
  <li>适用范围：仅限个人账号直充，不支持处于苹果或谷歌未取消订阅状态的账号跨区覆盖。</li>
  <li>质保范围：质保所购周期内正常订阅状态不异常掉落；因违规使用或网络环境导致的封号不在质保范围内。</li>
</ul>', '/products/chatgpt-plus-topup.webp', 'ACTIVE', '下单后请保持联系畅通，支付后将尽快为您完成官方正价直充。', 10, '直充类商品下单前请确认账号当前无未到期的冲突订阅；付款后根据所选规格为您代充或提供指引。虚拟数字服务交付后不支持无理由退款。', unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `product_v2` WHERE `slug` = 'chatgpt-plus-topup');
UPDATE `product_v2` SET `description` = '<h3>产品介绍</h3>
<p>为您的个人 ChatGPT / OpenAI 账号提供正规官方渠道直充服务，涵盖高性价比 Go 会员、标准 Plus 月卡与全年官方订阅，支持新开与到期续费。</p>
<h3>可选规格说明</h3>
<ul>
  <li><strong>Go 月卡官方直充（¥35）</strong>：正规渠道 30 天订阅，适合日常高频对话与基础辅助使用。</li>
  <li><strong>Plus 半价资格专属直充（¥72）</strong>：仅限账号自身已获得官方半价优惠资格的用户下单充值。</li>
  <li><strong>Plus 菲区卡充月卡（¥134）</strong>：正规外币卡一卡一付，质保 30 天不掉订阅。</li>
  <li><strong>Plus 美区 iOS 官充月卡（¥152）</strong>：Apple 美区官方内购渠道，稳定度高，支持新开与续费。</li>
  <li><strong>Plus 美区 iOS 官方年卡（¥1518）</strong>：一次充值 12 个月官方订阅，省去每月续费烦恼。</li>
</ul>
<h3>使用须知</h3>
<ul>
  <li>适用范围：仅限个人账号直充，不支持处于苹果或谷歌未取消订阅状态的账号跨区覆盖。</li>
  <li>质保范围：质保所购周期内正常订阅状态不异常掉落；因违规使用或网络环境导致的封号不在质保范围内。</li>
</ul>', `updatedAt` = unixepoch('now') * 1000 WHERE `slug` = 'chatgpt-plus-topup' AND `description` LIKE '%¥30）%';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-topup'), 'Go 月卡官方直充', 3500, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G47020944', 3003, 99, 1, 10, 10, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-topup') AND `name` = 'Go 月卡官方直充');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G47020944'), `sourceCost` = COALESCE(`sourceCost`, 3003), `price` = CASE WHEN `price` = 3000 THEN 3500 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-topup') AND `name` = 'Go 月卡官方直充';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-topup'), 'Plus 半价资格专属直充', 7200, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G27122659', 6149, 99, 1, 10, 20, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-topup') AND `name` = 'Plus 半价资格专属直充');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G27122659'), `sourceCost` = COALESCE(`sourceCost`, 6149), `price` = CASE WHEN `price` = 6200 THEN 7200 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-topup') AND `name` = 'Plus 半价资格专属直充';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-topup'), 'Plus 菲区卡充月卡', 13400, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G40928328', 11555, 99, 1, 10, 30, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-topup') AND `name` = 'Plus 菲区卡充月卡');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G40928328'), `sourceCost` = COALESCE(`sourceCost`, 11555), `price` = CASE WHEN `price` = 11600 THEN 13400 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-topup') AND `name` = 'Plus 菲区卡充月卡';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-topup'), 'Plus 美区 iOS 官充月卡', 15200, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G93375633', 13155, 99, 1, 10, 40, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-topup') AND `name` = 'Plus 美区 iOS 官充月卡');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G93375633'), `sourceCost` = COALESCE(`sourceCost`, 13155), `price` = CASE WHEN `price` = 13200 THEN 15200 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-topup') AND `name` = 'Plus 美区 iOS 官充月卡';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-topup'), 'Plus 美区 iOS 官方年卡', 151800, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G25132608', 131970, 99, 1, 10, 50, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-topup') AND `name` = 'Plus 美区 iOS 官方年卡');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G25132608'), `sourceCost` = COALESCE(`sourceCost`, 131970), `price` = CASE WHEN `price` = 132000 THEN 151800 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-topup') AND `name` = 'Plus 美区 iOS 官方年卡';

-- 商品：ChatGPT Pro 官方正价直充 · Pro 100 / 200 / 500
INSERT INTO `product_v2` (`categoryId`, `name`, `slug`, `subtitle`, `description`, `coverImage`, `status`, `manualDeliveryHint`, `sort`, `purchaseNote`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `category` WHERE `slug` = 'chatgpt'), 'ChatGPT Pro 官方正价直充 · Pro 100 / 200 / 500', 'chatgpt-pro-topup', '面向重度用户与科研开发者的官方高倍率 Pro 个人直充方案', '<h3>产品介绍</h3>
<p>提供 ChatGPT Pro 系列官方正价直充服务，涵盖 $100（5x/10x 档位）、$200（20x 档位）与 $500（25x/50x 顶配档位），全部采用正规银行卡或美区 iOS 渠道充值到您的个人账号。</p>
<h3>可选规格说明</h3>
<ul>
  <li><strong>Pro $100 智利/埃及卡充月卡（¥746）</strong>：正规外币卡支付，30 天订阅质保，性价比优选。</li>
  <li><strong>Pro $100 美区 iOS 官充月卡（¥757）</strong>：美区苹果官方正价代充，账单清晰稳定。</li>
  <li><strong>Pro $200 菲区卡充月卡（¥1214）</strong>：官方 $200 档位正价月卡直充，适合重度 Codex 与推理需求。</li>
  <li><strong>Pro $200 美区 iOS 官充月卡（¥1536）</strong>：美区苹果内购直充，稳定度极高。</li>
  <li><strong>Pro $500 官方卡充月卡（¥3657）</strong>：最高额度档位 30 天官方直充，满足高并发深度工作流。</li>
</ul>
<h3>使用须知</h3>
<ul>
  <li>建议保持账号处于干净 IP 环境下使用，避免多人共享或高频异常触发风控。</li>
  <li>质保周期内非违规原因导致的掉订阅问题，按官方同步政策处理。</li>
</ul>', '/products/chatgpt-pro-topup.webp', 'ACTIVE', 'Pro 系列直充需按排单顺序核对账号状态后操作，请耐心等待客服交付。', 20, '高客单直充请务必先确认账号状态正常且为 Free 或符合升级覆盖条件；开票需求请在备注中提前说明。', unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `product_v2` WHERE `slug` = 'chatgpt-pro-topup');
UPDATE `product_v2` SET `description` = '<h3>产品介绍</h3>
<p>提供 ChatGPT Pro 系列官方正价直充服务，涵盖 $100（5x/10x 档位）、$200（20x 档位）与 $500（25x/50x 顶配档位），全部采用正规银行卡或美区 iOS 渠道充值到您的个人账号。</p>
<h3>可选规格说明</h3>
<ul>
  <li><strong>Pro $100 智利/埃及卡充月卡（¥746）</strong>：正规外币卡支付，30 天订阅质保，性价比优选。</li>
  <li><strong>Pro $100 美区 iOS 官充月卡（¥757）</strong>：美区苹果官方正价代充，账单清晰稳定。</li>
  <li><strong>Pro $200 菲区卡充月卡（¥1214）</strong>：官方 $200 档位正价月卡直充，适合重度 Codex 与推理需求。</li>
  <li><strong>Pro $200 美区 iOS 官充月卡（¥1536）</strong>：美区苹果内购直充，稳定度极高。</li>
  <li><strong>Pro $500 官方卡充月卡（¥3657）</strong>：最高额度档位 30 天官方直充，满足高并发深度工作流。</li>
</ul>
<h3>使用须知</h3>
<ul>
  <li>建议保持账号处于干净 IP 环境下使用，避免多人共享或高频异常触发风控。</li>
  <li>质保周期内非违规原因导致的掉订阅问题，按官方同步政策处理。</li>
</ul>', `updatedAt` = unixepoch('now') * 1000 WHERE `slug` = 'chatgpt-pro-topup' AND `description` LIKE '%¥648）%';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-pro-topup'), 'Pro $100 智利/埃及卡充月卡', 74600, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G28244383', 64800, 99, 1, 10, 10, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-pro-topup') AND `name` = 'Pro $100 智利/埃及卡充月卡');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G28244383'), `sourceCost` = COALESCE(`sourceCost`, 64800), `price` = CASE WHEN `price` = 64800 THEN 74600 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-pro-topup') AND `name` = 'Pro $100 智利/埃及卡充月卡';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-pro-topup'), 'Pro $100 美区 iOS 官充月卡', 75700, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G47645473', 65800, 99, 1, 10, 20, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-pro-topup') AND `name` = 'Pro $100 美区 iOS 官充月卡');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G47645473'), `sourceCost` = COALESCE(`sourceCost`, 65800), `price` = CASE WHEN `price` = 65800 THEN 75700 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-pro-topup') AND `name` = 'Pro $100 美区 iOS 官充月卡';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-pro-topup'), 'Pro $200 菲区卡充月卡', 121400, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G28956781', 105599, 99, 1, 10, 30, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-pro-topup') AND `name` = 'Pro $200 菲区卡充月卡');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G28956781'), `sourceCost` = COALESCE(`sourceCost`, 105599), `price` = CASE WHEN `price` = 105500 THEN 121400 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-pro-topup') AND `name` = 'Pro $200 菲区卡充月卡';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-pro-topup'), 'Pro $200 美区 iOS 官充月卡', 153600, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G58301745', 133560, 99, 1, 10, 40, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-pro-topup') AND `name` = 'Pro $200 美区 iOS 官充月卡');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G58301745'), `sourceCost` = COALESCE(`sourceCost`, 133560), `price` = CASE WHEN `price` = 133500 THEN 153600 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-pro-topup') AND `name` = 'Pro $200 美区 iOS 官充月卡';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-pro-topup'), 'Pro $500 官方卡充月卡', 365700, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G58061132', 318000, 99, 1, 10, 50, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-pro-topup') AND `name` = 'Pro $500 官方卡充月卡');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G58061132'), `sourceCost` = COALESCE(`sourceCost`, 318000), `price` = CASE WHEN `price` = 318000 THEN 365700 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-pro-topup') AND `name` = 'Pro $500 官方卡充月卡';

-- 商品：ChatGPT Plus 独享成品号 · 实卡开通
INSERT INTO `product_v2` (`categoryId`, `name`, `slug`, `subtitle`, `description`, `coverImage`, `status`, `manualDeliveryHint`, `sort`, `purchaseNote`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `category` WHERE `slug` = 'chatgpt'), 'ChatGPT Plus 独享成品号 · 实卡开通', 'chatgpt-plus-account', '一人一号独立使用，涵盖月卡、已接码直登 Codex 及长效认证成品号', '<h3>产品介绍</h3>
<p>精选稳定渠道的 ChatGPT Plus 个人独享成品账号，避免个人注册与绑卡门槛，支持网页端与 Codex 桌面/CLI 端使用。</p>
<h3>可选规格说明</h3>
<ul>
  <li><strong>谷歌/越南实卡 Plus 独享月卡（¥67）</strong>：实卡开通独立邮箱账号，提供完整账密与 2FA。</li>
  <li><strong>已接码直登 Codex 双质保月卡（¥83）</strong>：已完成手机接码验证，可直接登录 Codex 客户端，享 30 天订阅与封号双质保。</li>
  <li><strong>菲区半价实付带账单月卡（¥90）</strong>：正规卡付实付开通，账单记录完整，质保 30 天订阅。</li>
  <li><strong>独享 2 个月 Plus 成品号（¥182）</strong>：60 天长效独立邮箱成品号，减少频繁换号烦恼。</li>
  <li><strong>独享 12 个月认证 Plus 成品号（¥621）</strong>：一年期优惠认证独享账号，交付需 1-2 个工作日排单，质保首登 36 小时。</li>
</ul>
<h3>使用须知</h3>
<ul>
  <li>请使用干净稳定的海外家宽或原生节点登录，避免公共廉价机场节点。</li>
  <li>长期成品号到手后请尽快核对邮箱与安全设置。</li>
</ul>', '/products/chatgpt-plus-account.webp', 'ACTIVE', '购买后将为您交付独享账号、密码及 2FA 密钥或专属邮箱登录凭证。', 30, '成品号交付后请及时登录并修改密码与二次验证信息（2FA），切勿随意频繁更换登录节点。', unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `product_v2` WHERE `slug` = 'chatgpt-plus-account');
UPDATE `product_v2` SET `description` = '<h3>产品介绍</h3>
<p>精选稳定渠道的 ChatGPT Plus 个人独享成品账号，避免个人注册与绑卡门槛，支持网页端与 Codex 桌面/CLI 端使用。</p>
<h3>可选规格说明</h3>
<ul>
  <li><strong>谷歌/越南实卡 Plus 独享月卡（¥67）</strong>：实卡开通独立邮箱账号，提供完整账密与 2FA。</li>
  <li><strong>已接码直登 Codex 双质保月卡（¥83）</strong>：已完成手机接码验证，可直接登录 Codex 客户端，享 30 天订阅与封号双质保。</li>
  <li><strong>菲区半价实付带账单月卡（¥90）</strong>：正规卡付实付开通，账单记录完整，质保 30 天订阅。</li>
  <li><strong>独享 2 个月 Plus 成品号（¥182）</strong>：60 天长效独立邮箱成品号，减少频繁换号烦恼。</li>
  <li><strong>独享 12 个月认证 Plus 成品号（¥621）</strong>：一年期优惠认证独享账号，交付需 1-2 个工作日排单，质保首登 36 小时。</li>
</ul>
<h3>使用须知</h3>
<ul>
  <li>请使用干净稳定的海外家宽或原生节点登录，避免公共廉价机场节点。</li>
  <li>长期成品号到手后请尽快核对邮箱与安全设置。</li>
</ul>', `updatedAt` = unixepoch('now') * 1000 WHERE `slug` = 'chatgpt-plus-account' AND `description` LIKE '%¥58）%';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-account'), '谷歌/越南实卡 Plus 独享月卡', 6700, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G40761844', 5830, 99, 1, 10, 10, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-account') AND `name` = '谷歌/越南实卡 Plus 独享月卡');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G40761844'), `sourceCost` = COALESCE(`sourceCost`, 5830), `price` = CASE WHEN `price` = 5800 THEN 6700 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-account') AND `name` = '谷歌/越南实卡 Plus 独享月卡';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-account'), '已接码直登 Codex 双质保月卡', 8300, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G43240937', 7150, 99, 1, 10, 20, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-account') AND `name` = '已接码直登 Codex 双质保月卡');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G43240937'), `sourceCost` = COALESCE(`sourceCost`, 7150), `price` = CASE WHEN `price` = 7200 THEN 8300 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-account') AND `name` = '已接码直登 Codex 双质保月卡';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-account'), '菲区半价实付带账单月卡', 9000, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G85784428', 7680, 99, 1, 10, 30, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-account') AND `name` = '菲区半价实付带账单月卡');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G85784428'), `sourceCost` = COALESCE(`sourceCost`, 7680), `price` = CASE WHEN `price` = 7800 THEN 9000 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-account') AND `name` = '菲区半价实付带账单月卡';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-account'), '独享 2 个月 Plus 成品号', 18200, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G81505009', 15805, 99, 1, 10, 40, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-account') AND `name` = '独享 2 个月 Plus 成品号');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G81505009'), `sourceCost` = COALESCE(`sourceCost`, 15805), `price` = CASE WHEN `price` = 15800 THEN 18200 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-account') AND `name` = '独享 2 个月 Plus 成品号';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-account'), '独享 12 个月认证 Plus 成品号', 62100, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G69410663', 54000, 99, 1, 10, 50, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-account') AND `name` = '独享 12 个月认证 Plus 成品号');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G69410663'), `sourceCost` = COALESCE(`sourceCost`, 54000), `price` = CASE WHEN `price` = 54000 THEN 62100 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-plus-account') AND `name` = '独享 12 个月认证 Plus 成品号';

-- 商品：ChatGPT Pro 独享成品号 · Pro 100 / 200 / 500
INSERT INTO `product_v2` (`categoryId`, `name`, `slug`, `subtitle`, `description`, `coverImage`, `status`, `manualDeliveryHint`, `sort`, `purchaseNote`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `category` WHERE `slug` = 'chatgpt'), 'ChatGPT Pro 独享成品号 · Pro 100 / 200 / 500', 'chatgpt-pro-account', '高配 Pro 100 / 200 / 500 独立成品号，老号稳态不降智', '<h3>产品介绍</h3>
<p>针对需要即买即用高配额度的开发者与团队个人，提供正规实付开通的 ChatGPT Pro 100 / 200 / 500 独享成品账号。</p>
<h3>可选规格说明</h3>
<ul>
  <li><strong>Pro $100 美区独享成品号（¥746）</strong>：官方 $100 档位独享成品号，质保 30 天订阅。</li>
  <li><strong>Pro $200 谷歌邮箱独享成品号（¥1242）</strong>：绑定独立谷歌邮箱，支持续费与换绑，稳定不降智。</li>
  <li><strong>Pro $500 顶配独享成品号（¥3220）</strong>：官方最高档位 Pro 500 独享账号，适合大规模编程与长上下文推理。</li>
</ul>
<h3>使用须知</h3>
<ul>
  <li>独享成品号严禁转售或多人异地同时登录，以免触发 OpenAI 安全风控。</li>
</ul>', '/products/chatgpt-pro-account.webp', 'ACTIVE', '支付成功后将按订单顺序为您分配并交付对应档位的独享 Pro 成品号。', 40, 'Pro 成品号均为一人一卡独立交付，请在收到账号后尽快验证登录与会员有效期。', unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `product_v2` WHERE `slug` = 'chatgpt-pro-account');
UPDATE `product_v2` SET `description` = '<h3>产品介绍</h3>
<p>针对需要即买即用高配额度的开发者与团队个人，提供正规实付开通的 ChatGPT Pro 100 / 200 / 500 独享成品账号。</p>
<h3>可选规格说明</h3>
<ul>
  <li><strong>Pro $100 美区独享成品号（¥746）</strong>：官方 $100 档位独享成品号，质保 30 天订阅。</li>
  <li><strong>Pro $200 谷歌邮箱独享成品号（¥1242）</strong>：绑定独立谷歌邮箱，支持续费与换绑，稳定不降智。</li>
  <li><strong>Pro $500 顶配独享成品号（¥3220）</strong>：官方最高档位 Pro 500 独享账号，适合大规模编程与长上下文推理。</li>
</ul>
<h3>使用须知</h3>
<ul>
  <li>独享成品号严禁转售或多人异地同时登录，以免触发 OpenAI 安全风控。</li>
</ul>', `updatedAt` = unixepoch('now') * 1000 WHERE `slug` = 'chatgpt-pro-account' AND `description` LIKE '%¥648）%';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-pro-account'), 'Pro $100 美区独享成品号', 74600, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G58650883', 64800, 99, 1, 10, 10, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-pro-account') AND `name` = 'Pro $100 美区独享成品号');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G58650883'), `sourceCost` = COALESCE(`sourceCost`, 64800), `price` = CASE WHEN `price` = 64800 THEN 74600 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-pro-account') AND `name` = 'Pro $100 美区独享成品号';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-pro-account'), 'Pro $200 谷歌邮箱独享成品号', 124200, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G80530130', 108000, 99, 1, 10, 20, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-pro-account') AND `name` = 'Pro $200 谷歌邮箱独享成品号');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G80530130'), `sourceCost` = COALESCE(`sourceCost`, 108000), `price` = CASE WHEN `price` = 108000 THEN 124200 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-pro-account') AND `name` = 'Pro $200 谷歌邮箱独享成品号';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-pro-account'), 'Pro $500 顶配独享成品号', 322000, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G95556592', 280800, 99, 1, 10, 30, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-pro-account') AND `name` = 'Pro $500 顶配独享成品号');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G95556592'), `sourceCost` = COALESCE(`sourceCost`, 280800), `price` = CASE WHEN `price` = 280000 THEN 322000 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'chatgpt-pro-account') AND `name` = 'Pro $500 顶配独享成品号';

-- 商品：Claude 官方正价直充 · Pro / Max 5x / 20x
INSERT INTO `product_v2` (`categoryId`, `name`, `slug`, `subtitle`, `description`, `coverImage`, `status`, `manualDeliveryHint`, `sort`, `purchaseNote`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `category` WHERE `slug` = 'claude'), 'Claude 官方正价直充 · Pro / Max 5x / 20x', 'claude-official-topup', '支持官方美卡与苹果 iOS 渠道直充至本人 Claude 账号', '<h3>产品介绍</h3>
<p>为您的个人 Claude 账号提供官方正价 Pro 与 Max（5x / 20x）月度直充服务，区分便捷的 iOS/美卡渠道与高稳定实体卡渠道。</p>
<h3>可选规格说明</h3>
<ul>
  <li><strong>Claude Pro 美卡直充月卡（¥211）</strong>：官方美卡正规代充，适合个人日常与轻量代码辅助。</li>
  <li><strong>Claude Pro iOS 官方直充月卡（¥241）</strong>：美区苹果内购正规通道，账单稳定。</li>
  <li><strong>Claude Max 5x iOS/美卡直充（¥961）</strong>：5 倍高额度套餐直充（建议老号或已过 KYC 账号使用）。</li>
  <li><strong>Claude Max 5x 实体卡正价代充（¥1425）</strong>：实体卡一卡一付，风控抗性更高。</li>
  <li><strong>Claude Max 20x iOS/美卡直充（¥1885）</strong>：20 倍旗舰额度直充，适合重度 Claude Code 工作流。</li>
  <li><strong>Claude Max 20x 实体卡正价代充（¥2510）</strong>：高稳定性实体卡正价直充方案。</li>
</ul>
<h3>使用须知</h3>
<ul>
  <li>Max 档位 iOS 渠道通常要求注册时间较早的老号或已完成 KYC 认证的账号。</li>
  <li>使用期间请尽量固定干净独享的美区或欧洲节点，切勿频繁切换不同国家 IP。</li>
</ul>', '/products/claude-official-topup.webp', 'ACTIVE', '下单后请配合提供账号充值所需状态确认，iOS 渠道建议提前备好干净稳定的使用环境。', 10, 'Claude 对网络环境和账号风控较为敏感，直充服务质保订阅到账与周期内订阅有效，封号不在质保范围内。', unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `product_v2` WHERE `slug` = 'claude-official-topup');
UPDATE `product_v2` SET `description` = '<h3>产品介绍</h3>
<p>为您的个人 Claude 账号提供官方正价 Pro 与 Max（5x / 20x）月度直充服务，区分便捷的 iOS/美卡渠道与高稳定实体卡渠道。</p>
<h3>可选规格说明</h3>
<ul>
  <li><strong>Claude Pro 美卡直充月卡（¥211）</strong>：官方美卡正规代充，适合个人日常与轻量代码辅助。</li>
  <li><strong>Claude Pro iOS 官方直充月卡（¥241）</strong>：美区苹果内购正规通道，账单稳定。</li>
  <li><strong>Claude Max 5x iOS/美卡直充（¥961）</strong>：5 倍高额度套餐直充（建议老号或已过 KYC 账号使用）。</li>
  <li><strong>Claude Max 5x 实体卡正价代充（¥1425）</strong>：实体卡一卡一付，风控抗性更高。</li>
  <li><strong>Claude Max 20x iOS/美卡直充（¥1885）</strong>：20 倍旗舰额度直充，适合重度 Claude Code 工作流。</li>
  <li><strong>Claude Max 20x 实体卡正价代充（¥2510）</strong>：高稳定性实体卡正价直充方案。</li>
</ul>
<h3>使用须知</h3>
<ul>
  <li>Max 档位 iOS 渠道通常要求注册时间较早的老号或已完成 KYC 认证的账号。</li>
  <li>使用期间请尽量固定干净独享的美区或欧洲节点，切勿频繁切换不同国家 IP。</li>
</ul>', `updatedAt` = unixepoch('now') * 1000 WHERE `slug` = 'claude-official-topup' AND `description` LIKE '%¥183）%';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-official-topup'), 'Claude Pro 美卡直充月卡', 21100, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G61862632', 17222, 99, 1, 10, 10, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-official-topup') AND `name` = 'Claude Pro 美卡直充月卡');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G61862632'), `sourceCost` = COALESCE(`sourceCost`, 17222), `price` = CASE WHEN `price` = 18300 THEN 21100 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-official-topup') AND `name` = 'Claude Pro 美卡直充月卡';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-official-topup'), 'Claude Pro iOS 官方直充月卡', 24100, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G28058494', 20900, 99, 1, 10, 20, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-official-topup') AND `name` = 'Claude Pro iOS 官方直充月卡');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G28058494'), `sourceCost` = COALESCE(`sourceCost`, 20900), `price` = CASE WHEN `price` = 20900 THEN 24100 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-official-topup') AND `name` = 'Claude Pro iOS 官方直充月卡';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-official-topup'), 'Claude Max 5x iOS/美卡直充', 96100, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G83188152', 83490, 99, 1, 10, 30, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-official-topup') AND `name` = 'Claude Max 5x iOS/美卡直充');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G83188152'), `sourceCost` = COALESCE(`sourceCost`, 83490), `price` = CASE WHEN `price` = 83500 THEN 96100 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-official-topup') AND `name` = 'Claude Max 5x iOS/美卡直充';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-official-topup'), 'Claude Max 5x 实体卡正价代充', 142500, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G83817726', 123914, 99, 1, 10, 40, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-official-topup') AND `name` = 'Claude Max 5x 实体卡正价代充');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G83817726'), `sourceCost` = COALESCE(`sourceCost`, 123914), `price` = CASE WHEN `price` = 123900 THEN 142500 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-official-topup') AND `name` = 'Claude Max 5x 实体卡正价代充';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-official-topup'), 'Claude Max 20x iOS/美卡直充', 188500, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G57255952', 163900, 99, 1, 10, 50, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-official-topup') AND `name` = 'Claude Max 20x iOS/美卡直充');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G57255952'), `sourceCost` = COALESCE(`sourceCost`, 163900), `price` = CASE WHEN `price` = 163900 THEN 188500 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-official-topup') AND `name` = 'Claude Max 20x iOS/美卡直充';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-official-topup'), 'Claude Max 20x 实体卡正价代充', 251000, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G82468129', 218254, 99, 1, 10, 60, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-official-topup') AND `name` = 'Claude Max 20x 实体卡正价代充');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G82468129'), `sourceCost` = COALESCE(`sourceCost`, 218254), `price` = CASE WHEN `price` = 218200 THEN 251000 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-official-topup') AND `name` = 'Claude Max 20x 实体卡正价代充';

-- 商品：Claude Pro 独享成品号 · 免 KYC / 已过 KYC
INSERT INTO `product_v2` (`categoryId`, `name`, `slug`, `subtitle`, `description`, `coverImage`, `status`, `manualDeliveryHint`, `sort`, `purchaseNote`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `category` WHERE `slug` = 'claude'), 'Claude Pro 独享成品号 · 免 KYC / 已过 KYC', 'claude-pro-account', '实卡正规开通，提供免 KYC 与已完成美区 KYC 认证多档方案', '<h3>产品介绍</h3>
<p>针对需要开箱即用的 Claude Pro 用户，提供正规海外实卡开通的独享月卡成品号，并区分免 KYC 与已过 KYC 认证版本。</p>
<h3>可选规格说明</h3>
<ul>
  <li><strong>Claude Pro 实卡免 KYC 独享月卡（¥356）</strong>：美区实卡正价开通，无需额外繁琐验证即可上手。</li>
  <li><strong>Claude Pro 已过美区 KYC 独享月卡（¥436）</strong>：已完成高质量美区实名认证，抗风控能力显著提升。</li>
  <li><strong>Claude Pro 过 KYC 附稳定环境方案（¥481）</strong>：在过 KYC 成品号基础上提供稳定登录环境指引，省心更耐活。</li>
</ul>
<h3>使用须知</h3>
<ul>
  <li>质保范围：保证首登成功与 30 天订阅完整有效；非渠道原因的个人操作违规封号不包赔。</li>
</ul>', '/products/claude-pro-account.webp', 'ACTIVE', '下单后将为您交付独立邮箱与 Claude 登录方式，免去注册验证烦恼。', 20, '使用 Claude 成品号请务必搭配纯净独享代理环境，首次登录请确认网络纯净度，因自身节点污染导致的封号不予质保。', unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `product_v2` WHERE `slug` = 'claude-pro-account');
UPDATE `product_v2` SET `description` = '<h3>产品介绍</h3>
<p>针对需要开箱即用的 Claude Pro 用户，提供正规海外实卡开通的独享月卡成品号，并区分免 KYC 与已过 KYC 认证版本。</p>
<h3>可选规格说明</h3>
<ul>
  <li><strong>Claude Pro 实卡免 KYC 独享月卡（¥356）</strong>：美区实卡正价开通，无需额外繁琐验证即可上手。</li>
  <li><strong>Claude Pro 已过美区 KYC 独享月卡（¥436）</strong>：已完成高质量美区实名认证，抗风控能力显著提升。</li>
  <li><strong>Claude Pro 过 KYC 附稳定环境方案（¥481）</strong>：在过 KYC 成品号基础上提供稳定登录环境指引，省心更耐活。</li>
</ul>
<h3>使用须知</h3>
<ul>
  <li>质保范围：保证首登成功与 30 天订阅完整有效；非渠道原因的个人操作违规封号不包赔。</li>
</ul>', `updatedAt` = unixepoch('now') * 1000 WHERE `slug` = 'claude-pro-account' AND `description` LIKE '%¥309）%';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-pro-account'), 'Claude Pro 实卡免 KYC 独享月卡', 35600, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G97644432', 30952, 99, 1, 10, 10, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-pro-account') AND `name` = 'Claude Pro 实卡免 KYC 独享月卡');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G97644432'), `sourceCost` = COALESCE(`sourceCost`, 30952), `price` = CASE WHEN `price` = 30900 THEN 35600 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-pro-account') AND `name` = 'Claude Pro 实卡免 KYC 独享月卡';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-pro-account'), 'Claude Pro 已过美区 KYC 独享月卡', 43600, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G49544523', 37932, 99, 1, 10, 20, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-pro-account') AND `name` = 'Claude Pro 已过美区 KYC 独享月卡');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G49544523'), `sourceCost` = COALESCE(`sourceCost`, 37932), `price` = CASE WHEN `price` = 37900 THEN 43600 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-pro-account') AND `name` = 'Claude Pro 已过美区 KYC 独享月卡';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-pro-account'), 'Claude Pro 过 KYC 附稳定环境方案', 48100, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G35770826', 41800, 99, 1, 10, 30, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-pro-account') AND `name` = 'Claude Pro 过 KYC 附稳定环境方案');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G35770826'), `sourceCost` = COALESCE(`sourceCost`, 41800), `price` = CASE WHEN `price` = 41800 THEN 48100 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-pro-account') AND `name` = 'Claude Pro 过 KYC 附稳定环境方案';

-- 商品：Claude Max 独享成品号 · Max 5x / 20x
INSERT INTO `product_v2` (`categoryId`, `name`, `slug`, `subtitle`, `description`, `coverImage`, `status`, `manualDeliveryHint`, `sort`, `purchaseNote`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `category` WHERE `slug` = 'claude'), 'Claude Max 独享成品号 · Max 5x / 20x', 'claude-max-account', '专为高强度 Claude Code 开发者打造的大额高稳定性独享成品号', '<h3>产品介绍</h3>
<p>面向重度使用 Claude 网页端及 Claude Code CLI 的工程师与团队，提供 5 倍与 20 倍额度的独享 Max 成品号，均为海外实卡正价支付开通。</p>
<h3>可选规格说明</h3>
<ul>
  <li><strong>Max 5x 实卡免 KYC 成品号（¥1429）</strong>：实卡开通 5 倍额度，适合中重度日常开发。</li>
  <li><strong>Max 5x 已过 KYC 正价订阅号（¥1613）</strong>：已通过 KYC 认证的 5x 成品号，稳定性更佳。</li>
  <li><strong>Max 20x 实卡免 KYC 成品号（¥2609）</strong>：20 倍超大额度实卡免 K 成品，畅享持续高并发编程体验。</li>
  <li><strong>Max 20x 已过 KYC 正价订阅号（¥2855）</strong>：过 KYC 顶配 20x 成品号，高强度长会话首选。</li>
</ul>
<h3>使用须知</h3>
<ul>
  <li>质保首登及 30 天正常订阅状态，请勿使用公共机场节点或频繁异地登录。</li>
</ul>', '/products/claude-max-account.webp', 'ACTIVE', '交付独立成品账号与对应邮箱权限，支持按月续费。', 30, 'Max 5x/20x 属于高价值订阅，请全程固定干净住宅/原生 IP 使用，避免多人共享或异常并发请求。', unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `product_v2` WHERE `slug` = 'claude-max-account');
UPDATE `product_v2` SET `description` = '<h3>产品介绍</h3>
<p>面向重度使用 Claude 网页端及 Claude Code CLI 的工程师与团队，提供 5 倍与 20 倍额度的独享 Max 成品号，均为海外实卡正价支付开通。</p>
<h3>可选规格说明</h3>
<ul>
  <li><strong>Max 5x 实卡免 KYC 成品号（¥1429）</strong>：实卡开通 5 倍额度，适合中重度日常开发。</li>
  <li><strong>Max 5x 已过 KYC 正价订阅号（¥1613）</strong>：已通过 KYC 认证的 5x 成品号，稳定性更佳。</li>
  <li><strong>Max 20x 实卡免 KYC 成品号（¥2609）</strong>：20 倍超大额度实卡免 K 成品，畅享持续高并发编程体验。</li>
  <li><strong>Max 20x 已过 KYC 正价订阅号（¥2855）</strong>：过 KYC 顶配 20x 成品号，高强度长会话首选。</li>
</ul>
<h3>使用须知</h3>
<ul>
  <li>质保首登及 30 天正常订阅状态，请勿使用公共机场节点或频繁异地登录。</li>
</ul>', `updatedAt` = unixepoch('now') * 1000 WHERE `slug` = 'claude-max-account' AND `description` LIKE '%¥1242）%';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-max-account'), 'Max 5x 实卡免 KYC 成品号', 142900, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G82877550', 124200, 99, 1, 10, 10, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-max-account') AND `name` = 'Max 5x 实卡免 KYC 成品号');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G82877550'), `sourceCost` = COALESCE(`sourceCost`, 124200), `price` = CASE WHEN `price` = 124200 THEN 142900 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-max-account') AND `name` = 'Max 5x 实卡免 KYC 成品号';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-max-account'), 'Max 5x 已过 KYC 正价订阅号', 161300, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G18635080', 140292, 99, 1, 10, 20, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-max-account') AND `name` = 'Max 5x 已过 KYC 正价订阅号');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G18635080'), `sourceCost` = COALESCE(`sourceCost`, 140292), `price` = CASE WHEN `price` = 140200 THEN 161300 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-max-account') AND `name` = 'Max 5x 已过 KYC 正价订阅号';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-max-account'), 'Max 20x 实卡免 KYC 成品号', 260900, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G92744796', 226800, 99, 1, 10, 30, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-max-account') AND `name` = 'Max 20x 实卡免 KYC 成品号');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G92744796'), `sourceCost` = COALESCE(`sourceCost`, 226800), `price` = CASE WHEN `price` = 226800 THEN 260900 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-max-account') AND `name` = 'Max 20x 实卡免 KYC 成品号';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-max-account'), 'Max 20x 已过 KYC 正价订阅号', 285500, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G22569692', 248292, 99, 1, 10, 40, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-max-account') AND `name` = 'Max 20x 已过 KYC 正价订阅号');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G22569692'), `sourceCost` = COALESCE(`sourceCost`, 248292), `price` = CASE WHEN `price` = 248200 THEN 285500 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'claude-max-account') AND `name` = 'Max 20x 已过 KYC 正价订阅号';

-- 商品：Gemini 官方个人直充 · AI Pro / Ultra 5x / 20x
INSERT INTO `product_v2` (`categoryId`, `name`, `slug`, `subtitle`, `description`, `coverImage`, `status`, `manualDeliveryHint`, `sort`, `purchaseNote`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `category` WHERE `slug` = 'gemini'), 'Gemini 官方个人直充 · AI Pro / Ultra 5x / 20x', 'gemini-official-topup', '支持 Google AI Pro 与 Ultra 5x / 20x 个人独享直充，非家庭组拼车', '<h3>产品介绍</h3>
<p>为您的个人 Google 账号直接开通官方 Google AI Pro 或 Google AI Ultra（5x / 20x）订阅权益，独享账号权限与完整云端/AI 配额。</p>
<h3>可选规格说明</h3>
<ul>
  <li><strong>Google AI Pro iOS 月卡直充（¥171）</strong>：官方 $20 档位正规个人代充，质保 30 天。</li>
  <li><strong>Google AI Pro 官方年卡直充（¥969）</strong>：一年期 $99.99 官方优惠直充，适合长期主力用户。</li>
  <li><strong>Google AI Ultra 5x iOS 月卡（¥620）</strong>：5 倍高额 Ultra 月卡 iOS 渠道代充。</li>
  <li><strong>Google AI Ultra 5x 官网正规卡充（¥746）</strong>：非家庭组官网卡付直充，账单完整稳定。</li>
  <li><strong>Google AI Ultra 20x 土区 iOS 月卡（¥861）</strong>：高性价比土区 iOS 正规代充方案，质保到账与订阅期使用。</li>
  <li><strong>Google AI Ultra 20x 正规 iOS/官网直充（¥1202）</strong>：旗舰 20x 官方 $200 档位直充，满足视频、图像与最高模型配额需求。</li>
</ul>
<h3>使用须知</h3>
<ul>
  <li>下单前如有旧的 Google One 订阅未清理，请先解除以免影响官方渠道直充。</li>
</ul>', '/products/gemini-official-topup.webp', 'ACTIVE', '下单后请保持联系畅通，支付后客服将协助完成个人账号官方直充。', 10, '直充到您的个人谷歌账号，非家庭组共享车位；购买前请确保您的 Google 账号未处于其他异常订阅或欠费状态。', unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `product_v2` WHERE `slug` = 'gemini-official-topup');
UPDATE `product_v2` SET `description` = '<h3>产品介绍</h3>
<p>为您的个人 Google 账号直接开通官方 Google AI Pro 或 Google AI Ultra（5x / 20x）订阅权益，独享账号权限与完整云端/AI 配额。</p>
<h3>可选规格说明</h3>
<ul>
  <li><strong>Google AI Pro iOS 月卡直充（¥171）</strong>：官方 $20 档位正规个人代充，质保 30 天。</li>
  <li><strong>Google AI Pro 官方年卡直充（¥969）</strong>：一年期 $99.99 官方优惠直充，适合长期主力用户。</li>
  <li><strong>Google AI Ultra 5x iOS 月卡（¥620）</strong>：5 倍高额 Ultra 月卡 iOS 渠道代充。</li>
  <li><strong>Google AI Ultra 5x 官网正规卡充（¥746）</strong>：非家庭组官网卡付直充，账单完整稳定。</li>
  <li><strong>Google AI Ultra 20x 土区 iOS 月卡（¥861）</strong>：高性价比土区 iOS 正规代充方案，质保到账与订阅期使用。</li>
  <li><strong>Google AI Ultra 20x 正规 iOS/官网直充（¥1202）</strong>：旗舰 20x 官方 $200 档位直充，满足视频、图像与最高模型配额需求。</li>
</ul>
<h3>使用须知</h3>
<ul>
  <li>下单前如有旧的 Google One 订阅未清理，请先解除以免影响官方渠道直充。</li>
</ul>', `updatedAt` = unixepoch('now') * 1000 WHERE `slug` = 'gemini-official-topup' AND `description` LIKE '%¥148）%';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'gemini-official-topup'), 'Google AI Pro iOS 月卡直充', 17100, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G34740216', 14850, 99, 1, 10, 10, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'gemini-official-topup') AND `name` = 'Google AI Pro iOS 月卡直充');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G34740216'), `sourceCost` = COALESCE(`sourceCost`, 14850), `price` = CASE WHEN `price` = 14800 THEN 17100 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'gemini-official-topup') AND `name` = 'Google AI Pro iOS 月卡直充';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'gemini-official-topup'), 'Google AI Pro 官方年卡直充', 96900, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G69286074', 84240, 99, 1, 10, 20, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'gemini-official-topup') AND `name` = 'Google AI Pro 官方年卡直充');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G69286074'), `sourceCost` = COALESCE(`sourceCost`, 84240), `price` = CASE WHEN `price` = 84200 THEN 96900 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'gemini-official-topup') AND `name` = 'Google AI Pro 官方年卡直充';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'gemini-official-topup'), 'Google AI Ultra 5x iOS 月卡', 62000, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G20455050', 53900, 99, 1, 10, 30, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'gemini-official-topup') AND `name` = 'Google AI Ultra 5x iOS 月卡');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G20455050'), `sourceCost` = COALESCE(`sourceCost`, 53900), `price` = CASE WHEN `price` = 53900 THEN 62000 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'gemini-official-topup') AND `name` = 'Google AI Ultra 5x iOS 月卡';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'gemini-official-topup'), 'Google AI Ultra 5x 官网正规卡充', 74600, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G48301136', 64800, 99, 1, 10, 40, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'gemini-official-topup') AND `name` = 'Google AI Ultra 5x 官网正规卡充');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G48301136'), `sourceCost` = COALESCE(`sourceCost`, 64800), `price` = CASE WHEN `price` = 64800 THEN 74600 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'gemini-official-topup') AND `name` = 'Google AI Ultra 5x 官网正规卡充';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'gemini-official-topup'), 'Google AI Ultra 20x 土区 iOS 月卡', 86100, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G19594509', 74800, 99, 1, 10, 50, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'gemini-official-topup') AND `name` = 'Google AI Ultra 20x 土区 iOS 月卡');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G19594509'), `sourceCost` = COALESCE(`sourceCost`, 74800), `price` = CASE WHEN `price` = 74800 THEN 86100 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'gemini-official-topup') AND `name` = 'Google AI Ultra 20x 土区 iOS 月卡';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'gemini-official-topup'), 'Google AI Ultra 20x 正规 iOS/官网直充', 120200, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G40362121', 104500, 99, 1, 10, 60, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'gemini-official-topup') AND `name` = 'Google AI Ultra 20x 正规 iOS/官网直充');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G40362121'), `sourceCost` = COALESCE(`sourceCost`, 104500), `price` = CASE WHEN `price` = 104500 THEN 120200 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'gemini-official-topup') AND `name` = 'Google AI Ultra 20x 正规 iOS/官网直充';

-- 商品：Gemini Pro 独享成品号与多月代开
INSERT INTO `product_v2` (`categoryId`, `name`, `slug`, `subtitle`, `description`, `coverImage`, `status`, `manualDeliveryHint`, `sort`, `purchaseNote`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `category` WHERE `slug` = 'gemini'), 'Gemini Pro 独享成品号与多月代开', 'gemini-pro-account', '提供 3~6 个月个人代开与含完整登录凭证的独享 Gemini Pro 成品号', '<h3>产品介绍</h3>
<p>提供高性价比的多月 Google AI Pro / Gemini Pro 订阅获取方案，支持在您的自有账号代开，也提供开箱即用的独享成品号。</p>
<h3>可选规格说明</h3>
<ul>
  <li><strong>Gemini Pro 3~6 个月个人代开（¥38）</strong>：为符合条件的个人谷歌账号代开 3~6 个月 Pro 权益，性价比极高。</li>
  <li><strong>Gemini Pro 3~6 个月独享成品号（¥68）</strong>：含完整谷歌账号及登录凭证（RT/JSON），保 1 小时内首次登录正常，到手即用。</li>
</ul>
<h3>使用须知</h3>
<ul>
  <li>请在收到成品号后第一时间完成登录验证，避免长时间闲置未登录。</li>
</ul>', '/products/gemini-pro-account.webp', 'ACTIVE', '下单后将为您安排个人账号代开或交付全套独享成品号凭证。', 20, '多月优惠活动款请严格按照交付指引在纯净网络下登录使用，首登正常后建议绑定个人辅助安全信息。', unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `product_v2` WHERE `slug` = 'gemini-pro-account');
UPDATE `product_v2` SET `description` = '<h3>产品介绍</h3>
<p>提供高性价比的多月 Google AI Pro / Gemini Pro 订阅获取方案，支持在您的自有账号代开，也提供开箱即用的独享成品号。</p>
<h3>可选规格说明</h3>
<ul>
  <li><strong>Gemini Pro 3~6 个月个人代开（¥38）</strong>：为符合条件的个人谷歌账号代开 3~6 个月 Pro 权益，性价比极高。</li>
  <li><strong>Gemini Pro 3~6 个月独享成品号（¥68）</strong>：含完整谷歌账号及登录凭证（RT/JSON），保 1 小时内首次登录正常，到手即用。</li>
</ul>
<h3>使用须知</h3>
<ul>
  <li>请在收到成品号后第一时间完成登录验证，避免长时间闲置未登录。</li>
</ul>', `updatedAt` = unixepoch('now') * 1000 WHERE `slug` = 'gemini-pro-account' AND `description` LIKE '%¥33）%';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'gemini-pro-account'), 'Gemini Pro 3~6 个月个人代开', 3800, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G88177611', 3300, 99, 1, 10, 10, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'gemini-pro-account') AND `name` = 'Gemini Pro 3~6 个月个人代开');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G88177611'), `sourceCost` = COALESCE(`sourceCost`, 3300), `price` = CASE WHEN `price` = 3300 THEN 3800 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'gemini-pro-account') AND `name` = 'Gemini Pro 3~6 个月个人代开';
INSERT INTO `productSku` (`productId`, `name`, `price`, `status`, `fulfillmentSource`, `deliveryType`, `sourceUrl`, `sourceCost`, `physicalStock`, `minBuy`, `maxBuy`, `sort`, `createdAt`, `updatedAt`)
SELECT (SELECT `id` FROM `product_v2` WHERE `slug` = 'gemini-pro-account'), 'Gemini Pro 3~6 个月独享成品号', 6800, 'ACTIVE', 'LOCAL', 'MANUAL', 'https://www.16688.com.cn/goods/G73451004', 5940, 99, 1, 10, 20, unixepoch('now') * 1000, unixepoch('now') * 1000
WHERE NOT EXISTS (SELECT 1 FROM `productSku` WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'gemini-pro-account') AND `name` = 'Gemini Pro 3~6 个月独享成品号');
UPDATE `productSku` SET `sourceUrl` = COALESCE(NULLIF(TRIM(`sourceUrl`), ''), 'https://www.16688.com.cn/goods/G73451004'), `sourceCost` = COALESCE(`sourceCost`, 5940), `price` = CASE WHEN `price` = 5900 THEN 6800 ELSE `price` END, `updatedAt` = unixepoch('now') * 1000 WHERE `productId` = (SELECT `id` FROM `product_v2` WHERE `slug` = 'gemini-pro-account') AND `name` = 'Gemini Pro 3~6 个月独享成品号';

-- 若默认分类下无在售商品，停用之以免首页出现空分类标签。
UPDATE `category` SET `status` = 'DISABLED', `updatedAt` = unixepoch('now') * 1000 WHERE `slug` = 'default' AND NOT EXISTS (SELECT 1 FROM `product_v2` WHERE `categoryId` = `category`.`id` AND `status` = 'ACTIVE');
