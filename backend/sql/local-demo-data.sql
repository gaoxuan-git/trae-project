-- CRMEB local development demo data.
-- Idempotent: only rows owned by DEMO-SEED-V1 are replaced.
-- Target database: dexter_dianshang

SET NAMES utf8mb4;
SET @demo_tag = '[DEMO-SEED-V1]';
SET @seed_now = NOW();
SET @old_foreign_key_checks = @@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS = 0;

START TRANSACTION;

-- Remove a previous run in dependency order.
DELETE FROM eb_store_product_reply WHERE product_id BETWEEN 8101 AND 8124;
DELETE FROM eb_store_pink WHERE cid BETWEEN 8101 AND 8103;
DELETE FROM eb_store_order_status WHERE oid BETWEEN 8101 AND 8180;
DELETE FROM eb_store_order_info WHERE order_id BETWEEN 8101 AND 8180;
DELETE FROM eb_store_order
WHERE id BETWEEN 8101 AND 8180 AND remark = @demo_tag;
DELETE FROM eb_store_cart
WHERE uid BETWEEN 8101 AND 8120 OR product_id BETWEEN 8101 AND 8124;
DELETE FROM eb_store_product_relation
WHERE uid BETWEEN 8101 AND 8120 OR product_id BETWEEN 8101 AND 8124;
DELETE FROM eb_store_coupon_user WHERE coupon_id BETWEEN 8101 AND 8105;
DELETE FROM eb_user_bill WHERE uid BETWEEN 8101 AND 8120;
DELETE FROM eb_user_address WHERE uid BETWEEN 8101 AND 8120;
DELETE FROM eb_user_visit_record
WHERE uid BETWEEN 8101 AND 8120
   OR id BETWEEN 830001 AND 830900
   OR id BETWEEN -830900 AND -830001;
DELETE FROM eb_product_day_record
WHERE product_id BETWEEN 8101 AND 8124
   OR id BETWEEN 820001 AND 821080
   OR id BETWEEN -821080 AND -820001;
DELETE FROM eb_shopping_product_day_record
WHERE id BETWEEN 811001 AND 811045 OR id BETWEEN -811045 AND -811001;
DELETE FROM eb_trading_day_record
WHERE id BETWEEN 810001 AND 810045 OR id BETWEEN -810045 AND -810001;
DELETE FROM eb_store_product_description
WHERE product_id BETWEEN 8101 AND 8124 AND type IN (0, 1, 2, 3);
DELETE FROM eb_store_product_attr_result
WHERE product_id BETWEEN 8101 AND 8124 AND type IN (0, 1, 2, 3);
DELETE FROM eb_store_product_attr_option
WHERE product_id BETWEEN 8101 AND 8124;
DELETE FROM eb_store_product_attr_value
WHERE product_id BETWEEN 8101 AND 8124 AND type IN (0, 1, 2, 3);
DELETE FROM eb_store_product_attr
WHERE product_id BETWEEN 8101 AND 8124 AND type IN (0, 1, 2, 3);
DELETE FROM eb_store_seckill WHERE id BETWEEN 8101 AND 8104;
DELETE FROM eb_store_combination WHERE id BETWEEN 8101 AND 8103;
DELETE FROM eb_store_bargain WHERE id BETWEEN 8101 AND 8103;
DELETE FROM eb_store_coupon WHERE id BETWEEN 8101 AND 8105;
DELETE FROM eb_article WHERE id BETWEEN 8101 AND 8106;
DELETE FROM eb_store_product
WHERE id BETWEEN 8101 AND 8124 AND soure_link = 'demo-seed-v1';
DELETE FROM eb_user
WHERE uid BETWEEN 8101 AND 8120 AND mark = @demo_tag;

DROP TEMPORARY TABLE IF EXISTS tmp_demo_numbers;
CREATE TEMPORARY TABLE tmp_demo_numbers (n INT PRIMARY KEY) ENGINE = MEMORY;
INSERT INTO tmp_demo_numbers (n)
SELECT tens.n * 10 + ones.n + 1
FROM (
    SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
    UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
) AS ones
CROSS JOIN (
    SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
    UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7
) AS tens
WHERE tens.n * 10 + ones.n + 1 <= 80;

DROP TEMPORARY TABLE IF EXISTS tmp_demo_products;
CREATE TEMPORARY TABLE tmp_demo_products (
    id INT PRIMARY KEY,
    store_name VARCHAR(128) NOT NULL,
    store_info VARCHAR(256) NOT NULL,
    keyword VARCHAR(256) NOT NULL,
    cate_id VARCHAR(64) NOT NULL,
    image VARCHAR(256) NOT NULL,
    price DECIMAL(8, 2) NOT NULL,
    ot_price DECIMAL(8, 2) NOT NULL,
    cost DECIMAL(8, 2) NOT NULL,
    stock INT NOT NULL,
    sales INT NOT NULL,
    sort_num INT NOT NULL,
    unit_name VARCHAR(32) NOT NULL,
    attr_name VARCHAR(32) NOT NULL,
    option_one VARCHAR(32) NOT NULL,
    option_two VARCHAR(32) NOT NULL,
    weight DECIMAL(8, 2) NOT NULL
) ENGINE = MEMORY;

