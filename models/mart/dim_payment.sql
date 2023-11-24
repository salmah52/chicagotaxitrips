with dim_payment as (
         SELECT
        ROW_NUMBER() OVER () AS payment_id,
        payment_type

    FROM {{ ref('stg_taxitrips') }}
)

SELECT * FROM dim_payment
