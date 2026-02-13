-- Commandes enrichies avec informations client, magasin et vendeur
with orders as (
    select * from {{ ref('stg_orders') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

stores as (
    select * from {{ ref('stg_stores') }}
),

staffs as (
    select * from {{ ref('stg_staffs') }}
),

enriched as (
    select
        o.order_id,
        o.order_date,
        o.required_date,
        o.shipped_date,
        o.order_status,
        o.order_status_name,
        
        -- Customer info
        o.customer_id,
        c.customer_full_name,
        c.city as customer_city,
        c.state as customer_state,
        
        -- Store info
        o.store_id,
        s.store_name,
        s.store_city,
        s.store_state,
        
        -- Staff info
        o.staff_id,
        st.staff_full_name,
        
        -- Time dimensions
        extract(year from o.order_date) as order_year,
        extract(month from o.order_date) as order_month,
        extract(quarter from o.order_date) as order_quarter,
        
        -- Delivery metrics
        case 
            when o.shipped_date is not null 
            then date_diff(o.shipped_date, o.order_date, day)
            else null 
        end as days_to_ship
        
    from orders o
    left join customers c on o.customer_id = c.customer_id
    left join stores s on o.store_id = s.store_id
    left join staffs st on o.staff_id = st.staff_id
)

select * from enriched
