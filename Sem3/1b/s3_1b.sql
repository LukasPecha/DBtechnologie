-- Active: 1790178479693@@127.0.0.1@5432@datacraftinglab_db
/* Uloha 1*/
WITH daily_sales AS (
    SELECT 
        sale_date,
        SUM(total_amount) AS total_daily_sales
    FROM flourmills_sales
    GROUP BY sale_date
)
SELECT 
    sale_date,
    total_daily_sales
FROM daily_sales
WHERE total_daily_sales > 3000000
ORDER BY total_daily_sales DESC;

/* Uloha 2*/

WITH category_sales AS (
    SELECT 
        product_category,
        SUM(total_amount) AS total_sales
    FROM flourmills_sales
    GROUP BY product_category
)
SELECT 
    product_category,
    total_sales
FROM category_sales
ORDER BY total_sales DESC;

/* Uloha 3*/

WITH product_sales AS (
    SELECT 
        product_category,
        product_name,
        SUM(total_amount) AS total_product_sales
    FROM flourmills_sales
    GROUP BY product_category, product_name
),
ranked_products AS (
    SELECT 
        product_category,
        product_name,
        total_product_sales,
        RANK() OVER (
            PARTITION BY product_category 
            ORDER BY total_product_sales DESC
        ) AS category_rank
    FROM product_sales
)
SELECT 
    product_category,
    total_product_sales,
    category_rank
FROM ranked_products
WHERE category_rank IN (1, 2, 3)
ORDER BY product_category, category_rank;

/* Uloha 4*/
WITH customer_revenue AS (
    SELECT 
        customer_type,
        SUM(total_amount) AS revenue
    FROM flourmills_sales
    GROUP BY customer_type
),
revenue_summary AS (
    SELECT 
        customer_type,
        revenue,
        SUM(revenue) OVER () AS total_revenue,
        ROUND((revenue / SUM(revenue) OVER ()) * 100, 2) AS revenue_percentage
    FROM customer_revenue
)
SELECT 
    customer_type,
    revenue,
    total_revenue,
    revenue_percentage
FROM revenue_summary
ORDER BY revenue DESC;

/* Uloha 5*/

WITH customer_transactions AS (
    SELECT 
        customer_id,
        product_name,
        sale_date,
        total_amount,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id 
            ORDER BY sale_date DESC
        ) AS rn
    FROM flourmills_sales
)
SELECT 
    customer_id,
    product_name,
    sale_date,
    total_amount
FROM customer_transactions
WHERE rn = 1
ORDER BY customer_id ASC;

/* Uloha 6*/
WITH RECURSIVE date_range AS (
    SELECT 
        MIN(sale_date)::DATE AS min_date,
        MAX(sale_date)::DATE AS max_date
    FROM flourmills_sales
),
sales_calendar AS (
    SELECT min_date AS calendar_date, max_date
    FROM date_range
    
    UNION ALL
    
    SELECT (calendar_date + 1)::DATE, max_date
    FROM sales_calendar
    WHERE calendar_date < max_date
)
SELECT calendar_date
FROM sales_calendar
ORDER BY calendar_date ASC;

/* Uloha 7*/
WITH RECURSIVE monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', sale_date)::DATE AS month,
        SUM(total_amount) AS revenue
    FROM flourmills_sales
    GROUP BY DATE_TRUNC('month', sale_date)
),
ordered_months AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY month) AS rn,
        month,
        revenue
    FROM monthly_revenue
),
cumulative_target AS (
    SELECT 
        rn,
        month,
        revenue,
        revenue AS cumulative_revenue
    FROM ordered_months
    WHERE rn = 1

    UNION ALL

    SELECT 
        om.rn,
        om.month,
        om.revenue,
        ct.cumulative_revenue + om.revenue
    FROM ordered_months om
    JOIN cumulative_target ct ON om.rn = ct.rn + 1
    WHERE ct.cumulative_revenue < 500000000
)
SELECT 
    rn,
    month,
    revenue,
    cumulative_revenue
FROM cumulative_target
ORDER BY rn;