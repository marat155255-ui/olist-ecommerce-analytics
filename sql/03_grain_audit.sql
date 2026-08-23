USE olist;

-- 1. Заказы: 1 строка = 1 заказ
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders
FROM orders;


-- 2. Клиенты: customer_id = техническая запись, customer_unique_id = реальный клиент
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customer_ids,
    COUNT(DISTINCT customer_unique_id) AS unique_real_customers
FROM customers;


-- 3. Позиции: 1 строка = 1 товарная позиция заказа
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT CONCAT(order_id, '-', order_item_id)) AS unique_order_items
FROM order_items;


-- 4. Платежи: 1 строка = 1 платёжная транзакция
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders
FROM order_payments;


-- 5. Отзывы: 1 строка = 1 связь отзыва с заказом
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT CONCAT(review_id, '-', order_id)) AS unique_review_orders
FROM order_reviews;


-- 6. Товары: 1 строка = 1 товар
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_products
FROM products;


-- 7. Продавцы: 1 строка = 1 продавец
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT seller_id) AS unique_sellers
FROM sellers;


-- 8. Геолокация: 1 строка = 1 геолокационная запись
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT geolocation_zip_code_prefix) AS unique_zip_prefixes
FROM geolocation;


-- 9. Перевод категорий: 1 строка = 1 перевод категории
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_category_name) AS unique_pt_categories,
    COUNT(DISTINCT product_category_name_english) AS unique_en_categories
FROM product_category_name_translation;