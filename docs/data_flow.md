
# Data Flow / Lineage

```
CSV files
   │
   ▼
BRONZE (raw landing tables)
   │  Clean / standardize / validate
   ▼
SILVER (conformed tables)
   │  Integrate + business rules + history choice
   ▼
GOLD (star schema views)
  - gold.dim_customers
  - gold.dim_products
  - gold.fact_sales
```
