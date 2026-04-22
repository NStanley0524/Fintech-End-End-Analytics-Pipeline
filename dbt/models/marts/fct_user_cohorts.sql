with users as (

    select
        user_id,
        signup_date,
        date_trunc(signup_date, month) as cohort_month
    from {{ ref('dim_users') }}

),

transactions as (

    select
        primary_user_id as user_id,
        transaction_date
    from {{ ref('facts_transactions') }}
    where status = 'success'

),

user_activity as (

    select
        u.user_id,
        u.cohort_month,

        date_diff(
            date_trunc(t.transaction_date, month),
            u.cohort_month,
            month
        ) as months_since_signup

    from users u
    join transactions t
        on u.user_id = t.user_id

),

aggregated as (

    select
        cohort_month,
        months_since_signup,

        count(distinct user_id) as active_users

    from user_activity
    where months_since_signup >= 0
    group by cohort_month, months_since_signup

)

select * from aggregated