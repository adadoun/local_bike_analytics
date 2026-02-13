-- Lignes de commandes enrichies avec informations produit
with order_items as (
    select * from {{ ref('stg_order_items') }}
),

products as (
    select * from {{ ref('int_products_enriched') }}
),

enriched as (
    select
        oi.order_id,
        oi.item_id,
        oi.product_id,
        p.product_name,
        p.brand_id,
        p.brand_name,
        p.category_id,
        p.category_name,
        p.model_year,
        oi.quantity,
        oi.unit_price,
        p.list_price as catalog_price,
        oi.discount_percent,
        oi.line_total,
        oi.line_total_gross,
        oi.discount_amount
    from order_items oi
    left join products p on oi.product_id = p.product_id
)

select * from enriched
