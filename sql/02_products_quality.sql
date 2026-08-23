-- Проверка структуры products

SELECT 
    COUNT(*) AS all_rows,
    COUNT(DISTINCT product_id) AS uniq_product_id,
    SUM(
        CASE 
            WHEN product_category_name IS NULL THEN 1 
            ELSE 0 
        END
    ) AS null_product_category,
    COUNT(DISTINCT product_category_name) AS uniq_product_category
FROM products;

-- Проверка пустых категорий в order_items и их продажи

SELECT 
    COUNT(DISTINCT p.product_id) AS empty_category_products,
    SUM(o.price + o.freight_value) AS sold_value
FROM products p
JOIN order_items o
    ON p.product_id = o.product_id
WHERE p.product_category_name = '';

-- Проверка скрытых пробелов

SELECT 
    COUNT(DISTINCT product_category_name) AS categories_original,
    COUNT(DISTINCT TRIM(product_category_name)) AS categories_trimmed
FROM products
WHERE product_category_name <> '';

-- Распределение товаров по категориям

SELECT 
    product_category_name,
    COUNT(*) AS products_count
FROM products
GROUP BY product_category_name
ORDER BY products_count DESC;