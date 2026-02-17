-- Sales aggregation by product category
with sales as (
    select * from {{ ref('fct_sales_by_product') }}
    where order_status = 4  -- Completed orders only
),

final as (
    select
        category_id,
        category_name,
        order_year,
        
        -- Volume metrics
        count(distinct order_id) as total_orders,
        sum(quantity) as total_units_sold,
        count(distinct product_id) as unique_products_sold,
        
        -- Revenue metrics
        sum(revenue) as total_revenue,
        sum(revenue_gross) as total_revenue_gross,
        sum(discount_amount) as total_discount,
        
        -- Average metrics
        avg(unit_price) as avg_selling_price,
        avg(discount_percent) as avg_discount_rate
        
    from sales
    group by 
        category_id,
        category_name,
        order_year
)

select * from final
order by order_year, total_revenue desc
