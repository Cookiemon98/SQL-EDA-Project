/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/

CREATE VIEW report_products AS 
WITH CTE2 AS (
SELECT 
p.product_key,
p.product_name,
p.category,
p.subcategory,
p.cost,
p.start_date,
f.order_number,
f.customer_key,
f.order_date,
f.sales_amount,
f.quantity
FROM fact_sales f
JOIN dim_products p
ON f.product_key=p.product_key)
, product_aggregation AS (
SELECT 
product_key,
product_name,
category,
subcategory,
TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS life_span,
MAX(order_date) AS last_sale_date,
COUNT(DISTINCT(order_number)) AS total_orders,
COUNT(DISTINCT(customer_key)) AS total_customers,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
ROUND(CAST(sales_amount AS FLOAT)/COALESCE(quantity,0),1) AS avg_sp
FROM CTE2
GROUP BY 
product_key,
product_name,
category,
subcategory
ORDER BY 
product_key,
product_name,
category,
subcategory)
SELECT
product_key,
product_name,
category,
subcategory,
last_sale_date,
TIMESTAMPDIFF(MONTH, last_sale_date, CURDATE()) AS recency,
CASE WHEN total_sales < 50000 THEN "Low-Performers"
	 WHEN total_sales BETWEEN 50000 AND 100000 THEN "Mid-Range"
	 ELSE "High-Performers"
END AS product_segment,
life_span,
total_orders,
total_sales,
total_quantity,
total_customers,
avg_sp,
CASE WHEN total_orders = 0 THEN 0
	 ELSE ROUND(total_sales/total_orders, 2)
END AS avg_order_val,
CASE WHEN life_span = 0 THEN 0
	 ELSE ROUND(total_sales/life_span,2)
END AS avg_monthly_rev
FROM product_aggregation
GROUP BY 
product_key,
product_name,
category,
subcategory
ORDER BY 
product_key,
product_name,
category,
subcategory;