CREATE DATABASE IF NOT EXISTS chinook_dwh;
USE chinook_dwh;

CREATE TABLE dim_customers (
    customer_key INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    company VARCHAR(80),
    address VARCHAR(70),
    city VARCHAR(40),
    state VARCHAR(40),
    country VARCHAR(40),
    postal_code VARCHAR(10),
    phone VARCHAR(24),
    email VARCHAR(60) NOT NULL,
    support_rep_name VARCHAR(60)
);

CREATE TABLE dim_tracks (
    track_key INT AUTO_INCREMENT PRIMARY KEY,
    track_id INT NOT NULL,
    track_name VARCHAR(200) NOT NULL,
    album_title VARCHAR(160),
    artist_name VARCHAR(120),
    genre_name VARCHAR(120),
    media_type_name VARCHAR(120),
    composer VARCHAR(220),
    milliseconds INT,
    bytes INT
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
    invoice_id INT NOT NULL,
    invoice_line_id INT NOT NULL,
    customer_key INT NOT NULL,
    track_key INT NOT NULL,
    date_key INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    line_total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_key) REFERENCES dim_customers(customer_key),
    FOREIGN KEY (track_key) REFERENCES dim_tracks(track_key),
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);