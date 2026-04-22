with loans as (

    select *
    from {{ ref('stg_loans') }}

),

repayments as (

    select *
    from {{ ref('stg_repayments') }}

),

repayment_agg as (

    select
        loan_id,

        count(*) as num_repayments,

        sum(amount) as total_repaid,

        max(repayment_date) as last_repayment_date

    from repayments
    group by loan_id

),

joined as (

    select
        l.loan_id,
        l.user_id,

        l.loan_amount,
        l.interest_rate,
        l.status,

        l.issued_date,
        l.due_date,

        r.num_repayments,
        round(coalesce(r.total_repaid, 0),2) as total_repaid,
        r.last_repayment_date

    from loans l
    left join repayment_agg r
        on l.loan_id = r.loan_id

),

final as (

    select
        *,

        -- repayment ratio (how much has been paid back)
        CAST(safe_divide(total_repaid, loan_amount) as float64) as repayment_ratio,

        -- remaining balance
        round(loan_amount - total_repaid, 2) as outstanding_balance,

        -- loan duration
        date_diff(due_date, issued_date, day) as loan_duration_days,

        -- repayment delay (if any)
        case
            when last_repayment_date is not null
            then date_diff(last_repayment_date, due_date, day)
        end as days_past_due

    from joined

)

select * from final