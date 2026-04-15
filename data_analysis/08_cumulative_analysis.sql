/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

-- Calculate the total sales per month and the running total of sales over time 
SELECT 
	*,
	SUM(total_sales) OVER(PARTITION BY DATETRUNC(YEAR, order_date) ORDER BY order_date) AS rolling_total,
	AVG(avg_price) OVER(PARTITION BY DATETRUNC(YEAR, order_date) ORDER BY order_date) AS moving_average
FROM(SELECT
		DATETRUNC(MONTH, order_date) AS order_date,
		SUM(sale_amount) AS total_sales,
		AVG(price) AS avg_price
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(MONTH, order_date)
)t