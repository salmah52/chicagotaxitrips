SELECT
    SUM(f.trip_miles) AS total_distance_covered
FROM {{ref('fact_taxitrips')}} f
