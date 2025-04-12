/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Top 5 best performing products
SELECT 
p.product_name, SUM(f.sales_amount) AS total_revenue
FROM fact_sales f
LEFT JOIN dim_products p ON f.product_key=p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Top 5 worst performinh products
SELECT 
p.product_name, SUM(f.sales_amount) AS total_revenue
FROM fact_sales f
LEFT JOIN dim_products p ON f.product_key=p.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC
LIMIT 5;

-- Ranking the products
SELECT
	p.product_name, SUM(f.sales_amount) AS total_revenue,
	ROW_NUMBER() OVER(ORDER BY SUM(f.sales_amount) DESC) AS Rank_products
	FROM fact_sales f
	LEFT JOIN dim_products p ON f.product_key=p.product_key
	GROUP BY p.product_name
	ORDER BY total_revenue DESC;

-- Using it as a subquery
SELECT *
FROM (
	SELECT
	p.product_name, SUM(f.sales_amount) AS total_revenue,
	ROW_NUMBER() OVER(ORDER BY SUM(f.sales_amount) DESC) AS Rank_products
	FROM fact_sales f
	LEFT JOIN dim_products p ON f.product_key=p.product_key
	GROUP BY p.product_name
	ORDER BY total_revenue DESC) TABEL
WHERE Rank_products <= 5;


-- Top 10 customers generating highest revenue 
SELECT f.customer_key, d.first_name, d.last_name, SUM(f.sales_amount) AS total_revenue
FROM fact_sales f
LEFT JOIN dim_customers d on f.customer_key=d.customer_key
GROUP BY f.customer_key, d.first_name, d.last_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Top 3 customers with fewest orders
SELECT c.customer_key, c.first_name, c.last_name, COUNT(DISTINCT order_number) AS orders_placed
FROM fact_sales f
LEFT JOIN dim_customers c ON f.customer_key=c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY orders_placed ASC
LIMIT 3;