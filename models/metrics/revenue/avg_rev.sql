--Average revenue per trip
SELECT
    AVG(f.trip_total) AS avg_revenue_per_trip
FROM {{ref('fact_taxitrips')}} f
