
# Data Model (Star Schema)

**Fact**: `gold.fact_sales`  
**Dimensions**: `gold.dim_customers`, `gold.dim_products`

Relationships:  
- `fact_sales.customer_key` → `dim_customers.customer_key` (many‑to‑one)  
- `fact_sales.product_key`  → `dim_products.product_key`  (many‑to‑one)

Surrogate keys generated with `ROW_NUMBER()` in dimension views.
