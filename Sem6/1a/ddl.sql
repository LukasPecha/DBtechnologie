CREATE DATABASE IF NOT EXISTS movielens_dwh;
USE movielens_dwh;

CREATE TABLE dim_users (
    user_key INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    age INT,
    age_group_name VARCHAR(45),
    gender CHAR(1),
    occupation_name VARCHAR(255),
    zip_code VARCHAR(255)
);

CREATE TABLE dim_movies (
    movie_key INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    release_year CHAR(4)
);

CREATE TABLE dim_genres (
    genre_key INT AUTO_INCREMENT PRIMARY KEY,
    genre_id INT NOT NULL,
    genre_name VARCHAR(255) NOT NULL
);

CREATE TABLE bridge_movie_genres (
    movie_key INT NOT NULL,
    genre_key INT NOT NULL,
    PRIMARY KEY (movie_key, genre_key),
    FOREIGN KEY (movie_key) REFERENCES dim_movies(movie_key) ON DELETE CASCADE,
    FOREIGN KEY (genre_key) REFERENCES dim_genres(genre_key) ON DELETE CASCADE
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

CREATE TABLE fact_ratings (
    rating_id INT AUTO_INCREMENT PRIMARY KEY,
    user_key INT NOT NULL,
    movie_key INT NOT NULL,
    date_key INT NOT NULL,
    rating INT NOT NULL,
    rated_at DATETIME NOT NULL,
    FOREIGN KEY (user_key) REFERENCES dim_users(user_key),
    FOREIGN KEY (movie_key) REFERENCES dim_movies(movie_key),
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);