INSERT INTO tmp_demo_products VALUES
(8101, '净氧家用空气净化器 Pro', '卧室客厅两用，三档净化与静音睡眠模式', '空气净化器 家电 静音', '300', 'crmebimage/public/content/2025/11/10/fe500f6b69324b2eade1068a65311ad3102sb0pnzx.png', 699.00, 899.00, 420.00, 168, 126, 240, '台', '型号', '标准版', '除醛版', 4.80),
(8102, '双门恒温保鲜冷藏柜', '家庭商用两相宜，独立分区保鲜不串味', '保鲜柜 冷藏 厨房家电', '275', 'crmebimage/public/content/2025/11/10/7a54cadf0e074e9682915ab7ae0f3c93yziq66raw7.png', 2399.00, 2899.00, 1680.00, 46, 38, 239, '台', '容量', '210L', '310L', 38.00),
(8103, '柔顺定型护发乳', '顺直毛躁发丝，清爽不黏腻，日常造型可用', '护发 定型 柔顺', '296', 'crmebimage/public/content/2025/10/16/e53fd75e8b594218a0d1a1020361c1750himjc9eo2.png', 79.00, 109.00, 32.00, 420, 286, 238, '瓶', '净含量', '120ml', '200ml', 0.25),
(8104, '轻商务女士短款风衣', '利落廓形与防风面料，通勤休闲均可搭配', '女装 风衣 通勤', '745', 'crmebimage/public/user/2025/11/07/3b359670a28e429db46eec57e3b0b2ddugxv49lz0e.png', 269.00, 359.00, 138.00, 126, 93, 237, '件', '尺码', 'M', 'L', 0.68),
(8105, '儿童防风连帽外套', '柔软亲肤里料，轻量防风，适合春秋出行', '童装 外套 防风', '745', 'crmebimage/public/user/2025/10/17/a6665aef5de643448cc2cf6edb86fce13frz1e1rtt.png', 159.00, 219.00, 76.00, 188, 145, 236, '件', '尺码', '110cm', '130cm', 0.42),
(8106, '原生竹浆抽纸 24 包装', '柔韧亲肤不易破，居家囤货大包装', '抽纸 竹浆 家庭装', '301', 'crmebimage/public/product/2025/05/30/e9e93bfe8405409eb5343e440eadd99b9st8jlsh4x.png', 49.90, 69.90, 25.00, 560, 438, 235, '箱', '规格', '3层100抽', '4层90抽', 3.20),
(8107, '儿童音乐摇摇马', '圆角设计，稳固底座，适合一至三岁儿童', '摇摇马 玩具 儿童', '287', 'crmebimage/public/product/2025/05/30/153464ade9a044c197fcf80032ee01a4ixxppzo7nt.png', 189.00, 259.00, 98.00, 92, 67, 234, '台', '款式', '基础款', '音乐款', 4.20),
(8108, '花漾女士淡香水礼盒', '清新花果香调，日常通勤自然不浓烈', '香水 礼盒 女士', '294', 'crmebimage/public/product/2025/05/30/58bde6dca3814cd085fa95e4a02c415dbfvihmv3s0.png', 239.00, 329.00, 112.00, 134, 101, 233, '盒', '容量', '30ml', '50ml', 0.48),
(8109, '声波净护电动牙刷套装', '五档洁齿模式，长续航，附两支替换刷头', '电动牙刷 声波 清洁', '291', 'crmebimage/public/product/2025/05/30/ffab698f137943deb0b6706d1f1554a3e2ow1bkexu.png', 169.00, 229.00, 83.00, 260, 214, 232, '套', '颜色', '月光白', '深海蓝', 0.38),
(8110, '轻量缓震运动跑鞋', '透气网面与缓震中底，适合日常慢跑及通勤', '跑鞋 运动鞋 缓震', '796', 'crmebimage/public/product/2025/05/30/0095dabf00964e1d97c2c1d413da85e9750u8b4ihu.png', 299.00, 399.00, 146.00, 176, 132, 231, '双', '尺码', '39-40', '41-42', 0.72),
(8111, '桌面静音循环风扇', '小巧便携，三档风量，办公室卧室均适用', '风扇 桌面 静音', '300', 'crmebimage/public/product/2025/05/30/a10fff4ffa944e15b4d351df9407ce4f6etk3hzw4f.png', 89.00, 129.00, 43.00, 315, 249, 230, '台', '供电', 'USB款', '充电款', 0.65),
(8112, '婴幼儿温和洗护四件套', '低泡易冲洗，温和配方，满足日常清洁护理', '婴儿 洗护 套装', '806', 'crmebimage/public/product/2025/05/30/d0cbc3eda6ce456b974385d1672b88695niva5d35z.png', 129.00, 169.00, 62.00, 228, 174, 229, '套', '规格', '基础4件套', '礼盒6件套', 1.30),
(8113, '专业滑雪板固定器', '高强度支撑与快速调节，适配主流单板雪鞋', '滑雪 固定器 户外', '288', 'crmebimage/public/product/2025/05/30/f6dc9f3df7b947eabcbe1419f3fcc83ecslaa1ghjs.png', 799.00, 999.00, 468.00, 58, 41, 228, '副', '尺码', 'M', 'L', 2.40),
(8114, '轻奢偏光太阳镜', '高清偏光镜片，修饰脸型，附便携镜盒', '太阳镜 偏光 出行', '802', 'crmebimage/public/product/2025/05/30/67e68e5b72f6441faeae6238ea9a1c077ey7c2czat.png', 159.00, 229.00, 68.00, 204, 159, 227, '副', '镜片', '茶色', '灰色', 0.18),
(8115, '都市彩妆旅行礼盒', '日常妆容常用组合，便携收纳，送礼自用皆宜', '彩妆 礼盒 旅行', '293', 'crmebimage/public/product/2025/05/30/1ff119cd8ba7423ead3c10c502fa7d30m4e9mhmg5i.png', 329.00, 429.00, 171.00, 118, 86, 226, '盒', '套装', '日常版', '进阶版', 0.92),
(8116, '星愿银饰串珠手链', '简约百搭设计，可调节链长，独立礼盒包装', '手链 银饰 礼物', '296', 'crmebimage/public/product/2025/05/30/77e30c1e50884d36bd06fc43529e28227y9e4nkq9j.png', 199.00, 299.00, 91.00, 152, 113, 225, '条', '长度', '16cm', '18cm', 0.12),
(8117, '男士连帽休闲卫衣', '柔软棉感面料，宽松版型，适合秋冬叠穿', '男装 卫衣 连帽', '744', 'crmebimage/public/product/2025/05/30/19b9b999408f4782a6b60029a32b054aqij7q3loyd.png', 219.00, 289.00, 105.00, 194, 151, 224, '件', '尺码', 'L', 'XL', 0.78),
(8118, '植萃洁净洗衣液 4 瓶装', '低泡易漂洗，清新留香，适用机洗与手洗', '洗衣液 清洁 家庭装', '300', 'crmebimage/public/product/2025/05/30/c2682e7e42374ab6961be9697cd512fdv4xjfnzaoo.png', 69.90, 99.00, 35.00, 380, 302, 223, '箱', '香型', '清新皂香', '自然花香', 4.50),
(8119, '婴幼儿配方奶粉 800g', '科学营养配比，细腻易冲调，罐装密封保存', '奶粉 婴幼儿 营养', '286', 'crmebimage/public/product/2025/05/30/929741df9f1640319bd577c195cfcb03wl574zcffs.png', 268.00, 328.00, 196.00, 144, 108, 222, '罐', '阶段', '2段', '3段', 0.95),
(8120, '复古纹理通勤手提包', '多分区收纳，挺括包型，可手提可斜挎', '女包 手提包 通勤', '801', 'crmebimage/public/product/2025/05/30/c575c57aae8b419eb539afb5d45b92d9sm8xsmdu8a.png', 459.00, 599.00, 228.00, 87, 62, 221, '只', '颜色', '经典黑', '摩卡棕', 0.86),
(8121, '女士中长款通勤风衣', '简洁剪裁与垂顺面料，适合多场景穿搭', '女装 风衣 中长款', '745', 'crmebimage/public/product/2025/11/06/aa811171fb26464c8d54b219179a67b867cluy3vs9.png', 399.00, 529.00, 198.00, 105, 79, 220, '件', '尺码', 'M', 'L', 0.96),
(8122, '轻薄智能手机 256GB', '高清影像、全天续航与顺滑系统体验', '手机 智能 数码', '804', 'crmebimage/public/theme/20260623091518/images/3b570808fc3593aa51b2a94ceaba3e6f.png', 2999.00, 3499.00, 2380.00, 72, 54, 219, '台', '存储', '256GB', '512GB', 0.42),
(8123, '全天候运动智能腕表', '健康监测、运动记录与消息提醒，支持长续航', '手表 智能 穿戴', '298', 'crmebimage/public/theme/20260623091518/images/21_5ae4f6a3f8bf153beb849e02e14b5c40.png', 899.00, 1099.00, 612.00, 96, 73, 218, '块', '表带', '硅胶表带', '皮质表带', 0.16),
(8124, '全自动研磨咖啡机', '一键研磨萃取，支持浓度调节与自动清洁', '咖啡机 研磨 厨房家电', '277', 'crmebimage/public/theme/20260623091518/images/cf5414089d598d064b0a4d7154a4f491.png', 1899.00, 2399.00, 1320.00, 64, 49, 217, '台', '配置', '基础版', '奶泡版', 8.50);

-- Products, variants and rich detail content.
INSERT INTO eb_store_product (
    id, mer_id, image, slider_image, store_name, store_info, keyword, bar_code, cate_id,
    price, vip_price, ot_price, postage, unit_name, sort, sales, stock, is_show, is_hot,
    is_benefit, is_best, is_new, add_time, is_postage, is_del, mer_use, give_integral,
    cost, is_seckill, is_bargain, is_good, is_sub, ficti, browse, code_path, soure_link,
    video_link, temp_id, spec_type, activity, flat_pattern, is_recycle, version, guarantee_ids
)
SELECT
    p.id, 0, p.image, JSON_ARRAY(p.image, p.image), p.store_name, p.store_info, p.keyword,
    CONCAT('D', p.id), p.cate_id, p.price, ROUND(p.price * 0.95, 2), p.ot_price, 0,
    p.unit_name, p.sort_num, p.sales, p.stock, 1, IF(MOD(p.id, 3) = 0, 1, 0),
    IF(MOD(p.id, 4) = 0, 1, 0), IF(MOD(p.id, 5) = 0, 1, 0), IF(MOD(p.id, 2) = 0, 1, 0),
    UNIX_TIMESTAMP(DATE_SUB(@seed_now, INTERVAL MOD(p.id, 45) DAY)), 1, 0, 0,
    FLOOR(p.price / 10), p.cost, IF(p.id IN (8101, 8109, 8110, 8124), 1, 0),
    IF(p.id IN (8104, 8114, 8123), 1, 0), IF(MOD(p.id, 4) = 1, 1, 0), 0,
    FLOOR(p.sales * 0.35), 900 + MOD(p.id * 37, 1800), '', 'demo-seed-v1', '', 1, 1,
    '0,1,2,3', p.image, 0, 0, '0'
FROM tmp_demo_products p;

INSERT INTO eb_store_product_attr
    (id, product_id, attr_name, attr_values, type, is_del, is_show_image)
SELECT 18100 + (id - 8100), id, attr_name, CONCAT(option_one, ',', option_two), 0, 0, 1
FROM tmp_demo_products;

INSERT INTO eb_store_product_attr_option
    (id, product_id, attr_id, option_name, image, sort, is_del)
SELECT 38099 + (id - 8100) * 2, id, 18100 + (id - 8100), option_one, image, 1, 0
FROM tmp_demo_products;

INSERT INTO eb_store_product_attr_option
    (id, product_id, attr_id, option_name, image, sort, is_del)
SELECT 38100 + (id - 8100) * 2, id, 18100 + (id - 8100), option_two, image, 2, 0
FROM tmp_demo_products;

