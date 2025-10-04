
/* 02_load_silver.sql : Transform bronze -> silver */
USE DataWarehouse;
GO

CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @ts_start DATETIME2, @ts_end DATETIME2;

  PRINT 'Loading SILVER layer...';

  -- ============ CRM Customer Info (clean)
  SET @ts_start = SYSDATETIME();
  TRUNCATE TABLE silver.crm_customer_info;

  INSERT INTO silver.crm_customer_info (cid, customer_key, first_name, last_name, marital_status, gender, create_date)
  SELECT
    -- Clean cid: strip leading 'NAS' if present
    CASE WHEN LEFT(b.cid,3)='NAS' THEN SUBSTRING(b.cid,4,LEN(b.cid)) ELSE b.cid END AS cid,
    b.customer_key,
    b.first_name,
    b.last_name,
    b.marital_status,
    -- Normalize gender (Male/Female/Not available)
    CASE
      WHEN UPPER(LTRIM(RTRIM(b.gender))) IN ('M','MALE') THEN 'Male'
      WHEN UPPER(LTRIM(RTRIM(b.gender))) IN ('F','FEMALE') THEN 'Female'
      ELSE 'Not available'
    END AS gender,
    b.create_date
  FROM bronze.crm_customer_info b;

  SET @ts_end = SYSDATETIME();
  PRINT CONCAT('silver.crm_customer_info loaded in ', DATEDIFF(ms,@ts_start,@ts_end), ' ms');

  -- ============ ERP Customer (clean birth_date + id)
  SET @ts_start = SYSDATETIME();
  TRUNCATE TABLE silver.erp_customer;

  INSERT INTO silver.erp_customer (ci_id, birth_date, gender)
  SELECT
    -- Remove '-' in ci_id (e.g., 'AB-123' -> 'AB123')
    REPLACE(b.ci_id,'-','') AS ci_id,
    CASE WHEN b.birth_date > CAST(GETDATE() AS DATE) THEN NULL ELSE b.birth_date END AS birth_date,
    CASE
      WHEN UPPER(LTRIM(RTRIM(b.gender))) IN ('M','MALE') THEN 'Male'
      WHEN UPPER(LTRIM(RTRIM(b.gender))) IN ('F','FEMALE') THEN 'Female'
      ELSE 'Not available'
    END AS gender
  FROM bronze.erp_customer b;

  SET @ts_end = SYSDATETIME();
  PRINT CONCAT('silver.erp_customer loaded in ', DATEDIFF(ms,@ts_start,@ts_end), ' ms');

  -- ============ ERP Location (normalize country)
  SET @ts_start = SYSDATETIME();
  TRUNCATE TABLE silver.erp_location;

  INSERT INTO silver.erp_location (ci_id, country)
  SELECT
    REPLACE(ci_id,'-','') AS ci_id,
    CASE
      WHEN LTRIM(RTRIM(country)) IS NULL OR LTRIM(RTRIM(country)) = '' THEN 'Not available'
      WHEN UPPER(LTRIM(RTRIM(country))) = 'DE' THEN 'Germany'
      WHEN UPPER(LTRIM(RTRIM(country))) IN ('US','USA') THEN 'United States'
      ELSE LTRIM(RTRIM(country))
    END AS country
  FROM bronze.erp_location;

  SET @ts_end = SYSDATETIME();
  PRINT CONCAT('silver.erp_location loaded in ', DATEDIFF(ms,@ts_start,@ts_end), ' ms');
END;
GO
