
-- tests/quality_checks_gold.sql
USE DataWarehouse;
GO

PRINT 'GOLD: uniqueness checks for surrogate keys';
SELECT COUNT(*) total_rows, COUNT(DISTINCT customer_key) distinct_keys FROM gold.dim_customers;
SELECT COUNT(*) total_rows, COUNT(DISTINCT product_key)  distinct_keys FROM gold.dim_products;

PRINT 'GOLD: referential checks (should return zero rows)';
SELECT fs.* FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc ON fs.customer_key = dc.customer_key
WHERE dc.customer_key IS NULL;

SELECT fs.* FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp ON fs.product_key = dp.product_key
WHERE dp.product_key IS NULL;
GO