INSERT INTO eb_store_product_attr_value (
    id, product_id, suk, stock, sales, price, image, `unique`, cost, bar_code, ot_price,
    weight, volume, brokerage, brokerage_two, type, quota, quota_show, attr_value,
    is_del, version, is_default, is_show
)
SELECT
    28099 + (id - 8100) * 2, id, option_one, CEIL(stock * 0.60), CEIL(sales * 0.60),
    price, image, CONCAT('D', LPAD((id - 8100) * 2 - 1, 7, '0')), cost,
    CONCAT('D', id, 'A'), ot_price, weight, 0, ROUND(price * 0.06, 2),
    ROUND(price * 0.02, 2), 0, 0, 0, JSON_OBJECT(attr_name, option_one), 0, 0, 1, 1
FROM tmp_demo_products;

INSERT INTO eb_store_product_attr_value (
    id, product_id, suk, stock, sales, price, image, `unique`, cost, bar_code, ot_price,
    weight, volume, brokerage, brokerage_two, type, quota, quota_show, attr_value,
    is_del, version, is_default, is_show
)
SELECT
    28100 + (id - 8100) * 2, id, option_two, FLOOR(stock * 0.40), FLOOR(sales * 0.40),
    ROUND(price * 1.10, 2), image, CONCAT('D', LPAD((id - 8100) * 2, 7, '0')),
    ROUND(cost * 1.08, 2), CONCAT('D', id, 'B'), ROUND(ot_price * 1.08, 2), weight, 0,
    ROUND(price * 0.065, 2), ROUND(price * 0.025, 2), 0, 0, 0,
    JSON_OBJECT(attr_name, option_two), 0, 0, 0, 1
FROM tmp_demo_products;

INSERT INTO eb_store_product_description (id, product_id, description, type)
SELECT
    18100 + (id - 8100), id,
    CONCAT(
        '<section style="line-height:1.8;color:#333"><h2>', store_name,
        '</h2><p>', store_info,
        '</p><img src="http://127.0.0.1:8080/', image,
        '" style="width:100%;height:auto;display:block" />',
        '<h3>商品亮点</h3><p>精选材质，严格质检，本地现货，支持售后保障。</p>',
        '<h3>温馨提示</h3><p>页面规格与价格以实际选择结果为准。</p></section>'
    ),
    0
FROM tmp_demo_products;

-- Marketing activities.
DROP TEMPORARY TABLE IF EXISTS tmp_demo_seckill;
CREATE TEMPORARY TABLE tmp_demo_seckill (
    id INT PRIMARY KEY, product_id INT NOT NULL, time_id INT NOT NULL, discount DECIMAL(5, 2) NOT NULL
) ENGINE = MEMORY;
INSERT INTO tmp_demo_seckill VALUES
(8101, 8101, 1, 0.78), (8102, 8109, 2, 0.75), (8103, 8110, 3, 0.80), (8104, 8124, 2, 0.82);

INSERT INTO eb_store_seckill (
    id, product_id, image, images, title, info, price, cost, ot_price, give_integral,
    sort, stock, sales, unit_name, postage, description, start_time, stop_time, create_time,
    status, is_postage, is_del, num, is_show, time_id, temp_id, weight, volume,
    quota, quota_show, spec_type
)
SELECT
    s.id, p.id, p.image, JSON_ARRAY(p.image), CONCAT('限时秒杀 · ', p.store_name),
    CONCAT('限量直降，售完即止：', p.store_info), ROUND(p.price * s.discount, 2), p.cost,
    p.ot_price, FLOOR(p.price / 20), 100 - (s.id - 8100), 48, 16 + (s.id - 8100) * 3,
    p.unit_name, 0,
    CONCAT('<p>限时秒杀活动商品：', p.store_name, '</p><img src="http://127.0.0.1:8080/', p.image, '" style="width:100%" />'),
    DATE_SUB(@seed_now, INTERVAL 1 DAY), DATE_ADD(@seed_now, INTERVAL 30 DAY), @seed_now,
    1, 1, 0, 3, 1, s.time_id, 1, p.weight, 0, 48, 48, 1
FROM tmp_demo_seckill s
JOIN tmp_demo_products p ON p.id = s.product_id;

INSERT INTO eb_store_product_attr
    (id, product_id, attr_name, attr_values, type, is_del, is_show_image)
SELECT 18200 + (s.id - 8100), s.id, p.attr_name, CONCAT(p.option_one, ',', p.option_two), 1, 0, 1
FROM tmp_demo_seckill s JOIN tmp_demo_products p ON p.id = s.product_id;

INSERT INTO eb_store_product_attr_option
    (id, product_id, attr_id, option_name, image, sort, is_del)
SELECT 38199 + (s.id - 8100) * 2, s.id, 18200 + (s.id - 8100), p.option_one, p.image, 1, 0
FROM tmp_demo_seckill s JOIN tmp_demo_products p ON p.id = s.product_id;

INSERT INTO eb_store_product_attr_option
    (id, product_id, attr_id, option_name, image, sort, is_del)
SELECT 38200 + (s.id - 8100) * 2, s.id, 18200 + (s.id - 8100), p.option_two, p.image, 2, 0
FROM tmp_demo_seckill s JOIN tmp_demo_products p ON p.id = s.product_id;

INSERT INTO eb_store_product_attr_value (
    id, product_id, suk, stock, sales, price, image, `unique`, cost, bar_code, ot_price,
    weight, volume, brokerage, brokerage_two, type, quota, quota_show, attr_value,
    is_del, version, is_default, is_show
)
SELECT
    28199 + (s.id - 8100) * 2, s.id, p.option_one, 28, 8, ROUND(p.price * s.discount, 2),
    p.image, CONCAT('S', LPAD((s.id - 8100) * 2 - 1, 7, '0')), p.cost, CONCAT('S', s.id, 'A'),
    p.ot_price, p.weight, 0, 0, 0, 1, 28, 28, JSON_OBJECT(p.attr_name, p.option_one),
    0, 0, 1, 1
FROM tmp_demo_seckill s JOIN tmp_demo_products p ON p.id = s.product_id;

INSERT INTO eb_store_product_attr_value (
    id, product_id, suk, stock, sales, price, image, `unique`, cost, bar_code, ot_price,
    weight, volume, brokerage, brokerage_two, type, quota, quota_show, attr_value,
    is_del, version, is_default, is_show
)
SELECT
    28200 + (s.id - 8100) * 2, s.id, p.option_two, 20, 8, ROUND(p.price * s.discount * 1.08, 2),
    p.image, CONCAT('S', LPAD((s.id - 8100) * 2, 7, '0')), ROUND(p.cost * 1.08, 2),
    CONCAT('S', s.id, 'B'), ROUND(p.ot_price * 1.08, 2), p.weight, 0, 0, 0, 1, 20, 20,
    JSON_OBJECT(p.attr_name, p.option_two), 0, 0, 0, 1
FROM tmp_demo_seckill s JOIN tmp_demo_products p ON p.id = s.product_id;

INSERT INTO eb_store_product_description (id, product_id, description, type)
SELECT
    18200 + (s.id - 8100), s.id,
    CONCAT('<p>限时秒杀：', p.store_name, '</p><img src="http://127.0.0.1:8080/', p.image, '" style="width:100%" />'),
    1
FROM tmp_demo_seckill s JOIN tmp_demo_products p ON p.id = s.product_id;

DROP TEMPORARY TABLE IF EXISTS tmp_demo_bargain;
CREATE TEMPORARY TABLE tmp_demo_bargain (
    id INT PRIMARY KEY, product_id INT NOT NULL, discount DECIMAL(5, 2) NOT NULL
) ENGINE = MEMORY;
INSERT INTO tmp_demo_bargain VALUES
(8101, 8104, 0.62), (8102, 8114, 0.58), (8103, 8123, 0.68);

INSERT INTO eb_store_bargain (
    id, product_id, title, image, unit_name, stock, sales, images, start_time, stop_time,
    store_name, price, min_price, num, bargain_max_price, bargain_min_price, bargain_num,
    status, give_integral, info, cost, sort, is_hot, is_del, add_time, is_postage, postage,
    rule, look, share, temp_id, weight, volume, quota, quota_show, people_num
)
SELECT
    b.id, p.id, CONCAT('好友助力砍价 · ', p.store_name), p.image, p.unit_name, 40,
    12 + (b.id - 8100) * 4, JSON_ARRAY(p.image), UNIX_TIMESTAMP(DATE_SUB(@seed_now, INTERVAL 1 DAY)) * 1000,
    UNIX_TIMESTAMP(DATE_ADD(@seed_now, INTERVAL 30 DAY)) * 1000, p.store_name, p.price,
    ROUND(p.price * b.discount, 2), 1, ROUND(p.price * 0.08, 2), ROUND(p.price * 0.02, 2),
    1, 1, FLOOR(p.price / 20), CONCAT('邀请好友助力，最低可砍至 ', ROUND(p.price * b.discount, 2), ' 元'),
    p.cost, 90 - (b.id - 8100), 1, 0, UNIX_TIMESTAMP(@seed_now) * 1000, 1, 0,
    '每位好友可助力一次，达到目标人数后按最低价购买。', 680 + (b.id - 8100) * 73,
    45 + (b.id - 8100) * 6, 1, p.weight, 0, 40, 40, 5
