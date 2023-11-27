--Number of trips by hour, day, month, and year:
SELECT
    d.start_hour,
    d.start_day,
    d.start_month,
    d.start_year,
    COUNT(*) AS trips_count
FROM {{ref('fact_taxitrips')}} f
JOIN {{ref('dim_date')}} d ON f.datetime_id = d.datetime_id
GROUP BY d.start_hour, d.start_day, d.start_month, d.start_year
ORDER BY d.start_year, d.start_month, d.start_day, d.start_hour
