-- Active: 1790178479693@@127.0.0.1@5432@datacraftinglab_db

/* Uloha 1*/

CREATE DATABASE datacraftinglab_db;

CREATE TABLE flourmills_sales (
    sales_id INT PRIMARY KEY,
    sale_date DATE,
    region VARCHAR(100),
    state VARCHAR(100),
    product_category VARCHAR(100),
    product_name VARCHAR(150),
    customer_type VARCHAR(100),
    customer_id INT,
    quantity_sold INT,
    unit_price DECIMAL(10, 2),
    discount_rate INT,
    payment_method VARCHAR(100),
    sales_rep VARCHAR(150),
    warehouse VARCHAR(100),
    delivery_status VARCHAR(100),
    order_channel VARCHAR(100),
    batch_number INT,
    production_date DATE,
    total_amount DECIMAL(10, 2)
);

SELECT * 
FROM flourmills_sales;

/* Uloha 2*/

SELECT product_name, total_amount
FROM flourmills_sales
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM flourmills_sales
);

/* Uloha 3*/
SELECT *
FROM flourmills_sales
WHERE product_category = (
    SELECT product_category
    FROM flourmills_sales
    GROUP BY product_category
    ORDER BY SUM(total_amount) DESC
    LIMIT 1
)
ORDER BY sales_id ASC;

/* Uloha 4*/
SELECT 
    product_name,
    total_amount,
    (SELECT AVG(total_amount) FROM flourmills_sales) AS avg_amount
FROM flourmills_sales;

/* Uloha 5*/
SELECT 
    product_name,
    total_amount,
    total_amount / (SELECT SUM(total_amount) FROM flourmills_sales) AS amount_share
FROM flourmills_sales;

/* Uloha 6*/
SELECT month, monthly_sales
FROM (
    SELECT 
        EXTRACT(MONTH FROM sale_date) AS month,
        SUM(total_amount) AS monthly_sales
    FROM flourmills_sales
    GROUP BY EXTRACT(MONTH FROM sale_date)
) AS monthly_summary
ORDER BY monthly_sales DESC;

/* Uloha 7*/
SELECT product_category, total_sales
FROM (
    SELECT 
        product_category,
        SUM(total_amount) AS total_sales
    FROM flourmills_sales
    GROUP BY product_category
) AS category_summary
WHERE total_sales > 50000000
ORDER BY total_sales DESC;

/* Uloha 8*/
SELECT 
    t1.product_name,
    t1.product_category,
    t1.total_amount
FROM flourmills_sales t1
WHERE t1.total_amount > (
    SELECT AVG(t2.total_amount)
    FROM flourmills_sales t2
    WHERE t2.product_category = t1.product_category
);

/* Uloha 9*/
SELECT 
    t1.product_name,
    t1.region,
    t1.total_amount,
    (
        SELECT MIN(t2.total_amount)
        FROM flourmills_sales t2
        WHERE t2.region = t1.region
    ) AS region_min_amount
FROM flourmills_sales t1;

/* Uloha 10*/
SELECT t1.*
FROM flourmills_sales t1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales t2
    WHERE t2.product_name = t1.product_name
    HAVING COUNT(DISTINCT EXTRACT(MONTH FROM t2.sale_date)) > 1
);

/* Uloha 11*/
SELECT t1.product_category, t1.product_name, t1.total_amount
FROM flourmills_sales t1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales t2
    WHERE t2.product_category = t1.product_category
      AND t2.total_amount > 200000
);

/* Uloha 12*/
SELECT DISTINCT t1.product_category
FROM flourmills_sales t1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales t2
    WHERE t2.product_category = t1.product_category
    HAVING COUNT(DISTINCT t2.region) > 3
);

/* Uloha 13*/
SELECT t1.*
FROM flourmills_sales t1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales t2
    WHERE t2.region = t1.region
      AND EXTRACT(YEAR FROM t2.sale_date) = 2024
);

/* Uloha 14*/
SELECT DISTINCT t1.product_category
FROM flourmills_sales t1
WHERE NOT EXISTS (
    SELECT 1
    FROM flourmills_sales t2
    WHERE t2.product_category = t1.product_category
      AND t2.total_amount > 500000
);

/* Uloha 15*/
SELECT DISTINCT t1.region
FROM flourmills_sales t1
WHERE NOT EXISTS (
    SELECT 1
    FROM flourmills_sales t2
    WHERE t2.region = t1.region
      AND t2.product_category = 'Flour'
);