FROM tmp_demo_bargain b JOIN tmp_demo_products p ON p.id = b.product_id;

INSERT INTO eb_store_product_attr
    (id, product_id, attr_name, attr_values, type, is_del, is_show_image)
SELECT 18300 + (b.id - 8100), b.id, p.attr_name, p.option_one, 2, 0, 1
FROM tmp_demo_bargain b JOIN tmp_demo_products p ON p.id = b.product_id;

INSERT INTO eb_store_product_attr_option
    (id, product_id, attr_id, option_name, image, sort, is_del)
SELECT 38300 + (b.id - 8100), b.id, 18300 + (b.id - 8100), p.option_one, p.image, 1, 0
FROM tmp_demo_bargain b JOIN tmp_demo_products p ON p.id = b.product_id;

INSERT INTO eb_store_product_attr_value (
    id, product_id, suk, stock, sales, price, image, `unique`, cost, bar_code, ot_price,
    weight, volume, brokerage, brokerage_two, type, quota, quota_show, attr_value,
    is_del, version, is_default, is_show
)
SELECT
    28300 + (b.id - 8100), b.id, p.option_one, 40, 12, ROUND(p.price * b.discount, 2),
    p.image, CONCAT('B', LPAD(b.id - 8100, 7, '0')), p.cost, CONCAT('B', b.id),
    p.ot_price, p.weight, 0, 0, 0, 2, 40, 40, JSON_OBJECT(p.attr_name, p.option_one),
    0, 0, 1, 1
FROM tmp_demo_bargain b JOIN tmp_demo_products p ON p.id = b.product_id;

INSERT INTO eb_store_product_description (id, product_id, description, type)
SELECT
    18300 + (b.id - 8100), b.id,
    CONCAT('<p>好友助力砍价：', p.store_name, '</p><img src="http://127.0.0.1:8080/', p.image, '" style="width:100%" />'),
    2
FROM tmp_demo_bargain b JOIN tmp_demo_products p ON p.id = b.product_id;

DROP TEMPORARY TABLE IF EXISTS tmp_demo_combination;
CREATE TEMPORARY TABLE tmp_demo_combination (
    id INT PRIMARY KEY, product_id INT NOT NULL, people INT NOT NULL, discount DECIMAL(5, 2) NOT NULL
) ENGINE = MEMORY;
INSERT INTO tmp_demo_combination VALUES
(8101, 8107, 2, 0.76), (8102, 8113, 3, 0.78), (8103, 8120, 2, 0.80);

INSERT INTO eb_store_combination (
    id, product_id, mer_id, image, images, title, attr, people, info, price, sort, sales,
    stock, add_time, is_host, is_show, is_del, combination, mer_use, is_postage, postage,
    start_time, stop_time, effective_time, cost, browse, unit_name, temp_id, weight, volume,
    num, quota, quota_show, ot_price, once_num, virtual_ration
)
SELECT
    c.id, p.id, 0, p.image, JSON_ARRAY(p.image), CONCAT(c.people, '人拼团 · ', p.store_name),
    p.option_one, c.people, CONCAT('邀请好友成团，', p.store_info), ROUND(p.price * c.discount, 2),
    80 - (c.id - 8100), 18 + (c.id - 8100) * 5, 60,
    UNIX_TIMESTAMP(@seed_now) * 1000, 1, 1, 0, 1, 0, 1, 0,
    UNIX_TIMESTAMP(DATE_SUB(@seed_now, INTERVAL 1 DAY)) * 1000,
    UNIX_TIMESTAMP(DATE_ADD(@seed_now, INTERVAL 30 DAY)) * 1000, 24, p.cost,
    720 + (c.id - 8100) * 89, p.unit_name, 1, p.weight, 0, 1, 60, 60, p.ot_price, 1, 100
FROM tmp_demo_combination c JOIN tmp_demo_products p ON p.id = c.product_id;

INSERT INTO eb_store_product_attr
    (id, product_id, attr_name, attr_values, type, is_del, is_show_image)
SELECT 18400 + (c.id - 8100), c.id, p.attr_name, CONCAT(p.option_one, ',', p.option_two), 3, 0, 1
FROM tmp_demo_combination c JOIN tmp_demo_products p ON p.id = c.product_id;

INSERT INTO eb_store_product_attr_option
    (id, product_id, attr_id, option_name, image, sort, is_del)
SELECT 38399 + (c.id - 8100) * 2, c.id, 18400 + (c.id - 8100), p.option_one, p.image, 1, 0
FROM tmp_demo_combination c JOIN tmp_demo_products p ON p.id = c.product_id;

INSERT INTO eb_store_product_attr_option
    (id, product_id, attr_id, option_name, image, sort, is_del)
SELECT 38400 + (c.id - 8100) * 2, c.id, 18400 + (c.id - 8100), p.option_two, p.image, 2, 0
FROM tmp_demo_combination c JOIN tmp_demo_products p ON p.id = c.product_id;

INSERT INTO eb_store_product_attr_value (
    id, product_id, suk, stock, sales, price, image, `unique`, cost, bar_code, ot_price,
    weight, volume, brokerage, brokerage_two, type, quota, quota_show, attr_value,
    is_del, version, is_default, is_show
)
SELECT
    28399 + (c.id - 8100) * 2, c.id, p.option_one, 36, 12, ROUND(p.price * c.discount, 2),
    p.image, CONCAT('C', LPAD((c.id - 8100) * 2 - 1, 7, '0')), p.cost, CONCAT('C', c.id, 'A'),
    p.ot_price, p.weight, 0, 0, 0, 3, 36, 36, JSON_OBJECT(p.attr_name, p.option_one),
    0, 0, 1, 1
FROM tmp_demo_combination c JOIN tmp_demo_products p ON p.id = c.product_id;

INSERT INTO eb_store_product_attr_value (
    id, product_id, suk, stock, sales, price, image, `unique`, cost, bar_code, ot_price,
    weight, volume, brokerage, brokerage_two, type, quota, quota_show, attr_value,
    is_del, version, is_default, is_show
)
SELECT
    28400 + (c.id - 8100) * 2, c.id, p.option_two, 24, 10, ROUND(p.price * c.discount * 1.08, 2),
    p.image, CONCAT('C', LPAD((c.id - 8100) * 2, 7, '0')), ROUND(p.cost * 1.08, 2),
    CONCAT('C', c.id, 'B'), ROUND(p.ot_price * 1.08, 2), p.weight, 0, 0, 0, 3, 24, 24,
    JSON_OBJECT(p.attr_name, p.option_two), 0, 0, 0, 1
FROM tmp_demo_combination c JOIN tmp_demo_products p ON p.id = c.product_id;

INSERT INTO eb_store_product_description (id, product_id, description, type)
SELECT
    18400 + (c.id - 8100), c.id,
    CONCAT('<p>多人拼团活动：', p.store_name, '</p><img src="http://127.0.0.1:8080/', p.image, '" style="width:100%" />'),
    3
FROM tmp_demo_combination c JOIN tmp_demo_products p ON p.id = c.product_id;

