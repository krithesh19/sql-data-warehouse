
/* 03_create_gold_views.sql : Star schema (views) */
USE DataWarehouse;
GO

-- Dimension: Customers
CREATE OR ALTER VIEW gold.dim_customers AS
WITH base AS (
  SELECT
    ci.cid               AS customer_id,
    ci.customer_key      AS customer_number,
    ci.first_name,
    ci.last_name,
    loc.country,
    ci.marital_status,
    -- Integrate gender: prefer CRM if available, else ERP
    CASE
      WHEN ci.gender <> 'Not available' THEN ci.gender
      ELSE COALESCE(ec.gender,'Not available')
    END AS gender,
    ec.birth_date,
    ci.create_date
  FROM silver.crm_customer_info ci
  LEFT JOIN silver.erp_customer ec
    ON ci.customer_key = ec.ci_id
  LEFT JOIN silver.erp_location loc
    ON ci.customer_key = loc.ci_id
)
SELECT
  ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_key, -- surrogate key
  customer_id,
  customer_number,
  first_name,
  last_name,
  country,
  marital_status,
  gender,
  birth_date,
  create_date
FROM base;
GO

-- Dimension: Products (current rows only; end_date IS NULL)
CREATE OR ALTER VIEW gold.dim_products AS
WITH current_products AS (
  SELECT *
  FROM bronze.crm_product_info
  WHERE end_date IS NULL
),
joined AS (
  SELECT
    p.product_id       AS product_id,
    p.product_key      AS product_number,
    p.product_name     AS product_name,
    p.category_id      AS category_id,
    pc.category        AS category,
    pc.subcategory     AS subcategory,
    pc.maintenance     AS maintenance,
    p.cost             AS cost,
    p.line             AS line,
    p.start_date       AS start_date
  FROM current_products p
  LEFT JOIN bronze.erp_product_category pc
    ON p.category_id = pc.id
)
SELECT
  ROW_NUMBER() OVER (ORDER BY start_date, product_number) AS product_key, -- surrogate key
  product_id,
  product_number,
  product_name,
  category_id,
  category,
  subcategory,
  maintenance,
  cost,
  line,
  start_date
FROM joined;
GO

-- Fact: Sales (lookup surrogate keys from dims)
CREATE OR ALTER VIEW gold.fact_sales AS
WITH sales AS (
  SELECT
    s.order_number,
    s.customer_id,
    s.product_key AS product_number,
    s.order_date,
    s.ship_date,
    s.due_date,
    CAST(s.quantity AS INT) AS quantity,
    CAST(s.price    AS DECIMAL(18,4)) AS price,
    CAST(s.quantity AS DECIMAL(18,4)) * CAST(s.price AS DECIMAL(18,4)) AS sales_amount
  FROM bronze.crm_sales s
),
lkp AS (
  SELECT
    sa.*,
    dc.customer_key AS customer_key,
    dp.product_key  AS product_key
  FROM sales sa
  LEFT JOIN gold.dim_customers dc
    ON sa.customer_id = dc.customer_id
  LEFT JOIN gold.dim_products dp
    ON sa.product_number = dp.product_number
)
SELECT
  order_number,
  product_key,
  customer_key,
  order_date,
  ship_date,
  due_date,
  sales_amount,
  quantity,
  price
FROM lkp;
GO
