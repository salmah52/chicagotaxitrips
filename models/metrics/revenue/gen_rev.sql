--Top revenue-generating taxis or companies:
SELECT
    f.company,
    SUM(f.trip_total) AS total_revenue
FROM {{ref('fact_taxitrips')}} f
GROUP BY f.company
ORDER BY total_revenue DESC
LIMIT 10
