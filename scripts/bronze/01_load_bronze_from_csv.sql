
/* 01_load_bronze_from_csv.sql
   Edit @DataFolder to your local folder containing the CSVs.
   Requires: BULK INSERT permissions and that SQL Server can access the folder.
*/
USE DataWarehouse;
GO

DECLARE @DataFolder NVARCHAR(4000) = N'C:\DW_Source'; -- TODO: <---- change to your folder path

/* Helper: load one file */
CREATE OR ALTER PROCEDURE bronze.load_csv
  @TableName SYSNAME,
  @FileName  NVARCHAR(4000),
  @FirstRow  INT = 2,           -- skip header
  @FieldTerm CHAR(1) = ',',
  @RowTerm   VARCHAR(2) = '\n'
AS
BEGIN
  DECLARE @sql NVARCHAR(MAX) = N'
    BULK INSERT ' + QUOTENAME(@TableName) + N'
    FROM ' + QUOTENAME(CONCAT(@DataFolder, '\\', @FileName), '''') + N'
    WITH (
      FIRSTROW = ' + CAST(@FirstRow AS NVARCHAR(10)) + N',
      FIELDTERMINATOR = ' + QUOTENAME(@FieldTerm, '''') + N',
      ROWTERMINATOR = ' + QUOTENAME(@RowTerm, '''') + N',
      TABLOCK,
      CODEPAGE = ''65001''
    );';
  EXEC sp_executesql @sql, N'@DataFolder nvarchar(4000)', @DataFolder=@DataFolder;
END;
GO

/* Truncate & load all */
CREATE OR ALTER PROCEDURE bronze.load_all
AS
BEGIN
  SET NOCOUNT ON;

  PRINT 'Truncating bronze tables...';
  TRUNCATE TABLE bronze.crm_sales;
  TRUNCATE TABLE bronze.erp_product_category;
  TRUNCATE TABLE bronze.crm_product_info;
  TRUNCATE TABLE bronze.erp_location;
  TRUNCATE TABLE bronze.erp_customer;
  TRUNCATE TABLE bronze.crm_customer_info;

  PRINT 'Loading CSVs...';
  EXEC bronze.load_csv @TableName='bronze.crm_customer_info',     @FileName='crm_customer_info.csv';
  EXEC bronze.load_csv @TableName='bronze.erp_customer',          @FileName='erp_customer.csv';
  EXEC bronze.load_csv @TableName='bronze.erp_location',          @FileName='erp_location.csv';
  EXEC bronze.load_csv @TableName='bronze.crm_product_info',      @FileName='crm_product_info.csv';
  EXEC bronze.load_csv @TableName='bronze.erp_product_category',  @FileName='erp_product_category.csv';
  EXEC bronze.load_csv @TableName='bronze.crm_sales',             @FileName='crm_sales.csv';
END;
GO