-- Users, addresses and account activity.
INSERT INTO eb_user (
    uid, account, pwd, real_name, birthday, card_id, mark, partner_id, group_id, tag_id,
    nickname, avatar, phone, add_ip, last_ip, now_money, brokerage_price, integral,
    experience, sign_num, status, level, spread_uid, spread_time, user_type, is_promoter,
    pay_count, spread_count, addres, adminid, login_type, create_time, update_time,
    last_login_time, path, subscribe, subscribe_time, sex, country, promoter_time,
    is_logoff
)
SELECT
    8100 + n, CONCAT('13800138', LPAD(100 + n, 3, '0')),
    'e10adc3949ba59abbe56e057f20f883e',
    ELT(n, '林晓雨', '陈子轩', '周可欣', '王一诺', '李沐阳', '赵思涵', '孙嘉乐', '吴若溪', '郑皓宇', '冯语桐',
        '蒋文博', '沈依然', '韩景行', '许安琪', '何俊熙', '高雨晴', '罗嘉佑', '梁梦瑶', '宋知远', '唐心悦'),
    DATE_FORMAT(DATE_SUB('2000-01-01', INTERVAL MOD(n * 173, 5000) DAY), '%Y-%m-%d'),
    '', @demo_tag, NULL, IF(MOD(n, 4) = 0, '2', '1'), IF(MOD(n, 3) = 0, '3', ''),
    ELT(n, '小雨同学', '橙子汽水', '可可日记', '一诺生活家', '木阳', '思思', '嘉乐同学', '若溪', '皓宇', '语桐',
        '文博', '依然', '景行', '安琪', '俊熙', '雨晴', '嘉佑', '梦瑶', '知远', '心悦'),
    ELT(MOD(n - 1, 11) + 1,
        'crmebimage/public/user/2025/05/30/4acd024b82a141649cd440a2b2eaadc44un1zxh7l7.png',
        'crmebimage/public/user/2025/11/05/64c22548a6824e90a45669be579ace13n481dyed9k.png',
        'crmebimage/public/user/2025/11/07/3b359670a28e429db46eec57e3b0b2ddugxv49lz0e.png',
        'crmebimage/public/user/2025/11/08/5e1e26445c8341f1b399d56349cfc037g21falarrm.png',
        'crmebimage/public/user/2025/10/29/b6963b7a01194f39929d23ac2a56b609tkd2yow4oq.jpg',
        'crmebimage/public/user/2025/10/29/774bb969e9bc49e4a9d91361b19db54cyaxk1ruo53.jpeg',
        'crmebimage/public/user/2025/10/17/3638df0690b34928bcb77084ba00a446mm0i1fqk8m.jpg',
        'crmebimage/public/user/2025/10/17/a6665aef5de643448cc2cf6edb86fce13frz1e1rtt.png',
        'crmebimage/public/user/2025/10/21/fde97edebbd94ee4a8ca64db2f2e27e7lb9s5vdnj0.png',
        'crmebimage/public/user/2025/10/15/e43ebbd9bcf64f2dbe5824c00164e6d0qww1i5fb8j.png',
        'crmebimage/public/user/2025/10/15/26b40aa6ca7b40779991fd87510a02483vzailsprp.jpg'
    ),
    CONCAT('13800138', LPAD(100 + n, 3, '0')), CONCAT('10.0.0.', n), CONCAT('10.0.1.', n),
    50 + n * 13.50, IF(MOD(n, 5) = 0, 66.80 + n, 0), 180 + n * 37,
    260 + n * 51, MOD(n, 12), 1, MOD(n, 4),
    IF(n > 1 AND MOD(n, 3) = 0, 8101, 0),
    IF(n > 1 AND MOD(n, 3) = 0, DATE_SUB(@seed_now, INTERVAL n * 2 DAY), NULL),
    'h5', IF(MOD(n, 5) = 0, 1, 0), 0, IF(n = 1, 6, 0),
    ELT(MOD(n - 1, 5) + 1, '上海市浦东新区', '北京市朝阳区', '杭州市余杭区', '深圳市南山区', '成都市武侯区'),
    0, 'h5', DATE_SUB(@seed_now, INTERVAL 30 + n * 4 DAY), @seed_now,
    DATE_SUB(@seed_now, INTERVAL MOD(n, 7) DAY),
    IF(n > 1 AND MOD(n, 3) = 0, '/0/8101/', '/0/'), IF(MOD(n, 2) = 0, 1, 0),
    IF(MOD(n, 2) = 0, DATE_SUB(@seed_now, INTERVAL 20 + n DAY), NULL),
    IF(MOD(n, 2) = 0, 2, 1), 'CN',
    IF(MOD(n, 5) = 0, DATE_SUB(@seed_now, INTERVAL 15 + n DAY), NULL), 0
FROM tmp_demo_numbers WHERE n <= 20;

INSERT INTO eb_user_address (
    id, uid, real_name, phone, province, city, city_id, district, detail, post_code,
    longitude, latitude, is_default, is_del, create_time, update_time
)
SELECT
    18100 + n, 8100 + n,
    ELT(n, '林晓雨', '陈子轩', '周可欣', '王一诺', '李沐阳', '赵思涵', '孙嘉乐', '吴若溪', '郑皓宇', '冯语桐',
        '蒋文博', '沈依然', '韩景行', '许安琪', '何俊熙', '高雨晴', '罗嘉佑', '梁梦瑶', '宋知远', '唐心悦'),
    CONCAT('13800138', LPAD(100 + n, 3, '0')),
    ELT(MOD(n - 1, 5) + 1, '上海市', '北京市', '浙江省', '广东省', '四川省'),
    ELT(MOD(n - 1, 5) + 1, '上海市', '北京市', '杭州市', '深圳市', '成都市'), 0,
    ELT(MOD(n - 1, 5) + 1, '浦东新区', '朝阳区', '余杭区', '南山区', '武侯区'),
    ELT(MOD(n - 1, 5) + 1, '张江路88号2栋1203室', '望京东路6号院3栋', '未来科技城海创园5幢', '科技园南区12栋806', '人民南路四段18号'),
    ELT(MOD(n - 1, 5) + 1, 200120, 100102, 311121, 518057, 610041),
    ELT(MOD(n - 1, 5) + 1, '121.6062', '116.4800', '120.0102', '113.9440', '104.0648'),
    ELT(MOD(n - 1, 5) + 1, '31.2001', '39.9950', '30.2811', '22.5405', '30.5722'),
    1, 0, DATE_SUB(@seed_now, INTERVAL n * 3 DAY), @seed_now
FROM tmp_demo_numbers WHERE n <= 20;

INSERT INTO eb_user_address (
    id, uid, real_name, phone, province, city, city_id, district, detail, post_code,
    longitude, latitude, is_default, is_del, create_time, update_time
)
SELECT
    18120 + n, 8100 + n, CONCAT('备用收货人', n), CONCAT('13700000', LPAD(n, 3, '0')),
    '江苏省', '苏州市', 0, '工业园区', CONCAT('星湖街', 100 + n, '号'), 215000,
    '120.7200', '31.3000', 0, 0, DATE_SUB(@seed_now, INTERVAL n DAY), @seed_now
FROM tmp_demo_numbers WHERE n <= 5;

INSERT INTO eb_user_bill (
    id, uid, link_id, pm, title, category, type, number, balance, mark, status,
    create_time, update_time
)
SELECT
    18100 + n, 8101 + MOD(n - 1, 20), CONCAT('DEMO-BILL-', LPAD(n, 3, '0')),
    IF(MOD(n, 3) = 0, 0, 1),
    CASE MOD(n, 4)
        WHEN 0 THEN '购物赠送积分'
        WHEN 1 THEN '余额充值'
        WHEN 2 THEN '订单支付'
        ELSE '推广佣金'
    END,
    IF(MOD(n, 4) = 0, 'integral', IF(MOD(n, 4) = 3, 'brokerage_price', 'now_money')),
    CASE MOD(n, 4)
        WHEN 0 THEN 'gain'
        WHEN 1 THEN 'pay_recharge'
        WHEN 2 THEN 'pay_product'
        ELSE 'brokerage'
    END,
    5 + MOD(n * 17, 180), 100 + MOD(n * 31, 900),
    CONCAT(@demo_tag, ' 账户模拟流水'), 1,
    DATE_SUB(@seed_now, INTERVAL MOD(n * 5, 60) DAY), @seed_now
FROM tmp_demo_numbers WHERE n <= 60;

-- Coupons and coupon ownership records.
INSERT INTO eb_store_coupon (
    id, name, money, is_limited, total, last_total, use_type, primary_key, min_price,
    receive_start_time, receive_end_time, is_fixed_time, use_start_time, use_end_time,
    day, type, sort, status, is_del, create_time, update_time
) VALUES
(8101, '新人满99减10元', 10.00, 1, 500, 438, 1, '', 99.00, DATE_SUB(@seed_now, INTERVAL 15 DAY), DATE_ADD(@seed_now, INTERVAL 60 DAY), 0, NULL, NULL, 30, 2, 100, 1, 0, @seed_now, @seed_now),
(8102, '全场满299减30元', 30.00, 1, 300, 257, 1, '', 299.00, DATE_SUB(@seed_now, INTERVAL 10 DAY), DATE_ADD(@seed_now, INTERVAL 45 DAY), 1, DATE_SUB(@seed_now, INTERVAL 10 DAY), DATE_ADD(@seed_now, INTERVAL 60 DAY), 0, 1, 90, 1, 0, @seed_now, @seed_now),
(8103, '数码家电满899减80元', 80.00, 1, 200, 166, 3, '283', 899.00, DATE_SUB(@seed_now, INTERVAL 8 DAY), DATE_ADD(@seed_now, INTERVAL 40 DAY), 0, NULL, NULL, 20, 1, 80, 1, 0, @seed_now, @seed_now),
(8104, '指定商品立减20元', 20.00, 0, 0, 0, 2, '8109,8110,8111', 159.00, DATE_SUB(@seed_now, INTERVAL 5 DAY), DATE_ADD(@seed_now, INTERVAL 35 DAY), 0, NULL, NULL, 15, 1, 70, 1, 0, @seed_now, @seed_now),
(8105, '会员专享满599减60元', 60.00, 1, 150, 121, 1, '', 599.00, DATE_SUB(@seed_now, INTERVAL 3 DAY), DATE_ADD(@seed_now, INTERVAL 30 DAY), 1, DATE_SUB(@seed_now, INTERVAL 3 DAY), DATE_ADD(@seed_now, INTERVAL 45 DAY), 0, 3, 60, 1, 0, @seed_now, @seed_now);

