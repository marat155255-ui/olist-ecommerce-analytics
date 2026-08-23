USE olist;
-- 1. Сравнение сумм order_items и order_payments на уровне заказа

WITH grouped_order_items AS (
    SELECT 
        order_id,
        SUM(price + freight_value) AS items_total
    FROM order_items
    GROUP BY order_id
),
grouped_order_payments AS (
    SELECT 
        order_id,
        SUM(payment_value) AS payments_total
    FROM order_payments
    GROUP BY order_id
)
SELECT 
    SUM(gop.payments_total - goi.items_total) AS total_dif,
    SUM(CASE 
            WHEN gop.payments_total - goi.items_total > 0 
            THEN 1 ELSE 0 
        END) AS difference_more_0,
    SUM(CASE 
            WHEN gop.payments_total - goi.items_total < 0 
            THEN 1 ELSE 0 
        END) AS difference_less_0,
    MAX(gop.payments_total - goi.items_total) AS max_dif,
    MIN(gop.payments_total - goi.items_total) AS min_dif
FROM grouped_order_items goi
JOIN grouped_order_payments gop
    ON goi.order_id = gop.order_id;
    
-- 2. Заказы, которые есть в order_payments, но отсутствуют в order_items
  
WITH grouped_order_items AS (
    SELECT 
        order_id,
        SUM(price + freight_value) AS items_total
    FROM order_items
    GROUP BY order_id
),
grouped_order_payments AS (
    SELECT 
        order_id,
        SUM(payment_value) AS payments_total
    FROM order_payments
    GROUP BY order_id
)
SELECT 
    COUNT(*) AS left_rows,
    SUM(gp.payments_total) AS left_sum
FROM grouped_order_payments gp
LEFT JOIN grouped_order_items go
    ON go.order_id = gp.order_id
WHERE go.order_id IS NULL;

-- 3. Заказы, которые есть в order_items, но отсутствуют в order_payments

WITH grouped_order_items AS (
    SELECT 
        order_id,
        SUM(price) AS total_goods_price,
        SUM(freight_value) AS total_freight,
        SUM(price + freight_value) AS total_items_value
    FROM order_items
    GROUP BY order_id
),
grouped_order_payments AS (
    SELECT 
        order_id,
        SUM(payment_value) AS payments_total
    FROM order_payments
    GROUP BY order_id
)
SELECT 
    COUNT(*) AS orders_count,
    SUM(goi.total_goods_price) AS total_goods_price,
    SUM(goi.total_freight) AS total_freight,
    SUM(goi.total_items_value) AS total_missing_value
FROM grouped_order_items goi
LEFT JOIN grouped_order_payments gop
    ON goi.order_id = gop.order_id
WHERE gop.order_id IS NULL;