with source as (

SELECT * FROM {{ source('raw', 'users') }}

),

cleaned as (
    
    SELECT CAST(user_id AS INT64) AS user_id,
    cast(signup_date as date) as signup_date,
    country,
    acquisition_channel,
    status,

-- derived fields
extract(YEAR from cast(signup_date as date)) as signup_year,
extract(MONTH from cast(signup_date as date))  as signup_month

from source
)

SELECT * FROM cleaned