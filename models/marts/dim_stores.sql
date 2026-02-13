-- Dimension magasins avec métriques
with stores as (
    select * from {{ ref('stg_stores') }}
),

staffs as (
    select * from {{ ref('stg_staffs') }}
),

stocks as (
    select * from {{ ref('stg_stocks') }}
),

staff_count as (
    select
        store_id,
        count(*) as total_staff,
        sum(case when is_active then 1 else 0 end) as active_staff
    from staffs
    group by store_id
),

stock_value as (
    select
        st.store_id,
        sum(st.stock_quantity) as total_units_in_stock,
        count(distinct st.product_id) as unique_products_in_stock
    from stocks st
    group by st.store_id
),

final as (
    select
        s.store_id,
        s.store_name,
        s.store_phone,
        s.store_email,
        s.store_street,
        s.store_city,
        s.store_state,
        s.store_zip_code,
        coalesce(sc.total_staff, 0) as total_staff,
        coalesce(sc.active_staff, 0) as active_staff,
        coalesce(sv.total_units_in_stock, 0) as total_units_in_stock,
        coalesce(sv.unique_products_in_stock, 0) as unique_products_in_stock
    from stores s
    left join staff_count sc on s.store_id = sc.store_id
    left join stock_value sv on s.store_id = sv.store_id
)

select * from final
