
-- tests/quality_checks_bronze.sql
USE DataWarehouse;
GO

PRINT 'BRONZE: row counts';
SELECT 'crm_customer_info' AS tbl, COUNT(*) cnt FROM bronze.crm_customer_info
UNION ALL SELECT 'erp_customer', COUNT(*) FROM bronze.erp_customer
UNION ALL SELECT 'erp_location', COUNT(*) FROM bronze.erp_location
UNION ALL SELECT 'crm_product_info', COUNT(*) FROM bronze.crm_product_info
UNION ALL SELECT 'erp_product_category', COUNT(*) FROM bronze.erp_product_category
UNION ALL SELECT 'crm_sales', COUNT(*) FROM bronze.crm_sales;
GO
