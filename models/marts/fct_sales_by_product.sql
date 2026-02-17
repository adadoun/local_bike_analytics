-- Sales fact table by product
-- Grain: one row per product per order
with orders as (
    select * from {{ ref('int_orders_enriched') }}
),

order_items as (
    select * from {{ ref('int_order_items_enriched') }}
),

final as (
    select
        -- Keys
        o.order_id,
        oi.item_id,
        oi.product_id,
        
        -- Order dimensions
        o.order_date,
        o.order_year,
        o.order_month,
        o.order_quarter,
        o.order_status,
        o.order_status_name,
        
        -- Store dimensions
        o.store_id,
        o.store_name,
        o.store_state,
        
        -- Staff dimensions  
        o.staff_id,
        o.staff_full_name,
        
        -- Customer dimensions
        o.customer_id,
        o.customer_state,
        
        -- Product dimensions
        oi.product_name,
        oi.brand_id,
        oi.brand_name,
        oi.category_id,
        oi.category_name,
        oi.model_year,
        
        -- Metrics
        oi.quantity,
        oi.unit_price,
        oi.discount_percent,
        oi.line_total as revenue,
        oi.line_total_gross as revenue_gross,
        oi.discount_amount
        
    from order_items oi
    inner join orders o on oi.order_id = o.order_id
)

select * from final
