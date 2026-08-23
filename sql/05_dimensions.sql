USE olist;

-- 1. Клиенты: 1 строка = 1 технический клиент
CREATE OR REPLACE VIEW dim_customer AS
SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
FROM customers;


-- 2. Товары: 1 строка = 1 товар
CREATE OR REPLACE VIEW dim_product AS
SELECT
    p.product_id,
    p.product_category_name,
    COALESCE(
        NULLIF(TRIM(t.product_category_name_english), ''),
        NULLIF(TRIM(p.product_category_name), ''),
        'Unknown / Unclassified'
    ) AS product_category_name_english,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM products p
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name;

-- 3. Продавцы: 1 строка = 1 продавец
CREATE OR REPLACE VIEW dim_seller AS
SELECT
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
FROM sellers;


-- 4. Календарь: 1 строка = 1 день

CREATE TABLE dim_date (
    `date` DATE PRIMARY KEY,
    `year` INT,
    `month` INT,
    `month_name` VARCHAR(20),
    `quarter` INT,
    `week` INT,
    `day` INT,
    `year_month` VARCHAR(7)
);

INSERT INTO dim_date (
    `date`,
    `year`,
    `month`,
    `month_name`,
    `quarter`,
    `week`,
    `day`,
    `year_month`
)
WITH RECURSIVE calendar AS (
    SELECT DATE('2016-09-04') AS `date`

    UNION ALL

    SELECT `date` + INTERVAL 1 DAY
    FROM calendar
    WHERE `date` < '2018-10-17'
)
SELECT
    `date`,
    YEAR(`date`),
    MONTH(`date`),
    MONTHNAME(`date`),
    QUARTER(`date`),
    WEEK(`date`),
    DAY(`date`),
    DATE_FORMAT(`date`, '%Y-%m')
FROM calendar;