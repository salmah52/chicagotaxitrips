with dim_company as (
         SELECT
        ROW_NUMBER() OVER () AS company_id,
        company

    FROM {{ ref('stg_taxitrips') }}
)

SELECT * FROM dim_company
