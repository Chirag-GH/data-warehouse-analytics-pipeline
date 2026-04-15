/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Determine the first and last order date and the total duration in months
SELECT 
	*,
	DATEDIFF(YEAR, first_order, last_order) AS order_range_years
FROM(SELECT
		customer_key,
		MIN(order_date)	AS first_order,
		MAX(order_date)	AS last_order
	FROM gold.fact_sales
	GROUP BY customer_key
)t

-- Find the youngest and oldest customer based on birthdate
SELECT
	DATEDIFF(YEAR, MAX(birthdate), GETDATE())	AS youngest,
	DATEDIFF(YEAR, MIN(birthdate), GETDATE())	AS oldest
FROM gold.dim_customers
