/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/


-- Calculate the total sales per month
SELECT
order_date,
total_sales,
SUM(total_sales) OVER(PARTITION BY order_date ORDER BY order_date) AS running_total_sales
FROM (
SELECT
DATE_FORMAT(order_date, '%Y-%m-01') AS order_date,
SUM(sales_amount) AS total_sales
FROM fact_sales
GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
)t;

SELECT
order_date,
total_sales,
SUM(total_sales) OVER(ORDER BY order_date) AS running_total_sales
FROM (
SELECT
DATE_FORMAT(order_date, '%Y-01-01') AS order_date,
SUM(sales_amount) AS total_sales
FROM fact_sales
GROUP BY DATE_FORMAT(order_date, '%Y-01-01')
)t