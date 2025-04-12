/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

CREATE VIEW report_customers AS 
WITH CTE AS (
SELECT
f.order_number,
f.product_key,
f.sales_amount,
f.order_date,
f.quantity,
c.customer_key,
c.customer_number,
CONCAT(first_name, ' ', last_name) AS customer_name,
TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) AS Age
FROM fact_sales f
LEFT JOIN dim_customers c
ON f.customer_key=c.customer_key
), customer_aggregation AS 
(
SELECT 
customer_key,
customer_number,
customer_name,
Age,
COUNT(DISTINCT(order_number)) AS total_orders,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS quantity_purchased,
COUNT(DISTINCT(product_key)) AS total_products,
MAX(order_date) AS last_order,
TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS life_span
FROM CTE
GROUP BY customer_key, customer_number, customer_name, Age
ORDER BY customer_key, customer_number, customer_name, Age
)
SELECT 
customer_key,
customer_number,
customer_name,
Age,
total_orders,
total_sales,
quantity_purchased,
total_products,
life_span,
CASE WHEN life_span > 12 AND total_sales > 5000 THEN "VIP"
	 WHEN life_span > 12 AND total_sales < 5000 THEN "Regular"
     ELSE "New"
     END AS customer_segment,
CASE WHEN Age < 20 THEN "Under 20"
	 WHEN Age BETWEEN 20 AND 29 THEN "20-29"
     WHEN Age BETWEEN 30 AND 39 THEN "30-39"
     WHEN Age BETWEEN 40 AND 49 THEN "40-49"
     ELSE "Above 50"
     END AS Age_group,
last_order,
TIMESTAMPDIFF(MONTH, last_order, CURDATE()) AS recency,
CASE WHEN total_orders = 0 THEN 0
	 ELSE total_sales/total_orders 
END AS avg_order_val,
CASE WHEN life_span = 0 THEN 0
	 ELSE total_sales/life_span 
END AS avg_month_sales
-- AVG(total_sales) OVER (PARTITION BY customer_key, customer_number, customer_name ORDER BY customer_key, customer_number, customer_name) AS avg_order_val,
-- AVG(total_sales) OVER (PARTITION BY MONTH(last_order) ORDER BY MONTH(last_order)) AS avg_monthly_val
FROM customer_aggregation
GROUP BY customer_key, customer_number, customer_name, Age
ORDER BY customer_key, customer_number, customer_name, Age;