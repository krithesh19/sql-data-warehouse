
-- tests/quality_checks_silver.sql
USE DataWarehouse;
GO

PRINT 'SILVER: gender values (should be Male/Female/Not available)';
SELECT DISTINCT gender FROM silver.crm_customer_info;
SELECT DISTINCT gender FROM silver.erp_customer;

PRINT 'SILVER: birth_date future values (should be zero rows)';
SELECT * FROM silver.erp_customer WHERE birth_date > CAST(GETDATE() AS DATE);

PRINT 'SILVER: country values normalized';
SELECT DISTINCT country FROM silver.erp_location ORDER BY 1;
GO