INSERT INTO eb_store_coupon_user (
    id, coupon_id, cid, uid, name, money, min_price, type, status, create_time, update_time,
    start_time, end_time, use_time, use_type, primary_key, order_id
)
SELECT
    8100 + n, c.id, c.id, 8101 + MOD(n - 1, 20), c.name, c.money, c.min_price,
    IF(MOD(n, 2) = 0, 'get', 'send'),
    CASE WHEN n <= 20 THEN 1 WHEN n <= 40 THEN 0 ELSE 2 END,
    DATE_SUB(@seed_now, INTERVAL MOD(n * 3, 40) DAY), @seed_now,
    CASE WHEN n > 40 THEN DATE_SUB(@seed_now, INTERVAL 60 DAY) ELSE DATE_SUB(@seed_now, INTERVAL 10 DAY) END,
    CASE WHEN n > 40 THEN DATE_SUB(@seed_now, INTERVAL 1 DAY) ELSE DATE_ADD(@seed_now, INTERVAL 30 DAY) END,
    IF(n <= 20, DATE_SUB(@seed_now, INTERVAL MOD(n, 12) DAY), NULL),
    c.use_type, c.primary_key, IF(n <= 20, 8108 + n, 0)
FROM tmp_demo_numbers dn
JOIN eb_store_coupon c ON c.id = 8101 + MOD(dn.n - 1, 5)
WHERE n <= 50;

-- Orders and line items, covering unpaid, pending shipment, shipped, received, completed and refunded.
INSERT INTO eb_store_order (
    id, order_id, uid, real_name, user_phone, user_address, freight_price, total_num,
    total_price, total_postage, pay_price, pay_postage, deduction_price, coupon_id,
    coupon_price, paid, pay_time, pay_type, create_time, status, refund_status,
    refund_reason_wap_explain, refund_reason_wap, refund_reason_time, refund_price,
    delivery_name, delivery_type, delivery_id, gain_integral, mark, remark, cost,
    is_channel, update_time, delivery_code, express_record_type, pro_total_price,
    before_pay_price, out_trade_no
)
SELECT
    8100 + dn.n, CONCAT('DM', DATE_FORMAT(@seed_now, '%Y%m%d'), LPAD(dn.n, 8, '0')),
    8101 + MOD(dn.n - 1, 20), u.real_name, u.phone,
    CONCAT(a.province, a.city, a.district, a.detail), 0, 1 + MOD(dn.n, 3),
    ROUND(p.price * (1 + MOD(dn.n, 3)), 2), 0,
    ROUND(GREATEST(p.price * (1 + MOD(dn.n, 3)) - IF(MOD(dn.n, 4) = 0, 10, 0), 0), 2),
    0, 0, IF(MOD(dn.n, 4) = 0, 8101 + MOD(dn.n, 5), 0),
    IF(MOD(dn.n, 4) = 0, 10, 0), IF(dn.n > 8, 1, 0),
    IF(dn.n > 8, DATE_ADD(DATE_SUB(DATE_SUB(@seed_now, INTERVAL MOD(dn.n * 7, 45) DAY), INTERVAL MOD(dn.n * 13, 20) HOUR), INTERVAL 5 MINUTE), NULL),
    IF(dn.n > 8, ELT(MOD(dn.n, 3) + 1, 'weixin', 'alipay', 'yue'), ''),
    DATE_SUB(DATE_SUB(@seed_now, INTERVAL MOD(dn.n * 7, 45) DAY), INTERVAL MOD(dn.n * 13, 20) HOUR),
    CASE
        WHEN dn.n <= 20 THEN 0
        WHEN dn.n <= 32 THEN 1
        WHEN dn.n <= 44 THEN 2
        ELSE 3
    END,
    IF(dn.n >= 77, 2, 0),
    IF(dn.n >= 77, '商品已退回，退款已原路到账', NULL),
    IF(dn.n >= 77, '七天无理由退款', NULL),
    IF(dn.n >= 77, DATE_SUB(@seed_now, INTERVAL MOD(dn.n, 4) DAY), NULL),
    IF(dn.n >= 77, ROUND(GREATEST(p.price * (1 + MOD(dn.n, 3)) - IF(MOD(dn.n, 4) = 0, 10, 0), 0), 2), 0),
    IF(dn.n > 20, ELT(MOD(dn.n, 3) + 1, '顺丰速运', '京东物流', '中通快递'), NULL),
    IF(dn.n > 20, 'express', NULL),
    IF(dn.n > 20, CONCAT('SF', DATE_FORMAT(@seed_now, '%m%d'), LPAD(8100 + dn.n, 8, '0')), NULL),
    FLOOR(p.price / 10), IF(MOD(dn.n, 6) = 0, '周末在家，请送货前电话联系', ''),
    @demo_tag, ROUND(p.cost * (1 + MOD(dn.n, 3)), 2), MOD(dn.n, 3), @seed_now,
    IF(dn.n > 20, ELT(MOD(dn.n, 3) + 1, 'SF', 'JD', 'ZTO'), NULL),
    IF(dn.n > 20, 1, NULL), ROUND(p.price * (1 + MOD(dn.n, 3)), 2),
    ROUND(p.price * (1 + MOD(dn.n, 3)), 2),
    IF(dn.n > 8, CONCAT('OUT', DATE_FORMAT(@seed_now, '%Y%m%d'), LPAD(dn.n, 8, '0')), NULL)
FROM tmp_demo_numbers dn
JOIN tmp_demo_products p ON p.id = 8101 + MOD(dn.n - 1, 24)
JOIN eb_user u ON u.uid = 8101 + MOD(dn.n - 1, 20)
JOIN eb_user_address a ON a.id = 18101 + MOD(dn.n - 1, 20);

INSERT INTO eb_store_order_info (
    id, order_id, product_id, info, `unique`, create_time, update_time, order_no,
    product_name, attr_value_id, image, sku, price, pay_num, weight, volume,
    give_integral, is_reply, is_sub, vip_price, product_type
)
SELECT
    18100 + dn.n, 8100 + dn.n, p.id,
    JSON_OBJECT(
        'image', p.image, 'productId', p.id,
        'attrValueId', 28099 + (p.id - 8100) * 2,
        'weight', p.weight, 'giveIntegral', FLOOR(p.price / 10), 'isSub', FALSE,
        'productName', p.store_name, 'volume', 0, 'payNum', 1 + MOD(dn.n, 3),
        'price', p.price, 'vipPrice', ROUND(p.price * 0.95, 2),
        'tempId', 1, 'sku', p.option_one, 'productType', 0
    ),
    CONCAT('D', LPAD((p.id - 8100) * 2 - 1, 7, '0')),
    o.create_time, @seed_now, o.order_id, p.store_name,
    28099 + (p.id - 8100) * 2, p.image, p.option_one, p.price, 1 + MOD(dn.n, 3),
    p.weight, 0, FLOOR(p.price / 10), IF(dn.n BETWEEN 45 AND 76, 1, 0), 0,
    ROUND(p.price * 0.95, 2), 0
FROM tmp_demo_numbers dn
JOIN tmp_demo_products p ON p.id = 8101 + MOD(dn.n - 1, 24)
JOIN eb_store_order o ON o.id = 8100 + dn.n;

INSERT INTO eb_store_order_status (oid, change_type, change_message, create_time)
SELECT id, 'cache_key_create_order', '订单生成', create_time
FROM eb_store_order WHERE id BETWEEN 8101 AND 8180
UNION ALL
SELECT id, 'pay_success', CONCAT('用户付款成功，支付方式：', pay_type), pay_time
FROM eb_store_order WHERE id BETWEEN 8101 AND 8180 AND paid = 1
UNION ALL
SELECT id, 'delivery_goods', CONCAT('已由', delivery_name, '发货，运单号：', delivery_id), DATE_ADD(create_time, INTERVAL 1 DAY)
FROM eb_store_order WHERE id BETWEEN 8121 AND 8180
UNION ALL
SELECT id, 'take_delivery', '用户已确认收货', DATE_ADD(create_time, INTERVAL 4 DAY)
FROM eb_store_order WHERE id BETWEEN 8133 AND 8176
UNION ALL
SELECT id, 'check_order_over', '订单已完成', DATE_ADD(create_time, INTERVAL 5 DAY)
FROM eb_store_order WHERE id BETWEEN 8145 AND 8176
UNION ALL
SELECT id, 'refund_price', '退款成功，款项已原路退回', refund_reason_time
FROM eb_store_order WHERE id BETWEEN 8177 AND 8180;

