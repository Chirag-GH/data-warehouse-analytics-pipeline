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

/*Segment products into cost ranges and 
count how many products fall into each segment*/

WITH product_segemnts AS(
SELECT
	product_name,
	cost,
	CASE	WHEN cost < 100 THEN 'Below 100'
			WHEN cost BETWEEN 100 AND 500 THEN '100-500'
			WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
			ELSE 'Above 1000'
	END AS cost_range
FROM gold.dim_products
)

SELECT 
	cost_range,
	COUNT(cost_range) AS nr_cost_range
FROM product_segemnts
GROUP BY cost_range
ORDER BY 2;

WITH customer_segemnts AS(
SELECT
	customer_key,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
	SUM(sale_amount) AS total_sales
FROM gold.fact_sales
GROUP BY customer_key
)

SELECT
	customer_range,
	COUNT(customer_range) AS nr_customer_range
FROM(SELECT
	*,
	CASE	WHEN lifespan < 12 THEN 'New'	
			WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
			ELSE 'VIP'
	END AS customer_range
FROM customer_segemnts
)t GROUP BY customer_range