-- Staff sales performance
with sales as (
    select * from {{ ref('fct_sales') }}
    where order_status = 4  -- Completed orders only
),

staffs as (
    select * from {{ ref('stg_staffs') }}
),

stores as (
    select * from {{ ref('stg_stores') }}
),

staff_metrics as (
    select
        staff_id,
        order_year,
        
        -- Volume metrics
        count(distinct order_id) as total_orders,
        count(distinct customer_id) as unique_customers,
        
        -- Revenue metrics
        sum(total_revenue) as total_revenue,
        avg(total_revenue) as avg_order_value,
        
        -- Efficiency metrics
        avg(days_to_ship) as avg_days_to_ship
        
    from sales
    group by staff_id, order_year
),

final as (
    select
        sm.staff_id,
        s.staff_full_name,
        s.is_active,
        s.store_id,
        st.store_name,
        sm.order_year,
        sm.total_orders,
        sm.unique_customers,
        sm.total_revenue,
        sm.avg_order_value,
        sm.avg_days_to_ship
    from staff_metrics sm
    left join staffs s on sm.staff_id = s.staff_id
    left join stores st on s.store_id = st.store_id
)

select * from final
order by order_year, total_revenue desc
