-- Sales aggregation by store and month
-- For time series trend charts
with sales as (
    select * from {{ ref('fct_sales') }}
    where order_status = 4  -- Completed orders only
),

final as (
    select
        store_id,
        store_name,
        store_state,
        order_year,
        order_month,
        date(order_year, order_month, 1) as month_date,
        
        -- Order metrics
        count(distinct order_id) as total_orders,
        count(distinct customer_id) as unique_customers,
        
        -- Revenue metrics
        sum(total_revenue) as total_revenue,
        sum(total_revenue_gross) as total_revenue_gross,
        sum(total_discount) as total_discount,
        
        -- Average metrics
        avg(total_revenue) as avg_order_value,
        avg(total_quantity) as avg_items_per_order,
        avg(days_to_ship) as avg_days_to_ship
        
    from sales
    group by 
        store_id,
        store_name,
        store_state,
        order_year,
        order_month
)

select * from final
order by store_id, order_year, order_month
