with transactions as (

    select *
    from {{ ref('stg_transactions') }}

),

users as (

    select *
    from {{ ref('stg_users') }}

),

enhanced as (

    select
        t.transaction_id,

        -- define user perspective
        case
            when t.direction = 'outflow' then t.sender_user_id
            when t.direction = 'inflow' then t.receiver_user_id
        end as primary_user_id,

        t.sender_user_id,
        t.receiver_user_id,

        t.transaction_type,
        t.status,
        t.direction,
        t.is_internal,

        t.amount,
        t.fee,

        t.timestamp,
        t.transaction_date,
        t.transaction_hour

    from transactions t

),

joined as (

    select
        e.*,

        u.country,
        u.acquisition_channel

    from enhanced e
    left join users u
        on e.primary_user_id = u.user_id

)

select * from joined