-- Mark selected paid orders as activity orders and keep their SKU references coherent.
UPDATE eb_store_order SET seckill_id = 8101 WHERE id = 8149;
UPDATE eb_store_order SET seckill_id = 8102 WHERE id = 8157;
UPDATE eb_store_order SET seckill_id = 8103 WHERE id = 8158;
UPDATE eb_store_order SET seckill_id = 8104 WHERE id = 8172;
UPDATE eb_store_order_info SET product_type = 1, attr_value_id = 28201, info = JSON_SET(info, '$.productType', 1, '$.attrValueId', 28201) WHERE order_id = 8149;
UPDATE eb_store_order_info SET product_type = 1, attr_value_id = 28203, info = JSON_SET(info, '$.productType', 1, '$.attrValueId', 28203) WHERE order_id = 8157;
UPDATE eb_store_order_info SET product_type = 1, attr_value_id = 28205, info = JSON_SET(info, '$.productType', 1, '$.attrValueId', 28205) WHERE order_id = 8158;
UPDATE eb_store_order_info SET product_type = 1, attr_value_id = 28207, info = JSON_SET(info, '$.productType', 1, '$.attrValueId', 28207) WHERE order_id = 8172;

UPDATE eb_store_order SET bargain_id = 8101 WHERE id = 8152;
UPDATE eb_store_order SET bargain_id = 8102 WHERE id = 8162;
UPDATE eb_store_order SET bargain_id = 8103 WHERE id IN (8171, 8176);
UPDATE eb_store_order_info SET product_type = 2, attr_value_id = 28301, info = JSON_SET(info, '$.productType', 2, '$.attrValueId', 28301) WHERE order_id = 8152;
UPDATE eb_store_order_info SET product_type = 2, attr_value_id = 28302, info = JSON_SET(info, '$.productType', 2, '$.attrValueId', 28302) WHERE order_id = 8162;
UPDATE eb_store_order_info SET product_type = 2, attr_value_id = 28303, info = JSON_SET(info, '$.productType', 2, '$.attrValueId', 28303) WHERE order_id IN (8171, 8176);

UPDATE eb_store_order SET combination_id = 8101, pink_id = 8101 WHERE id IN (8131, 8155);
UPDATE eb_store_order SET combination_id = 8102, pink_id = 8103 WHERE id IN (8137, 8161);
UPDATE eb_store_order SET combination_id = 8103, pink_id = 8105 WHERE id IN (8144, 8168);
UPDATE eb_store_order_info SET product_type = 3, attr_value_id = 28401, info = JSON_SET(info, '$.productType', 3, '$.attrValueId', 28401) WHERE order_id IN (8131, 8155);
UPDATE eb_store_order_info SET product_type = 3, attr_value_id = 28403, info = JSON_SET(info, '$.productType', 3, '$.attrValueId', 28403) WHERE order_id IN (8137, 8161);
UPDATE eb_store_order_info SET product_type = 3, attr_value_id = 28405, info = JSON_SET(info, '$.productType', 3, '$.attrValueId', 28405) WHERE order_id IN (8144, 8168);

INSERT INTO eb_store_pink (
    id, uid, order_id, order_id_key, total_num, total_price, cid, pid, people, price,
    add_time, stop_time, k_id, is_tpl, is_refund, status, is_virtual, nickname, avatar
)
SELECT
    x.pink_id, o.uid, o.order_id, o.id, o.total_num, o.pay_price, x.cid, x.pid, x.people,
    c.price, UNIX_TIMESTAMP(o.create_time) * 1000, UNIX_TIMESTAMP(DATE_ADD(o.create_time, INTERVAL 24 HOUR)) * 1000,
    x.k_id, 0, 0, x.status, 0, u.nickname, u.avatar
FROM (
    SELECT 8101 pink_id, 8155 oid, 8101 cid, 8107 pid, 2 people, 0 k_id, 2 status
    UNION ALL SELECT 8102, 8131, 8101, 8107, 2, 8101, 2
    UNION ALL SELECT 8103, 8161, 8102, 8113, 3, 0, 2
    UNION ALL SELECT 8104, 8137, 8102, 8113, 3, 8103, 2
    UNION ALL SELECT 8105, 8168, 8103, 8120, 2, 0, 1
    UNION ALL SELECT 8106, 8144, 8103, 8120, 2, 8105, 1
) x
JOIN eb_store_order o ON o.id = x.oid
JOIN eb_user u ON u.uid = o.uid
JOIN eb_store_combination c ON c.id = x.cid;

-- Reviews tied to completed orders.
INSERT INTO eb_store_product_reply (
    id, uid, oid, `unique`, product_id, reply_type, product_score, service_score,
    comment, pics, merchant_reply_content, merchant_reply_time, is_del, is_reply,
    nickname, avatar, create_time, update_time, sku
)
SELECT
    8100 + (dn.n - 44), o.uid, o.id, oi.`unique`, oi.product_id, 'product',
    IF(MOD(dn.n, 7) = 0, 4, 5), IF(MOD(dn.n, 9) = 0, 4, 5),
    ELT(MOD(dn.n, 8) + 1,
        '实物和图片一致，包装完整，使用起来很顺手。',
        '发货速度快，客服回复及时，整体体验不错。',
        '做工比预期更好，细节处理到位，性价比很高。',
        '颜色耐看，规格合适，家里人也很满意。',
        '已经使用一段时间，质量稳定，会考虑回购。',
        '物流信息更新及时，收到后没有破损。',
        '功能够用，操作简单，适合日常使用。',
        '第二次购买了，品质一如既往，推荐。'
    ),
    IF(MOD(dn.n, 4) = 0, oi.image, ''),
    IF(MOD(dn.n, 3) = 0, '感谢您的认可，我们会继续做好商品与服务。', NULL),
    IF(MOD(dn.n, 3) = 0, UNIX_TIMESTAMP(DATE_ADD(o.create_time, INTERVAL 6 DAY)), NULL),
    0, IF(MOD(dn.n, 3) = 0, 1, 0), u.nickname, u.avatar,
    DATE_ADD(o.create_time, INTERVAL 5 DAY), @seed_now, oi.sku
FROM tmp_demo_numbers dn
JOIN eb_store_order o ON o.id = 8100 + dn.n
JOIN eb_store_order_info oi ON oi.order_id = o.id
JOIN eb_user u ON u.uid = o.uid
WHERE dn.n BETWEEN 45 AND 76;

UPDATE eb_user u
JOIN (
    SELECT uid, COUNT(*) AS pay_count
    FROM eb_store_order
    WHERE id BETWEEN 8101 AND 8180 AND paid = 1 AND refund_status = 0
    GROUP BY uid
) x ON x.uid = u.uid
SET u.pay_count = x.pay_count
WHERE u.uid BETWEEN 8101 AND 8120;

-- Collections and active carts.
INSERT INTO eb_store_product_relation (id, uid, product_id, type, category, create_time, update_time)
SELECT
    8100 + n, 8101 + MOD(n - 1, 20), 8101 + MOD(n * 7, 24),
    'collect', 'product', DATE_SUB(@seed_now, INTERVAL MOD(n * 2, 35) DAY), @seed_now
FROM tmp_demo_numbers WHERE n <= 60;

INSERT INTO eb_store_cart (
    id, uid, type, product_id, product_attr_unique, cart_num, is_new,
    combination_id, seckill_id, bargain_id, create_time, update_time, status
)
SELECT
    8100 + n, 8101 + MOD(n - 1, 20), 'product', p.id,
    CONCAT('D', LPAD((p.id - 8100) * 2 - 1, 7, '0')), 1 + MOD(n, 2), 0, 0, 0, 0,
    DATE_SUB(@seed_now, INTERVAL MOD(n, 10) DAY), @seed_now, 1
FROM tmp_demo_numbers dn
JOIN tmp_demo_products p ON p.id = 8101 + MOD(dn.n - 1, 24)
WHERE n <= 24;

