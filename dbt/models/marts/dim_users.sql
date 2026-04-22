with users as (

    select *
    from {{ ref('stg_users') }}

),

transactions as (

    select *
    from {{ ref('facts_transactions') }}

),

aggregated as (

    select
        primary_user_id as user_id,

        count(*) as total_transactions,

        round(sum(case when direction = 'inflow' then amount else 0 end), 2) as total_inflow,

        round(sum(case when direction = 'outflow' then amount else 0 end), 2) as total_outflow,

        round(sum(fee), 2) as total_fees,

        max(transaction_date) as last_transaction_date

    from transactions
    where status = 'success'
    group by primary_user_id

),

final as (

    select
        u.user_id,

        u.signup_date,
        u.country,
        u.acquisition_channel,
        u.status,

        -- metrics (coalesce to avoid nulls)
        coalesce(a.total_transactions, 0) as total_transactions,
        coalesce(a.total_inflow, 0) as total_inflow,
        coalesce(a.total_outflow, 0) as total_outflow,
        coalesce(a.total_fees, 0) as total_fees,

        a.last_transaction_date

    from users u
    left join aggregated a
        on u.user_id = a.user_id

)

select * from final