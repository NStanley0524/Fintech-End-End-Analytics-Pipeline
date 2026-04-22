with source as (

select * from {{ source('raw', 'loans')}}

),

cleaned as (
    SELECT loan_id,
    cast(user_id as int64) as user_id,
    cast(loan_amount as FLOAT64) as loan_amount,
    cast(interest_rate as FLOAT64) as interest_rate,

    cast(issued_date as date) as issued_date,
    cast(due_date as date) as due_date,

    status,

    disbursement_transaction_id,
    date_diff(cast(due_date as date),
              cast(issued_date as date),
              DAY) as loan_duration_days

    from source
)

SELECT * FROM cleaned where status = 'active'

