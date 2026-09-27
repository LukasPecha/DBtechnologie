-- Active: 1790178479693@@127.0.0.1@5432@superstore
CREATE DATABASE cvicenie1;

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100)
);

CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    employee_id INT,
    FOREIGN KEY (employee_id)
    REFERENCES employees(employee_id)
);

SELECT * FROM projects;

/* Uloha 1*/
CREATE DATABASE superstore;

CREATE Table customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    region VARCHAR(50)
);

CREATE TABLE products (
    product_id VARCHAR(20) PRIMARY KEY,
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(100)
);

CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id),
    product_id VARCHAR(20),
    FOREIGN KEY (product_id)
    REFERENCES products(product_id),
    order_date DATE,
    ship_date DATE,
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(10,2),
    profit DECIMAL(10,2)
);


SELECT * FROM customers;

SELECT * FROM orders;

SELECT * FROM products;

/* Uloha 2*/
SELECT o.order_id, c.customer_name, o.sales
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
WHERE o.sales > 500
ORDER BY o.sales DESC;

/* Uloha 3*/
SELECT  o.order_id, c.customer_name, p.category, o.sales
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id;

/* Uloha 4*/
SELECT c.region, SUM(CASE WHEN o.sales IS NULL THEN 0 ELSE o.sales END) AS total
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.region;

/* Uloha 5*/

SELECT p.product_name, SUM(CASE WHEN o.sales IS NULL THEN 0 ELSE o.sales END) AS total
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name;

/* Uloha 6*/

SELECT c.customer_name, o.order_id, o.sales
FROM customers c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id;

/* Uloha 7*/

SELECT c.region, SUM(o.sales) AS total_sales
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.region;

/* Uloha 8*/
SELECT c.customer_name, COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

/* Uloha 9*/

SELECT p.category, AVG(o.discount) AS avg_discount
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category;

/* Uloha 10*/
SELECT c.customer_name, SUM(o.sales) AS total_sales
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.sales) > 2000;