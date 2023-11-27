--Revenue by month, quarter, and year
SELECT
    d.start_month,
    d.start_quarter,
    d.start_year,
    SUM(f.trip_total) AS monthly_revenue
FROM {{ref('fact_taxitrips')}} f
JOIN {{ref('dim_date')}} d ON f.datetime_id = d.datetime_id
GROUP BY d.start_month, d.start_quarter, d.start_year
ORDER BY d.start_year, d.start_quarter, d.start_month
