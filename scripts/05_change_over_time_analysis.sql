/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

SELECT
YEAR(order_date) AS order_year, 
MONTH(order_date) AS order_month,
SUM(sales_amount) AS total_sales, 
SUM(quantity) AS total_quantity_ordered, 
COUNT(DISTINCT customer_key) AS total_customers
FROM fact_sales
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

SELECT
DATE_FORMAT(order_date, '%Y-%b') AS order_date,
SUM(sales_amount) AS total_sales, 
SUM(quantity) AS total_quantity_ordered, 
COUNT(DISTINCT customer_key) AS total_customers
FROM fact_sales
GROUP BY DATE_FORMAT(order_date, '%Y-%b')
ORDER BY DATE_FORMAT(order_date, '%Y-%b');