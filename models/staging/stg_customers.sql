with source as (
    select * from {{ source('local_bike', 'customers') }}
),

renamed as (
    select
        customer_id,
        first_name,
        last_name,
        concat(first_name, ' ', last_name) as customer_full_name,
        nullif(phone, 'NULL') as phone,
        email,
        street,
        city,
        state,
        zip_code
    from source
)

select * from renamed
