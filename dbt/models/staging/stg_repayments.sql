with source as (

SELECT * 
from {{ source('raw', 'repayments') }}
),

cleaned as (
    
 SELECT 
    repayment_id,
    loan_id,
    cast(amount_paid as FLOAT64) as amount,

    safe_cast(repayment_date as date) as repayment_date,

    -- derived fields
    extract(YEAR from safe_cast(repayment_date as date)) as repayment_year,
    extract(MONTH from safe_cast(repayment_date as date)) as repayment_month

from source

)

SELECT * FROM cleaned