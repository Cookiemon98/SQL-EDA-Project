/*
=============================================================
Create Database and Tables
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouse' after checking if it already exists. 
    If the database exists, it is dropped and recreated.
	
WARNING:
    Running this script will drop the entire 'DataWarehouse' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/


DROP DATABASE IF EXISTS DataWareshouse;
CREATE DATABASE DataWarehouse;
USE DataWarehouse;

-- Creating the tables in the database
CREATE TABLE dim_customers (
	customer_key INT PRIMARY KEY,
    customer_id INT,
    customer_number VARCHAR(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    country VARCHAR(50),
    marital_status VARCHAR(50),
    gender VARCHAR(50),
    birthdate DATE,
    create_date DATE
);

CREATE TABLE dim_products (
	product_key INT PRIMARY KEY,
    poduct_id INT,
    product_number VARCHAR(50),
    product_name VARCHAR(50),
    category_id VARCHAR(50),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    maintenance VARCHAR(50),
    cost INT,
    product_line VARCHAR(50),
    start_date DATE
);

CREATE TABLE fact_sales (
	order_number VARCHAR(50),
    product_key INT,
    customer_key INT,
    order_date DATE,
    shipping_date DATE,
    due_date DATE,
    sales_amount INT,
    quantity TINYINT,
    price INT,
    PRIMARY KEY (order_number, product_key, customer_key),
    CONSTRAINT fk_product FOREIGN KEY (product_key) REFERENCES dim_products(product_key) ON DELETE CASCADE,
    CONSTRAINT fk_customer FOREIGN KEY (customer_key) REFERENCES dim_customers(customer_key) ON DELETE CASCADE
);


-- Loading Data into the tables 
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\sql-data-analytics-project-main\\datasets\\csv-files\\gold.dim_customers.csv'
INTO TABLE dim_customers
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\sql-data-analytics-project-main\\datasets\\csv-files\\gold.dim_products.csv'
INTO TABLE dim_products
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\sql-data-analytics-project-main\\datasets\\csv-files\\gold.fact_sales.csv'
INTO TABLE fact_sales
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;