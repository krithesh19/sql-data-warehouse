
/* 02_silver_tables.sql : Cleaned/standardized DDL */
USE DataWarehouse;
GO

IF OBJECT_ID('silver.crm_customer_info') IS NOT NULL DROP TABLE silver.crm_customer_info;
CREATE TABLE silver.crm_customer_info (
  cid            VARCHAR(64)  NULL,
  customer_key   VARCHAR(64)  NULL,
  first_name     VARCHAR(100) NULL,
  last_name      VARCHAR(100) NULL,
  marital_status VARCHAR(20)  NULL,
  gender         VARCHAR(50)  NULL,
  create_date    DATE         NULL,
  _dw_loaded_at  DATETIME2    NOT NULL DEFAULT SYSDATETIME()
);

IF OBJECT_ID('silver.erp_customer') IS NOT NULL DROP TABLE silver.erp_customer;
CREATE TABLE silver.erp_customer (
  ci_id       VARCHAR(64) NULL,
  birth_date  DATE        NULL,
  gender      VARCHAR(50) NULL,
  _dw_loaded_at DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

IF OBJECT_ID('silver.erp_location') IS NOT NULL DROP TABLE silver.erp_location;
CREATE TABLE silver.erp_location (
  ci_id       VARCHAR(64)  NULL,
  country     VARCHAR(100) NULL,
  _dw_loaded_at DATETIME2  NOT NULL DEFAULT SYSDATETIME()
);
