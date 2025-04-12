/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables and their structure.
    - To inspect the columns and metadata for specific tables.

===============================================================================
*/

SELECT DISTINCT 
AVG(TIMESTAMPDIFF(YEAR, birthdate, CURDATE())) AS Avg_AGE
FROM dim_customers;

SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA='datawarehouse';

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='dim_customers';


-- Dimension Exploration
SELECT DISTINCT country
FROM dim_customers;

SELECT DISTINCT category, subcategory, product_name
FROM dim_products
ORDER BY category;
-- Need to update category and subcategory with data in the above query


-- Date Exploration
-- Finding the first and the last order
SELECT MIN(order_date) AS first_order_date,
MAX(order_date) AS last_order_date,
TIMESTAMPDIFF(Month, MIN(order_date), MAX(order_date)) AS difference
FROM fact_sales;

-- Finding the youngest and oldest customer
SELECT
MIN(birthdate),
TIMESTAMPDIFF(YEAR, MIN(birthdate), CURDATE()) AS oldest_customer,
MAX(birthdate),
TIMESTAMPDIFF(YEAR, MAX(birthdate), CURDATE()) AS youngest_customer
FROM dim_customers;