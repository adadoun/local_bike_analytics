-- Customer dimension with purchase metrics
with customers as (
    select * from {{ ref('stg_customers') }}
),

sales as (
    select * from {{ ref('fct_sales') }}
    where order_status = 4  -- Completed orders only
),

customer_metrics as (
    select
        customer_id,
        count(distinct order_id) as total_orders,
        sum(total_revenue) as lifetime_revenue,
        avg(total_revenue) as avg_order_value,
        min(order_date) as first_order_date,
        max(order_date) as last_order_date,
        count(distinct store_id) as stores_purchased_from
    from sales
    group by customer_id
),

final as (
    select
        c.customer_id,
        c.first_name,
        c.last_name,
        c.customer_full_name,
        c.phone,
        c.email,
        c.street,
        c.city,
        c.state,
        c.zip_code,
        coalesce(cm.total_orders, 0) as total_orders,
        coalesce(cm.lifetime_revenue, 0) as lifetime_revenue,
        coalesce(cm.avg_order_value, 0) as avg_order_value,
        cm.first_order_date,
        cm.last_order_date,
        coalesce(cm.stores_purchased_from, 0) as stores_purchased_from,
        case
            when cm.total_orders is null then 'No Purchase'
            when cm.total_orders = 1 then 'One-time'
            when cm.total_orders between 2 and 3 then 'Returning'
            else 'Loyal'
        end as customer_segment
    from customers c
    left join customer_metrics cm on c.customer_id = cm.customer_id
)

select * from final
