/*
===============================================================================
Fact & Dimensions Exploration including
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - COUNT
    - SUM
    - DISTINCT
    - ORDER BY
===============================================================================
*/

SELECT*
FROM fact_sales;

-- Finding the total sales amount
SELECT SUM(sales_amount) AS total_sales
FROM fact_sales;

-- Finding the total quantity sold
SELECT SUM(quantity) AS total_quantity
FROM fact_sales;

-- Finding the avergae sales price
SELECT AVG(sales_amount) AS avg_price
FROM fact_sales;

-- Finding the total number of orders
SELECT COUNT(order_number) as total_orders
FROM fact_sales;

SELECT COUNT(order_number) as total_orders
FROM fact_sales;

-- Finding the total number of products
SELECT *
FROM dim_products;

SELECT COUNT(product_key) as total_products
FROM dim_products;

SELECT COUNT(DISTINCT(product_key)) as total_products
FROM dim_products;


-- Finding the total number of customers
SELECT *
FROM dim_customers;

SELECT COUNT(customer_key) as total_customers
FROM dim_customers;

-- Finding the total number of customers who placed an order
SELECT COUNT(DISTINCT(customer_key)) as total_customers
FROM fact_sales;


-- Generate a report that shows all key metrics of the business
SELECT 'Total Sales' as measure_name, SUM(sales_amount) AS measure_value FROM fact_sales
UNION 
SELECT 'Total Quantity' as measure_name, SUM(quantity) AS measure_value FROM fact_sales
UNION
SELECT 'Average Sales' as measure_name, AVG(sales_amount) AS measure_value FROM fact_sales
UNION
SELECT 'Total Orders' as measure_name, COUNT(order_number) as measure_value FROM fact_sales
UNION
SELECT 'Total Unique Orders' as measure_name, COUNT(DISTINCT(order_number)) as measure_value FROM fact_sales
UNION
SELECT 'Total Products' as measure_name, COUNT(product_key) as measure_value FROM dim_products
UNION
SELECT 'Total Customers' as measure_name, COUNT(customer_key) as measure_value FROM dim_customers;