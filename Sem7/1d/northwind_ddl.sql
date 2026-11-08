CREATE DATABASE IF NOT EXISTS northwind_dwh;
USE northwind_dwh;

CREATE TABLE dim_categories (
    category_key INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    category_name VARCHAR(25) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE dim_suppliers (
    supplier_key INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id INT NOT NULL,
    supplier_name VARCHAR(50) NOT NULL,
    contact_name VARCHAR(50),
    address VARCHAR(50),
    city VARCHAR(20),
    postal_code VARCHAR(10),
    country VARCHAR(15),
    phone VARCHAR(15)
);

CREATE TABLE dim_products (
    product_key INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    product_name VARCHAR(50) NOT NULL,
    category_key INT NOT NULL,
    supplier_key INT NOT NULL,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (category_key) REFERENCES dim_categories(category_key),
    FOREIGN KEY (supplier_key) REFERENCES dim_suppliers(supplier_key)
);

CREATE TABLE dim_customers (
    customer_key INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    customer_name VARCHAR(50) NOT NULL,
    contact_name VARCHAR(50),
    address VARCHAR(50),
    city VARCHAR(20),
    postal_code VARCHAR(10),
    country VARCHAR(15)
);

CREATE TABLE dim_employees (
    employee_key INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    last_name VARCHAR(15) NOT NULL,
    first_name VARCHAR(15) NOT NULL,
    birth_date DATETIME,
    notes TEXT
);

CREATE TABLE dim_shippers (
    shipper_key INT AUTO_INCREMENT PRIMARY KEY,
    shipper_id INT NOT NULL,
    shipper_name VARCHAR(25) NOT NULL,
    phone VARCHAR(15)
);

CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL,
    day INT NOT NULL,
    month INT NOT NULL,
    quarter INT NOT NULL,
    year INT NOT NULL,
    day_of_week VARCHAR(15) NOT NULL
);

CREATE TABLE fact_sales (
    sales_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    order_detail_id INT NOT NULL,
    product_key INT NOT NULL,
    customer_key INT NOT NULL,
    employee_key INT NOT NULL,
    shipper_key INT NOT NULL,
    date_key INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    line_total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (product_key) REFERENCES dim_products(product_key),
    FOREIGN KEY (customer_key) REFERENCES dim_customers(customer_key),
    FOREIGN KEY (employee_key) REFERENCES dim_employees(employee_key),
    FOREIGN KEY (shipper_key) REFERENCES dim_shippers(shipper_key),
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);