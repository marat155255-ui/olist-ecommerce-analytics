USE olist;

-- 1. Заказы: 1 строка = 1 заказ
CREATE OR REPLACE VIEW fact_orders AS
SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    DATE(order_purchase_timestamp) AS purchase_date,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,

    DATEDIFF(
        order_delivered_customer_date,
        order_purchase_timestamp
    ) AS delivery_days,

    TIMESTAMPDIFF(
        DAY,
        order_approved_at,
        order_delivered_carrier_date
    ) AS processing_days,

    TIMESTAMPDIFF(
        DAY,
        order_estimated_delivery_date,
        order_delivered_customer_date
    ) AS delivery_variance_days,

    CASE
        WHEN order_delivered_customer_date IS NULL THEN NULL
        WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1
        ELSE 0
    END AS is_late

FROM orders;


-- 2. Товарные позиции: 1 строка = 1 позиция заказа
CREATE OR REPLACE VIEW fact_order_items AS
SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
FROM order_items;


-- 3. Платежи: 1 строка = 1 заказ после агрегации платежей
CREATE OR REPLACE VIEW fact_payments_agg AS
SELECT
    order_id,
    SUM(payment_value) AS total_payment_value,
    COUNT(*) AS payment_count,
    MAX(payment_installments) AS payment_installments_max
FROM order_payments
GROUP BY order_id;


-- 4. Отзывы: 1 строка = 1 связь отзыва с заказом
CREATE OR REPLACE VIEW fact_reviews AS
SELECT
    review_id,
    order_id,
    review_score,
    review_creation_date,
    review_answer_timestamp
FROM order_reviews;
