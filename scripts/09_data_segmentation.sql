/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

-- Segment Products based on Cost Ranges, and count how many products fall into each category
WITH segment_cost AS (
SELECT product_key,
product_name,
cost,
CASE WHEN cost <=500 THEN "Below 500"
	 WHEN cost > 500 AND cost <= 1000 THEN "Between 500 to 1000" -- Can use this as well BETWEEN 500 AND 1000
     ELSE "Above 1000"
     END cost_range
FROM dim_products)
SELECT cost_range,
COUNT(product_key) AS count
FROM segment_cost
GROUP BY cost_range
ORDER BY COUNT(product_key);



-- Group customers into 3 segments:-
-- 1. VIP- Customers with at least 12 months of history and spends more than $5000
-- 2. Regular- Customers with at least 12 months of history and spending less than $5000
-- 3. New- Customers with less than 12 months of shopping history
-- Find the total number of customers by each group
WITH sales_table AS (
SELECT 
c. customer_key,
MIN(f.order_date) AS first_order,
MAX(f.order_date) AS last_order,
TIMESTAMPDIFF(month, MIN(f.order_date), MAX(f.order_date)) AS lifespan,
SUM(sales_amount) total_sales
-- CASE WHEN DATEDIFF(MAX(f.order_date), MIN(f.order_date)) >365 AND SUM(sales_amount) > 5000 THEN "VIP"
-- 	 WHEN DATEDIFF(MAX(f.order_date), MIN(f.order_date)) >365 AND SUM(sales_amount) <= 5000 THEN "Regular"
--      ELSE "New"
-- END customer_segment
FROM fact_sales f
LEFT JOIN dim_customers c ON f.customer_key=c.customer_key
GROUP BY customer_key)
SELECT
customer_segment,
COUNT(customer_key) AS customer_count
FROM (
	SELECT customer_key,
	CASE WHEN lifespan >12 AND total_sales > 5000 THEN "VIP"
		 WHEN lifespan >12 AND total_sales <= 5000 THEN "Regular"
		 ELSE "New"
	END customer_segment
	FROM sales_table) t
GROUP BY customer_segment;

-- Second Way
WITH CTE AS (
SELECT
c.customer_key,
SUM(f.sales_amount) AS total_sales,
MIN(order_date) AS first_order,
MAX(order_date) AS last_order,
TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
CASE WHEN TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) >= 12 AND SUM(f.sales_amount) >5000 THEN "VIP"
	 WHEN TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) >= 12 AND SUM(f.sales_amount) <5000 THEN "Regular"
     ELSE "New"
END AS customer_segment
FROM fact_sales f
LEFT JOIN dim_customers c ON f.customer_key=c.customer_key
GROUP BY c.customer_key
ORDER BY c.customer_key) 
SELECT 
customer_segment,
COUNT(customer_key) AS total_customers
FROM CTE
GROUP BY customer_segment
ORDER BY COUNT(customer_key) DESC;