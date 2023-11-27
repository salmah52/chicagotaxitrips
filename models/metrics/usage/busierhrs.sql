--Busiest hours, days, and months:

SELECT
    d.start_hour,
    d.start_day,
    d.start_month,
    COUNT(*) AS trips_count
FROM {{ref('fact_taxitrips')}} f
JOIN {{ref('dim_date')}} d ON f.datetime_id = d.datetime_id
GROUP BY d.start_hour, d.start_day, d.start_month
ORDER BY trips_count DESC
LIMIT 10
