with source as (
    select * from {{ source('local_bike', 'order_items') }}
),

renamed as (
    select
        order_id,
        item_id,
        product_id,
        quantity,
        cast(list_price as numeric) as unit_price,
        cast(discount as numeric) as discount_percent,
        -- Calcul du revenu net (après remise)
        round(cast(quantity as numeric) * cast(list_price as numeric) * (1 - cast(discount as numeric)), 2) as line_total,
        -- Calcul du revenu brut (avant remise)
        round(cast(quantity as numeric) * cast(list_price as numeric), 2) as line_total_gross,
        -- Montant de la remise
        round(cast(quantity as numeric) * cast(list_price as numeric) * cast(discount as numeric), 2) as discount_amount
    from source
)

select * from renamed
