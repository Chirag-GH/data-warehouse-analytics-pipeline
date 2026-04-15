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

-- Which 5 products Generating the Highest Revenue?
-- Simple Ranking
SELECT TOP 5
	dp.product_name,
	SUM(fs.sale_amount) AS 'Best Performing Product'
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp
ON fs.product_key = dp.product_key
GROUP BY dp.product_name
ORDER BY 2 DESC

-- What are the 5 worst-performing products in terms of sales?
SELECT TOP 5
	dp.product_name,
	SUM(fs.sale_amount) AS 'Worst Performing Product'
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp
ON fs.product_key = dp.product_key
GROUP BY dp.product_name
ORDER BY 2 ASC

-- Complex but Flexibly Ranking Using Window Functions
SELECT
	*
FROM(SELECT 
	dp.product_name,
	ROW_NUMBER() OVER(ORDER BY SUM(fs.sale_amount) DESC) AS rank_products
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp
ON fs.product_key = dp.product_key
GROUP BY dp.product_name
)t WHERE rank_products <= 5

-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
	dc.customer_key,
	dc.first_name,
	dc.last_name,
	SUM(sale_amount) AS 'Top 10 Customers/Revenue'
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
ON fs.customer_key = dc.customer_key
GROUP BY dc.customer_key, dc.first_name, dc.last_name
ORDER BY 4 DESC

-- The 3 customers with the fewest orders placed
SELECT TOP 3
	dc.customer_key,
	dc.first_name,
	dc.last_name,
	COUNT(DISTINCT order_number) AS 'Least Places Orders/Customer'
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
ON fs.customer_key = dc.customer_key
GROUP BY dc.customer_key, dc.first_name, dc.last_name
ORDER BY 4 ASC