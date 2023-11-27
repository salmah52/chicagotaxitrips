WITH fact_taxitrips AS (
    SELECT
        trip_id,
        taxi_id,
        CAST(FLOOR(CAST(REGEXP_REPLACE(fare, r'[$,]', '') AS FLOAT64)) AS INTEGER) AS fare,
        CAST(FLOOR(CAST(REGEXP_REPLACE(tips, r'[$,]', '') AS FLOAT64)) AS INTEGER) AS tips,
        CAST(FLOOR(CAST(REGEXP_REPLACE(tolls, r'[$,]', '') AS FLOAT64)) AS INTEGER) AS tolls,
        CAST(FLOOR(CAST(REGEXP_REPLACE(extras, r'[$,]', '') AS FLOAT64)) AS INTEGER) AS extras,
        CAST(FLOOR(CAST(REGEXP_REPLACE(trip_total, r'[$,]', '') AS FLOAT64)) AS INTEGER) AS trip_total,
        CAST(FLOOR(CAST(trip_seconds AS FLOAT64)) AS INTEGER) AS trip_seconds,
        CAST(FLOOR(CAST(trip_miles AS FLOAT64)) AS INTEGER) AS trip_miles,
        
        
        ROW_NUMBER() OVER () AS t_id
    FROM 
    {{ ref('stg_taxitrips') }}
)

SELECT 
    f.trip_id as trip_id,
    f.taxi_id as taxi_id,
    f.fare as fare,
    f.tips as tips,
    f.tolls as tolls,
    f.extras as extras,
    f.trip_total as trip_total,
    f.trip_seconds,
    f.trip_miles,
    d.datetime_id as datetime_id,
    p.pick_up_id as pick_up_id,
    dd.drop_off_id as drop_off_id,
    pm.payment_id as payment_id
FROM fact_taxitrips f
JOIN {{ ref('dim_date') }} d ON f.t_id = d.datetime_id
INNER JOIN {{ ref('dim_pick_up') }} p ON f.t_id = p.pick_up_id -- Assuming pick_up_id is the correct foreign key
INNER JOIN {{ ref('dim_drop_off') }} dd ON f.t_id = dd.drop_off_id -- Assuming drop_off_id is the correct foreign key
INNER JOIN {{ ref('dim_payment') }} pm ON f.t_id = pm.payment_id --