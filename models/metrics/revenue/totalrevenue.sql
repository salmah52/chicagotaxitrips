-- Calculate total revenue (trip_total) over time:

SELECT
    d.datetime_id,
    SUM(f.trip_total) AS total_revenue
FROM {{ref('fact_taxitrips')}} f
JOIN {{ref('dim_date')}}  d ON f.datetime_id = d.datetime_id
GROUP BY d.datetime_id
ORDER BY d.datetime_id

