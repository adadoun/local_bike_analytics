# Local Bike - dbt Analytics Project

## 📖 Context

Local Bike is a US-based bicycle retail company founded by Alexander Anthony, a former professional cyclist. The company operates three stores strategically located in Santa Cruz (CA), Baldwin (NY), and Rowlett (TX), with a mission to democratize cycling across the United States.

This dbt project models Local Bike's transactional data to provide actionable insights for the operations team, enabling them to optimize sales and maximize revenue.

## 🏗️ Project Structure

```
local_bike_dbt/
├── models/
│   ├── staging/               # Data cleansing & standardization
│   │   ├── _sources.yml       # BigQuery source definitions
│   │   ├── _stg_schema.yml    # Tests & documentation
│   │   ├── stg_brands.sql
│   │   ├── stg_categories.sql
│   │   ├── stg_customers.sql
│   │   ├── stg_order_items.sql
│   │   ├── stg_orders.sql
│   │   ├── stg_products.sql
│   │   ├── stg_staffs.sql
│   │   ├── stg_stocks.sql
│   │   └── stg_stores.sql
│   ├── intermediate/          # Business logic transformations
│   │   ├── _int_schema.yml
│   │   ├── int_products_enriched.sql
│   │   ├── int_orders_enriched.sql
│   │   └── int_order_items_enriched.sql
│   └── marts/                 # Final tables for BI consumption
│       ├── _marts_schema.yml
│       ├── fct_sales.sql
│       ├── fct_sales_by_product.sql
│       ├── dim_products.sql
│       ├── dim_stores.sql
│       ├── dim_customers.sql
│       ├── agg_sales_by_store_month.sql
│       ├── agg_sales_by_category.sql
│       ├── agg_sales_by_brand.sql
│       └── agg_staff_performance.sql
├── profiles.yml
└── dbt_project.yml
```

## 📊 Data Architecture

### Source Data (BigQuery: `local_bike` dataset)
| Table | Description | Rows |
|-------|-------------|------|
| brands | Bike brand reference | 9 |
| categories | Product categories | 7 |
| products | Product catalog | 321 |
| stores | Store locations | 3 |
| staffs | Store employees | 10 |
| customers | Customer data | 1,445 |
| orders | Order headers | 1,615 |
| order_items | Order line items | 4,722 |
| stocks | Inventory levels | 939 |

### Marts Layer (BI-ready)

| Model | Description | Grain |
|-------|-------------|-------|
| `fct_sales` | Main sales fact table | One row per order |
| `fct_sales_by_product` | Sales with product details | One row per order line item |
| `dim_products` | Product dimension with stock info | One row per product |
| `dim_stores` | Store dimension with staff/inventory counts | One row per store |
| `dim_customers` | Customer dimension with purchase metrics | One row per customer |
| `agg_sales_by_store_month` | Monthly sales by store | One row per store per month |
| `agg_sales_by_category` | Yearly sales by category | One row per category per year |
| `agg_sales_by_brand` | Yearly sales by brand | One row per brand per year |
| `agg_staff_performance` | Staff performance metrics | One row per staff per year |

## 🚀 Getting Started

### Prerequisites
- dbt Core 1.0+ (`pip install dbt-bigquery`)
- Google Cloud SDK (gcloud CLI)
- Access to the BigQuery project with `local_bike` dataset

### Setup

1. **Clone this repository**
```bash
git clone https://github.com/your-username/local_bike_dbt.git
cd local_bike_dbt
```

2. **Authenticate with Google Cloud**
```bash
gcloud auth application-default login
```

3. **Set environment variable**
```bash
export DBT_PROJECT_ID='your-gcp-project-id'
```

4. **Verify connection**
```bash
dbt debug
```

5. **Run the models**
```bash
# Run all models
dbt run

# Run only staging
dbt run --select staging.*

# Run marts and all upstream dependencies
dbt run --select +marts.*
```

6. **Run tests**
```bash
dbt test
```

7. **Generate documentation**
```bash
dbt docs generate
dbt docs serve
```

## 📁 Output Datasets

After running dbt, the following BigQuery datasets will be created:
- `local_bike_dbt_dev_staging` - Staging views
- `local_bike_dbt_dev_intermediate` - Intermediate views
- `local_bike_dbt_dev_marts` - Mart tables (materialized)

## 🎯 Key Business Questions Addressed

1. **Sales Performance**: Revenue trends, average order value, store comparison
2. **Product Analysis**: Top categories/brands, stock levels, discount analysis
3. **Customer Insights**: Geographic distribution, retention, lifetime value
4. **Staff Performance**: Revenue per employee, order processing efficiency

## 📈 Suggested Dashboards

Connect your BI tool (Metabase, Looker, Power BI) to the marts tables:
- **Executive Dashboard**: KPIs, revenue trends, store performance
- **Operations Dashboard**: Order status, shipping times, stock alerts
- **Product Dashboard**: Category/brand analysis, inventory management

## 👥 Author

Analytics Engineer - DataBird Case Study

## 📝 License

This project is for educational purposes as part of the DataBird Analytics Engineering certification.
