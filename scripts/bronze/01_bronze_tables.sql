
/* 01_bronze_tables.sql : Raw landing DDL */
USE DataWarehouse;
GO

IF OBJECT_ID('bronze.crm_customer_info') IS NOT NULL DROP TABLE bronze.crm_customer_info;
CREATE TABLE bronze.crm_customer_info (
  cid            VARCHAR(64)  NULL,
  customer_key   VARCHAR(64)  NULL,
  first_name     VARCHAR(100) NULL,
  last_name      VARCHAR(100) NULL,
  marital_status VARCHAR(20)  NULL,
  gender         VARCHAR(50)  NULL,
  create_date    DATE         NULL,
  _dw_loaded_at  DATETIME2    NOT NULL DEFAULT SYSDATETIME()
);

IF OBJECT_ID('bronze.erp_customer') IS NOT NULL DROP TABLE bronze.erp_customer;
CREATE TABLE bronze.erp_customer (
  ci_id         VARCHAR(64) NULL,
  birth_date    DATE        NULL,
  gender        VARCHAR(50) NULL,
  _dw_loaded_at DATETIME2   NOT NULL DEFAULT SYSDATETIME()
);

IF OBJECT_ID('bronze.erp_location') IS NOT NULL DROP TABLE bronze.erp_location;
CREATE TABLE bronze.erp_location (
  ci_id         VARCHAR(64)  NULL,
  country       VARCHAR(100) NULL,
  _dw_loaded_at DATETIME2    NOT NULL DEFAULT SYSDATETIME()
);

IF OBJECT_ID('bronze.crm_product_info') IS NOT NULL DROP TABLE bronze.crm_product_info;
CREATE TABLE bronze.crm_product_info (
  product_id    VARCHAR(64)   NULL,
  product_key   VARCHAR(64)   NULL,
  product_name  VARCHAR(200)  NULL,
  category_id   VARCHAR(64)   NULL,
  cost          DECIMAL(18,4) NULL,
  line          VARCHAR(50)   NULL,
  start_date    DATE          NULL,
  end_date      DATE          NULL,
  _dw_loaded_at DATETIME2     NOT NULL DEFAULT SYSDATETIME()
);

IF OBJECT_ID('bronze.erp_product_category') IS NOT NULL DROP TABLE bronze.erp_product_category;
CREATE TABLE bronze.erp_product_category (
  id            VARCHAR(64)  NULL,
  category      VARCHAR(100) NULL,
  subcategory   VARCHAR(100) NULL,
  maintenance   VARCHAR(10)  NULL,
  _dw_loaded_at DATETIME2    NOT NULL DEFAULT SYSDATETIME()
);

IF OBJECT_ID('bronze.crm_sales') IS NOT NULL DROP TABLE bronze.crm_sales;
CREATE TABLE bronze.crm_sales (
  order_number  VARCHAR(64)   NULL,
  customer_id   VARCHAR(64)   NULL,
  product_key   VARCHAR(64)   NULL,
  order_date    DATE          NULL,
  ship_date     DATE          NULL,
  due_date      DATE          NULL,
  quantity      INT           NULL,
  price         DECIMAL(18,4) NULL,
  _dw_loaded_at DATETIME2     NOT NULL DEFAULT SYSDATETIME()
);
