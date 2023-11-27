--Average trips per customer:

SELECT
    COUNT(*) / COUNT(DISTINCT f.taxi_id) AS avg_trips_per_customer
FROM {{ref('fact_taxitrips')}} f
