
# Data Catalog (Gold Layer)

## gold.dim_customers
| Column           | Type         | Description                                  | Examples                  |
|------------------|--------------|----------------------------------------------|---------------------------|
| customer_key     | INT (SK)     | Surrogate key                                | 1, 2, 3                   |
| customer_id      | VARCHAR(64)  | Source CID (cleaned: remove 'NAS' prefix)    | `C12345`                  |
| customer_number  | VARCHAR(64)  | Business number                              | `AB123`                   |
| first_name       | VARCHAR(100) | First name                                   | `Alice`                   |
| last_name        | VARCHAR(100) | Last name                                    | `Brown`                   |
| country          | VARCHAR(100) | Country (normalized)                         | `Germany`, `United States`|
| marital_status   | VARCHAR(20)  | Marital status (as received)                 | `Single`, `Married`       |
| gender           | VARCHAR(50)  | `Male` / `Female` / `Not available`          |                           |
| birth_date       | DATE         | Birth date (future dates set to NULL)        | `1987-05-01`              |
| create_date      | DATE         | CRM create date                              |                           |

## gold.dim_products
| Column          | Type             | Description                              |
|-----------------|------------------|------------------------------------------|
| product_key     | INT (SK)         | Surrogate key                            |
| product_id      | VARCHAR(64)      | Source id                                |
| product_number  | VARCHAR(64)      | Business key                             |
| product_name    | VARCHAR(200)     | Name                                     |
| category_id     | VARCHAR(64)      | FK to ERP category raw                   |
| category        | VARCHAR(100)     | Category (normalized)                    |
| subcategory     | VARCHAR(100)     | Subcategory                              |
| maintenance     | VARCHAR(10)      | `Yes` / `No`                             |
| cost            | DECIMAL(18,4)    | Cost                                     |
| line            | VARCHAR(50)      | Product line                             |
| start_date      | DATE             | Current row start date                   |

## gold.fact_sales
| Column        | Type           | Description                                |
|---------------|----------------|--------------------------------------------|
| order_number  | VARCHAR(64)    | Business transaction id                    |
| product_key   | INT (FK)       | FK -> dim_products                         |
| customer_key  | INT (FK)       | FK -> dim_customers                        |
| order_date    | DATE           | Order date                                 |
| ship_date     | DATE           | Ship date                                  |
| due_date      | DATE           | Due date                                   |
| sales_amount  | DECIMAL(18,4)  | `quantity * price`                         |
| quantity      | INT            | Quantity                                   |
| price         | DECIMAL(18,4)  | Unit price                                 |
