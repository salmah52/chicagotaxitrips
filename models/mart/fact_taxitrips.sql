WITH fact_taxitrips AS (
    SELECT
        trip_id,
        taxi_id,
        fare,
        tips,
        trip_seconds,
        trip_miles,
        tolls,
        extras,
        trip_total,
        company,
        ROW_NUMBER() OVER () AS t_id
    FROM {{ ref('stg_taxitrips') }}
)

SELECT 
    f.trip_id as trip_id,
    f.taxi_id as taxi_id,
    f.fare as fare,
    f.tips as tips,
    f.trip_seconds as trip_seconds,
    f.trip_miles as trip_miles,
    f.tolls as tolls,
    f.extras as extras,
    f.trip_total as trip_total,
    f.company as company,
    d.datetime_id as datetime_id,
    p.pick_up_id as pick_up_id,
    dd.drop_off_id as drop_off_id,
    pm.payment_id as payment_id
FROM fact_taxitrips f
JOIN {{ ref('dim_date') }} d ON f.t_id = d.datetime_id
LEFT JOIN {{ ref('dim_pick_up') }} p ON f.t_id = p.pick_up_id -- Assuming pick_up_id is the correct foreign key
LEFT JOIN {{ ref('dim_drop_off') }} dd ON f.t_id = dd.drop_off_id -- Assuming drop_off_id is the correct foreign key
LEFT JOIN {{ ref('dim_payment') }} pm ON f.t_id = pm.payment_id -- Assuming payment_id is the correct foreign key
