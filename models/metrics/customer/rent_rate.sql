--Customer retention rate

SELECT
    COUNT(DISTINCT f.taxi_id) AS returning_customers,
    COUNT(DISTINCT f.trip_id) AS total_trips,
    (COUNT(DISTINCT f.taxi_id) / COUNT(DISTINCT f.trip_id)) * 100 AS retention_rate
FROM {{ref('fact_taxitrips')}} f
