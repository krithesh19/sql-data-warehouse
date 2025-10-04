
# Mini Data Warehouse (SQL Server) — Bronze / Silver / Gold

This repo contains a complete, self‑contained example of a small Data Warehouse implemented on **SQL Server** using the **Bronze / Silver / Gold** pattern.

## Contents
```
scripts/
  bronze/
  silver/
  gold/
tests/
docs/
```
- **bronze** – Raw landing tables + optional bulk‑load proc (from CSV).
- **silver** – Cleaned, standardized tables + load proc with transformations.
- **gold** – Business‑ready star schema (views): `dim_customers`, `dim_products`, `fact_sales`.
- **tests** – Simple quality checks for each layer.
- **docs** – Data flow, model diagram notes, and data catalog (markdown).

## Quick Start

1. Open **SQL Server Management Studio (SSMS)** and connect to your instance.
2. Execute `scripts/00_create_database_and_schemas.sql`.
3. (Optional) Load CSVs into **bronze** tables. You can either:
   - use SSMS **Tasks → Import Flat File** (map each CSV to its matching table), or
   - edit file locations in `scripts/bronze/01_load_bronze_from_csv.sql` and run it.
4. Run `scripts/silver/02_load_silver.sql` to build/refresh the **silver** layer.
5. Run `scripts/gold/03_create_gold_views.sql` to build the **gold** layer.
6. Run checks in `/tests` to validate the result.

### CSV → Table mapping

| CSV name                   | Bronze table                     |
|---------------------------|----------------------------------|
| `crm_customer_info.csv`   | `bronze.crm_customer_info`       |
| `erp_customer.csv`        | `bronze.erp_customer`            |
| `erp_location.csv`        | `bronze.erp_location`            |
| `crm_product_info.csv`    | `bronze.crm_product_info`        |
| `erp_product_category.csv`| `bronze.erp_product_category`    |
| `crm_sales.csv`           | `bronze.crm_sales`               |

> **Tip**: Run the test queries in `/tests` after each layer refresh.

## Conventions
- Schemas: `bronze`, `silver`, `gold`
- Snake_case column names in **gold** (business-friendly).
- Surrogate keys generated with `ROW_NUMBER()` inside **gold** dimensions.

## License
MIT
