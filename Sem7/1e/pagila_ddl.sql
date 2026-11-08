CREATE DATABASE IF NOT EXISTS pagila_dwh;
USE pagila_dwh;

CREATE TABLE dim_categories (
    category_key INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    category_name VARCHAR(25) NOT NULL
);

CREATE TABLE dim_languages (
    language_key INT AUTO_INCREMENT PRIMARY KEY,
    language_id INT NOT NULL,
    language_name VARCHAR(20) NOT NULL
);

CREATE TABLE dim_address (
    address_key INT AUTO_INCREMENT PRIMARY KEY,
    address_id INT NOT NULL,
    address VARCHAR(50) NOT NULL,
    district VARCHAR(20),
    city VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    postal_code VARCHAR(10)
);

CREATE TABLE dim_films (
    film_key INT AUTO_INCREMENT PRIMARY KEY,
    film_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    release_year INT,
    rental_duration INT,
    rental_rate DECIMAL(4,2),
    length INT,
    rating VARCHAR(10),
    category_key INT NOT NULL,
    language_key INT NOT NULL,
    FOREIGN KEY (category_key) REFERENCES dim_categories(category_key),
    FOREIGN KEY (language_key) REFERENCES dim_languages(language_key)
);

CREATE TABLE dim_customers (
    customer_key INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    email VARCHAR(50),
    active TINYINT(1) DEFAULT 1,
    address_key INT NOT NULL,
    FOREIGN KEY (address_key) REFERENCES dim_address(address_key)
);

CREATE TABLE dim_staff (
    staff_key INT AUTO_INCREMENT PRIMARY KEY,
    staff_id INT NOT NULL,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    email VARCHAR(50),
    active TINYINT(1) DEFAULT 1
);

CREATE TABLE dim_store (
    store_key INT AUTO_INCREMENT PRIMARY KEY,
    store_id INT NOT NULL,
    address_key INT NOT NULL,
    FOREIGN KEY (address_key) REFERENCES dim_address(address_key)
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

CREATE TABLE fact_rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    rental_db_id INT NOT NULL,
    film_key INT NOT NULL,
    customer_key INT NOT NULL,
    staff_key INT NOT NULL,
    store_key INT NOT NULL,
    date_key INT NOT NULL,
    rental_duration_days INT,
    amount DECIMAL(5,2),
    FOREIGN KEY (film_key) REFERENCES dim_films(film_key),
    FOREIGN KEY (customer_key) REFERENCES dim_customers(customer_key),
    FOREIGN KEY (staff_key) REFERENCES dim_staff(staff_key),
    FOREIGN KEY (store_key) REFERENCES dim_store(store_key),
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);