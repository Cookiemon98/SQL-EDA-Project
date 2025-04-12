/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

-- Analyze the yearly performance of products by comparing their sales to both the average sales and previous year sales
-- Creating a CTE (table) for writing simple queries for reqiurements
WITH yearly_product_sales AS (
SELECT
YEAR(order_date) AS order_year,
p.product_name,
SUM(sales_amount) AS current_sales
FROM fact_sales f
LEFT JOIN dim_products p ON f.product_key=p.product_key
GROUP BY YEAR(order_date) ,p.product_name
ORDER BY YEAR(order_date)
)
SELECT 
order_year,
product_name,
current_sales,
AVG(current_sales) OVER(PARTITION BY product_name) avg_sales, -- using OVER and Partition By to calculate avg sales based on dfferent products, can also be done for differet years
(current_sales - AVG(current_sales) OVER(PARTITION BY product_name)) AS diff_avg, 
CASE WHEN (current_sales - AVG(current_sales) OVER(PARTITION BY product_name)) < 0 THEN 'Below Avg' 
	 WHEN (current_sales - AVG(current_sales) OVER(PARTITION BY product_name)) > 0 THEN 'Above Avg'
     ELSE 'Avg'
END avg_change,
LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS py_sales, -- to access previous row value
current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py,
CASE WHEN (current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year)) < 0 THEN 'Dec from PY'
	 WHEN (current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year)) > 0 THEN 'Inc from PY'
     ELSE 'No Value'
END py_change
FROM yearly_product_sales
ORDER BY product_name, order_year;