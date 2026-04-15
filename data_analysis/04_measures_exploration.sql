/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Find the Total Sales
SELECT	'Total Sales'		AS measure_name, SUM(sale_amount)				AS measure_value FROM gold.fact_sales
UNION ALL
-- Find how many items are sold
SELECT	'Total Quantity'	AS measure_name, SUM(quantity)					AS measure_value FROM gold.fact_sales
UNION ALL
-- Find the average selling price
SELECT	'Average Price'		AS measure_name, AVG(price)						AS measure_value FROM gold.fact_sales
UNION ALL
-- Find the Total number of Orders
SELECT	'Total Orders'		AS measure_name, COUNT(DISTINCT order_number)	AS measure_value FROM gold.fact_sales
UNION ALL
-- Find the total number of customers that has placed an order
SELECT	'Total Customers With Orders'	AS measure_name, COUNT(DISTINCT customer_key)	AS measure_value FROM gold.fact_sales
UNION ALL
-- Find the total number of products
SELECT 'Total Products'		AS measure_name, COUNT(product_key)				AS nr_products	FROM gold.dim_products
UNION ALL
-- Find the total number of customers
SELECT 'Total Customers'	AS measure_name, COUNT(customer_key)			AS nr_customers FROM gold.dim_customers
