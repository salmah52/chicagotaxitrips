--Average trip duration

SELECT
    AVG(f.trip_seconds) AS avg_trip_duration
FROM {{ref('fact_taxitrips')}} f
