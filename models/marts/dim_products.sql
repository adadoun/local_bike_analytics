-- Dimension produits avec métriques de stock
with products as (
    select * from {{ ref('int_products_enriched') }}
),

stocks as (
    select * from {{ ref('stg_stocks') }}
),

stock_agg as (
    select
        product_id,
        sum(stock_quantity) as total_stock,
        count(distinct store_id) as stores_with_stock
    from stocks
    group by product_id
),

final as (
    select
        p.product_id,
        p.product_name,
        p.brand_id,
        p.brand_name,
        p.category_id,
        p.category_name,
        p.model_year,
        p.list_price,
        coalesce(s.total_stock, 0) as total_stock,
        coalesce(s.stores_with_stock, 0) as stores_with_stock,
        case 
            when coalesce(s.total_stock, 0) = 0 then 'Out of Stock'
            when coalesce(s.total_stock, 0) < 5 then 'Low Stock'
            else 'In Stock'
        end as stock_status
    from products p
    left join stock_agg s on p.product_id = s.product_id
)

select * from final
