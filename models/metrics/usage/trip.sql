--Total number of trips:

SELECT
    COUNT(*) AS total_trips
FROM {{ref('fact_taxitrips')}}
