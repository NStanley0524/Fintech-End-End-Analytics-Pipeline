with transactions as (

    select *
    from {{ ref('facts_transactions') }}

),

aggregated as (

    select
        acquisition_channel,

        count(*) as total_transactions,

        count(distinct primary_user_id) as active_users,

        round(sum(amount), 2) as total_gmv,

        round(sum(fee), 2) as total_revenue,

        round(sum(case when direction = 'inflow' then amount else 0 end), 2) as total_inflow,

        round(sum(case when direction = 'outflow' then amount else 0 end), 2) as total_outflow

    from transactions
    where status = 'success'
    group by acquisition_channel

)

select * from aggregated