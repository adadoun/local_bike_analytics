with source as (
    select * from {{ source('local_bike', 'orders') }}
),

renamed as (
    select
        order_id,
        customer_id,
        order_status,
        -- order_status mapping is an assumption based on common e-commerce patterns
        -- (1=Pending, 2=Processing, 3=Rejected, 4=Completed)
        -- Observation: 89% of orders have status=4, suggesting it represents 
        -- a final/completed state
        case order_status
            when 1 then 'Pending'
            when 2 then 'Processing'
            when 3 then 'Rejected'
            when 4 then 'Completed'
            else 'Unknown'
        end as order_status_name,
        cast(order_date as date) as order_date,
        cast(required_date as date) as required_date,
        case 
            when shipped_date is null or cast(shipped_date as string) = 'NULL' then null 
            else cast(shipped_date as date) 
        end as shipped_date,
        store_id,
        staff_id
    from source
)

select * from renamed
