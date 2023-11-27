--Number of unique customers

SELECT
    COUNT(DISTINCT f.taxi_id) AS unique_customers
FROM {{ref('fact_taxitrips')}} f
