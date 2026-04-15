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

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

WITH yearly_product_sales AS(
SELECT
	YEAR(fs.order_date) AS order_year,
	dp.product_name	AS product_name,
	SUM(fs.sale_amount) AS current_sales
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp
ON fs.product_key = dp.product_key
WHERE order_date IS NOT NULL
GROUP BY YEAR(fs.order_date), dp.product_name
)

SELECT
	*,
	current_sales - avg_sales AS diff_avg,
	current_sales - previous_year_sales AS diff_sales,
	CASE	WHEN (current_sales - avg_sales) > 0 THEN 'Above Avg'
			WHEN (current_sales - avg_sales) < 0 THEN 'Below Avg'
			ELSE 'Avg'
	END AS avg_change,
	CASE	WHEN (current_sales - previous_year_sales) > 0 THEN 'Increasing'
			WHEN (current_sales - previous_year_sales) < 0 THEN 'Decreasing'
			WHEN (current_sales - previous_year_sales) IS NULL THEN NULL
			ELSE 'Same'
	END AS yoy_change
FROM(SELECT
		*,
		LAG(current_sales, 1)	OVER(PARTITION BY product_name ORDER BY order_year ASC) AS previous_year_sales,
		AVG(current_sales)		OVER(PARTITION BY product_name) AS avg_sales
	FROM yearly_product_sales
)t