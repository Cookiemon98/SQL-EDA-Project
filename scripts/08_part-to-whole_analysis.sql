/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/


-- Which Categories contributes most to the overall sales?
WITH category_sales AS (
SELECT
category,
SUM(sales_amount) AS total_sales
FROM fact_sales f
LEFT JOIN dim_products p ON f.product_key=p.product_key
GROUP BY category
ORDER BY category)
SELECT 
category,
total_sales,
SUM(total_sales) OVER() AS overall_sales,
CONCAT(ROUND((total_sales/SUM(total_sales) OVER())*100, 2), '%') AS weightage
FROM category_sales
ORDER BY total_sales DESC;



-- Which country contributes to the overall sales?
WITH country_sales AS (
SELECT
country,
SUM(sales_amount) AS total_sales
FROM fact_sales f
LEFT JOIN dim_customers c ON f.customer_key=c.customer_key
GROUP BY country)
SELECT 
country,
total_sales,
SUM(total_sales) OVER() AS overall_sales,
CONCAT(ROUND(((total_sales/SUM(total_sales) OVER())*100), 2), '%') AS weightage
FROM country_sales
ORDER BY total_sales DESC;