-- Articles use local images and absolute URLs inside rich text.
INSERT INTO eb_article (
    id, cid, title, author, image_input, synopsis, share_title, share_synopsis,
    visit, sort, url, media_id, status, hide, admin_id, mer_id, product_id,
    is_hot, is_banner, content, create_time, update_time
) VALUES
(8101, '807', '秋季通勤穿搭：三件单品完成一周搭配', '商城编辑部', 'crmebimage/public/product/2025/11/06/aa811171fb26464c8d54b219179a67b867cluy3vs9.png', '从版型、色彩和层次出发，整理适合日常通勤的实用搭配思路。', '秋季通勤穿搭指南', '简单好用的通勤搭配清单', '1286', 100, '', NULL, 0, 0, 1, 0, 8121, 1, 1, '<h2>通勤穿搭从一件合身风衣开始</h2><p>选择垂顺面料和利落剪裁，更容易兼顾正式感与舒适度。</p><img src="http://127.0.0.1:8080/crmebimage/public/product/2025/11/06/aa811171fb26464c8d54b219179a67b867cluy3vs9.png" style="width:100%" /><p>内搭保持简洁，鞋包使用同一色系即可完成稳定的日常组合。</p>', DATE_SUB(@seed_now, INTERVAL 3 DAY), @seed_now),
(8102, '807', '小家电日常养护清单', '商城编辑部', 'crmebimage/public/content/2025/11/10/7a54cadf0e074e9682915ab7ae0f3c93yziq66raw7.png', '掌握清洁、除垢和收纳方法，让常用小家电保持良好状态。', '小家电养护清单', '延长家电使用寿命的简单方法', '963', 90, '', NULL, 0, 0, 1, 0, 8102, 1, 0, '<h2>定期清洁比出现故障后维修更重要</h2><p>使用后及时清理可拆卸部件，并保持通风干燥。</p><img src="http://127.0.0.1:8080/crmebimage/public/content/2025/11/10/7a54cadf0e074e9682915ab7ae0f3c93yziq66raw7.png" style="width:100%" /><p>涉及电路的部分请断电后使用干布擦拭。</p>', DATE_SUB(@seed_now, INTERVAL 6 DAY), @seed_now),
(8103, '601', '家庭清洁用品如何按场景挑选', '生活研究所', 'crmebimage/public/product/2025/05/30/c2682e7e42374ab6961be9697cd512fdv4xjfnzaoo.png', '从衣物、厨房到日常纸品，按场景建立更高效的家庭清洁组合。', '家庭清洁选购指南', '按场景选对清洁用品', '756', 80, '', NULL, 0, 0, 1, 0, 8118, 0, 0, '<h2>不同场景需要不同清洁方案</h2><p>衣物清洁关注低泡易漂洗，厨房清洁关注去油能力，日常纸品则关注柔韧与亲肤。</p><img src="http://127.0.0.1:8080/crmebimage/public/product/2025/05/30/c2682e7e42374ab6961be9697cd512fdv4xjfnzaoo.png" style="width:100%" />', DATE_SUB(@seed_now, INTERVAL 9 DAY), @seed_now),
(8104, '601', '户外新手装备：从安全和舒适开始', '户外体验官', 'crmebimage/public/product/2025/05/30/f6dc9f3df7b947eabcbe1419f3fcc83ecslaa1ghjs.png', '新手选择户外装备时，应优先关注适配、安全与耐用程度。', '户外新手装备指南', '先安全，再谈进阶体验', '1102', 70, '', NULL, 0, 0, 1, 0, 8113, 1, 1, '<h2>装备适配比堆配置更重要</h2><p>购买前确认身高、体重、鞋码和使用场景，第一次使用建议由专业人士协助调节。</p><img src="http://127.0.0.1:8080/crmebimage/public/product/2025/05/30/f6dc9f3df7b947eabcbe1419f3fcc83ecslaa1ghjs.png" style="width:100%" />', DATE_SUB(@seed_now, INTERVAL 12 DAY), @seed_now),
(8105, '807', '智能穿戴健康数据怎么看', '数码观察', 'crmebimage/public/theme/20260623091518/images/21_5ae4f6a3f8bf153beb849e02e14b5c40.png', '正确理解心率、睡眠和运动记录，避免只看单次数据。', '智能穿戴数据阅读指南', '让健康记录真正有参考价值', '842', 60, '', NULL, 0, 0, 1, 0, 8123, 1, 0, '<h2>趋势比单次数字更有价值</h2><p>连续记录有助于了解个人状态变化，异常数据应结合实际感受并咨询专业人员。</p><img src="http://127.0.0.1:8080/crmebimage/public/theme/20260623091518/images/21_5ae4f6a3f8bf153beb849e02e14b5c40.png" style="width:100%" />', DATE_SUB(@seed_now, INTERVAL 15 DAY), @seed_now),
(8106, '601', '在家做好一杯咖啡的四个细节', '咖啡笔记', 'crmebimage/public/theme/20260623091518/images/cf5414089d598d064b0a4d7154a4f491.png', '从咖啡豆、研磨度、水温到清洁，提升家庭咖啡的稳定性。', '家庭咖啡入门', '四个细节提升咖啡风味', '1395', 50, '', NULL, 0, 0, 1, 0, 8124, 1, 1, '<h2>稳定来自可重复的参数</h2><p>固定豆量、水量与研磨度，再根据口感逐步微调。</p><img src="http://127.0.0.1:8080/crmebimage/public/theme/20260623091518/images/cf5414089d598d064b0a4d7154a4f491.png" style="width:100%" /><p>每次使用后及时清理冲煮组件，避免残留影响风味。</p>', DATE_SUB(@seed_now, INTERVAL 18 DAY), @seed_now);

-- Forty-five days of coherent dashboard and product statistics.
DROP TEMPORARY TABLE IF EXISTS tmp_demo_days;
CREATE TEMPORARY TABLE tmp_demo_days (
    day_no INT PRIMARY KEY,
    record_date VARCHAR(20) NOT NULL
) ENGINE = MEMORY;
INSERT INTO tmp_demo_days (day_no, record_date)
SELECT n - 1, DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL n - 1 DAY), '%Y-%m-%d')
FROM tmp_demo_numbers WHERE n <= 45;

INSERT INTO eb_trading_day_record (
    id, date, product_order_num, product_order_pay_num, product_order_pay_fee,
    product_order_refund_num, product_order_refund_fee, recharge_order_num,
    recharge_order_fee, balance_pay_fee, brokerage_fee
)
SELECT
    -810001 - day_no, record_date, 18 + MOD(day_no * 7, 22), 14 + MOD(day_no * 5, 18),
    2600 + MOD(day_no * 379, 6200), IF(MOD(day_no, 8) = 0, 2, MOD(day_no, 3)),
    IF(MOD(day_no, 8) = 0, 399.00 + MOD(day_no * 31, 600), MOD(day_no, 3) * 89.00),
    2 + MOD(day_no, 5), 200 + MOD(day_no * 73, 800),
    180 + MOD(day_no * 41, 900), 35 + MOD(day_no * 17, 160)
FROM tmp_demo_days;

INSERT INTO eb_shopping_product_day_record (
    id, date, add_product_num, page_view, collect_num, add_cart_num,
    order_product_num, order_success_product_num
)
SELECT
    -811001 - day_no, record_date, IF(day_no < 24, 1, 0),
    680 + MOD(day_no * 83, 920), 22 + MOD(day_no * 11, 68),
    48 + MOD(day_no * 17, 120), 25 + MOD(day_no * 7, 48),
    19 + MOD(day_no * 5, 39)
FROM tmp_demo_days;

INSERT INTO eb_product_day_record (
    id, date, product_id, page_view, collect_num, add_cart_num,
    order_product_num, order_success_product_fee
)
SELECT
    -820001 - d.day_no * 24 - (p.id - 8101), d.record_date, p.id,
    18 + MOD(d.day_no * 19 + p.id * 7, 96),
    1 + MOD(d.day_no + p.id, 12),
    2 + MOD(d.day_no * 3 + p.id, 18),
    1 + MOD(d.day_no + p.id * 2, 9),
    ROUND(p.price * (1 + MOD(d.day_no + p.id, 6)), 2)
FROM tmp_demo_days d
CROSS JOIN tmp_demo_products p;

INSERT INTO eb_user_visit_record (id, date, uid, visit_type)
SELECT
    -830001 - d.day_no * 20 - (CAST(u.uid AS SIGNED) - 8101), d.record_date, u.uid,
    1 + MOD(d.day_no + u.uid, 4)
FROM tmp_demo_days d
CROSS JOIN eb_user u
WHERE u.uid BETWEEN 8101 AND 8120;

COMMIT;

DROP TEMPORARY TABLE IF EXISTS tmp_demo_days;
DROP TEMPORARY TABLE IF EXISTS tmp_demo_combination;
DROP TEMPORARY TABLE IF EXISTS tmp_demo_bargain;
DROP TEMPORARY TABLE IF EXISTS tmp_demo_seckill;
DROP TEMPORARY TABLE IF EXISTS tmp_demo_products;
DROP TEMPORARY TABLE IF EXISTS tmp_demo_numbers;

SET FOREIGN_KEY_CHECKS = @old_foreign_key_checks;

SELECT 'DEMO-SEED-V1 imported' AS result;
