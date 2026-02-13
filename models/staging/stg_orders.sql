with source as (
    select * from {{ source('local_bike', 'orders') }}
),

renamed as (
    select
        order_id,
        customer_id,
        order_status,
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
