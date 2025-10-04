
/* 00_create_database_and_schemas.sql */
IF DB_ID('DataWarehouse') IS NULL
BEGIN
  PRINT('Creating database DataWarehouse...');
  CREATE DATABASE DataWarehouse;
END
GO

USE DataWarehouse;
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name='bronze') EXEC('CREATE SCHEMA bronze');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name='silver') EXEC('CREATE SCHEMA silver');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name='gold')   EXEC('CREATE SCHEMA gold');
GO
