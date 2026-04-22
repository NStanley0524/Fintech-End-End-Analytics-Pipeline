with source as (

    select * 
    from {{ source('raw', 'transactions') }}

),

cleaned as (

 select
        transaction_id,

        SAFE_CAST(
                     CAST(NULLIF(TRIM(sender_user_id), '') AS FLOAT64)
                    AS INT64) AS sender_user_id,
        SAFE_CAST(
                    CAST(NULLIF(TRIM(receiver_user_id), '') AS FLOAT64)
                    AS INT64) AS receiver_user_id,
                    
        external_account_id,

        cast(amount as float64) as amount,
        cast(fee as float64) as fee,

        transaction_type,
        status,
        direction,

        cast(is_internal as bool) as is_internal,

        timestamp,

        -- derived fields
        date(timestamp) as transaction_date,
        extract(hour from cast(timestamp as timestamp)) as transaction_hour

    from source

)

select * from cleaned

