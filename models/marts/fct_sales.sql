-- Table de faits principale des ventes
-- Grain: une ligne par commande
with orders as (
    select * from {{ ref('int_orders_enriched') }}
),

order_items as (
    select * from {{ ref('int_order_items_enriched') }}
),

order_metrics as (
    select
        order_id,
        count(distinct item_id) as total_items,
        sum(quantity) as total_quantity,
        sum(line_total) as total_revenue,
        sum(line_total_gross) as total_revenue_gross,
        sum(discount_amount) as total_discount
    from order_items
    group by order_id
),

final as (
    select
        o.order_id,
        o.order_date,
        o.required_date,
        o.shipped_date,
        o.order_status,
        o.order_status_name,
        
        -- Customer dimensions
        o.customer_id,
        o.customer_full_name,
        o.customer_city,
        o.customer_state,
        
        -- Store dimensions
        o.store_id,
        o.store_name,
        o.store_city,
        o.store_state,
        
        -- Staff dimensions
        o.staff_id,
        o.staff_full_name,
        
        -- Time dimensions
        o.order_year,
        o.order_month,
        o.order_quarter,
        
        -- Metrics
        om.total_items,
        om.total_quantity,
        om.total_revenue,
        om.total_revenue_gross,
        om.total_discount,
        o.days_to_ship,
        
        -- Calculated fields
        case 
            when om.total_revenue_gross > 0 
            then round(om.total_discount / om.total_revenue_gross * 100, 2)
            else 0 
        end as discount_rate_pct
        
    from orders o
    left join order_metrics om on o.order_id = om.order_id
)

select * from final
