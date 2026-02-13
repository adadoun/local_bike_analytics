with source as (
    select * from {{ source('local_bike', 'staffs') }}
),

renamed as (
    select
        staff_id,
        first_name,
        last_name,
        concat(first_name, ' ', last_name) as staff_full_name,
        email as staff_email,
        phone as staff_phone,
        case when active = 1 then true else false end as is_active,
        store_id,
        cast(nullif(manager_id, 'NULL') as int64) as manager_id
    from source
)

select * from renamed
