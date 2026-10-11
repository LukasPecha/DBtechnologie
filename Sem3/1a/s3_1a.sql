-- Active: 1790178479693@@127.0.0.1@5432@superstore
/* Uloha 1*/
CREATE VIEW high_value_customers AS
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(o.sales) AS total_sales
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.sales) > 2000;

SELECT * FROM high_value_customers;

/* Uloha 2*/

CREATE VIEW regional_monthly_sales AS
SELECT 
    c.region,
    DATE_TRUNC('month', o.order_date)::DATE AS month,
    SUM(o.sales) AS monthly_sales
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.region, DATE_TRUNC('month', o.order_date);

SELECT * 
FROM regional_monthly_sales
WHERE region = 'West'
ORDER BY month;

/* Uloha 3*/
CREATE VIEW analyst_orders AS
SELECT 
    order_id,
    customer_id,
    product_id,
    sales,
    quantity,
    discount
FROM orders;

SELECT * FROM analyst_orders;

/* Uloha 4*/

CREATE INDEX idx_orders_customer_id 
ON orders (customer_id);

SELECT * 
FROM orders 
WHERE customer_id = 'C001';

/* Uloha 5*/

CREATE INDEX idx_orders_order_date 
ON orders (order_date);

SELECT 
    DATE_TRUNC('month', order_date)::DATE AS month,
    SUM(sales) AS sum
FROM orders
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month ASC;

/* Uloha 6*/

CREATE INDEX idx_orders_region_category 
ON orders (customer_id, order_date);

SELECT 
    c.customer_name,
    c.region,
    o.order_date,
    o.profit
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE LOWER(c.region) = 'west'
  AND o.order_date >= '2024-01-01';

/* Uloha 7*/

EXPLAIN ANALYZE
SELECT *
FROM orders
WHERE customer_id = 'C001';

/* DB retail_sales*/

CREATE DATABASE retail_sales;

ALTER DATABASE retail_sales SET datestyle TO 'ISO, MDY';

CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    product_id VARCHAR(20) NOT NULL,
    order_date DATE NOT NULL,
    region VARCHAR(20) NOT NULL,
    category VARCHAR(50) NOT NULL,
    ship_mode VARCHAR(30) NOT NULL,
    sales DECIMAL(10, 2) NOT NULL,
    profit DECIMAL(10, 2) NOT NULL
);

SELECT * FROM orders;

/* Uloha 8*/

CREATE OR REPLACE PROCEDURE get_customer_sales(p_customer_id VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_sales DECIMAL(10, 2);
BEGIN
    SELECT COALESCE(SUM(sales), 0)
    INTO v_total_sales
    FROM orders
    WHERE customer_id = p_customer_id;

    RAISE NOTICE 'Zákazník: %, Celkový predaj: %', p_customer_id, v_total_sales;
END;
$$;
CALL get_customer_sales('C001');

/* Uloha 9*/

CREATE OR REPLACE PROCEDURE apply_regional_discount(
    p_region_name VARCHAR,
    p_discount_rate DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE orders o
    SET sales = o.sales * (1 - p_discount_rate)
    FROM customers c
    WHERE o.customer_id = c.customer_id
      AND LOWER(c.region) = LOWER(p_region_name);

    RAISE NOTICE 'Aplikovaná zľava % pre región %.', p_discount_rate, p_region_name;
END;
$$;

CALL apply_regional_discount('West', 0.10);
CALL apply_regional_discount('West', 0.10);

/* Uloha 10*/
CREATE OR REPLACE PROCEDURE get_sales_between(
    start_date DATE,
    end_date DATE
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_sales DECIMAL(10, 2);
BEGIN
    SELECT COALESCE(SUM(sales), 0)
    INTO v_total_sales
    FROM orders
    WHERE order_date BETWEEN start_date AND end_date;

    RAISE NOTICE 'Obdobie od % do %, Celkový predaj: %', start_date, end_date, v_total_sales;
END;
$$;

CALL get_sales_between('2024-01-01', '2024-03-31');