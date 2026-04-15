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
-- Which categories contribute the most to overall sales?

WITH category_sales AS(
	SELECT
		category,
		SUM(sale_amount) AS total_sale_category
	FROM gold.fact_sales AS fs
	LEFT JOIN gold.dim_products AS dp
	ON fs.product_key = dp.product_key
	GROUP BY category
)
SELECT
	*,
	SUM(total_sale_category) OVER() AS overall_sales,
	CONCAT(ROUND(total_sale_category/CAST(SUM(total_sale_category) OVER() AS FLOAT)*100, 2), '%') AS part2whole
FROM category_sales
ORDER BY part2whole DESC