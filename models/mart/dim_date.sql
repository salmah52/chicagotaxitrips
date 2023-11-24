WITH dim_date AS (
    SELECT
        trip_start_timestamp AS start_trip,
        trip_end_timestamp AS end_trip,
        EXTRACT(HOUR FROM trip_start_timestamp) AS start_hour,
        EXTRACT(DAY FROM trip_start_timestamp) AS start_day,
        EXTRACT(MONTH FROM trip_start_timestamp) AS start_month,
        EXTRACT(YEAR FROM trip_start_timestamp) AS start_year,
        CASE WHEN EXTRACT(DAYOFWEEK FROM trip_start_timestamp) IN (1, 7) THEN 'Weekend' ELSE 'Weekday' END AS start_weekend,
        EXTRACT(QUARTER FROM trip_start_timestamp) AS start_quarter,
        CASE 
            WHEN EXTRACT(MONTH FROM trip_start_timestamp) IN (12, 1, 2) THEN 'Winter'
            WHEN EXTRACT(MONTH FROM trip_start_timestamp) IN (3, 4, 5) THEN 'Spring'
            WHEN EXTRACT(MONTH FROM trip_start_timestamp) IN (6, 7, 8) THEN 'Summer'
            WHEN EXTRACT(MONTH FROM trip_start_timestamp) IN (9, 10, 11) THEN 'Fall'
        END AS start_season,
        EXTRACT(HOUR FROM trip_end_timestamp) AS end_hour,
        EXTRACT(DAY FROM trip_end_timestamp) AS end_day,
        EXTRACT(MONTH FROM trip_end_timestamp) AS end_month,
        EXTRACT(YEAR FROM trip_end_timestamp) AS end_year,
        CASE WHEN EXTRACT(DAYOFWEEK FROM trip_end_timestamp) IN (1, 7) THEN 'Weekend' ELSE 'Weekday' END AS end_weekend,
        EXTRACT(QUARTER FROM trip_end_timestamp) AS end_quarter,
        CASE 
            WHEN EXTRACT(MONTH FROM trip_end_timestamp) IN (12, 1, 2) THEN 'Winter'
            WHEN EXTRACT(MONTH FROM trip_end_timestamp) IN (3, 4, 5) THEN 'Spring'
            WHEN EXTRACT(MONTH FROM trip_end_timestamp) IN (6, 7, 8) THEN 'Summer'
            WHEN EXTRACT(MONTH FROM trip_end_timestamp) IN (9, 10, 11) THEN 'Fall'
        END AS end_season
    FROM {{ ref('stg_taxitrips') }}
)

SELECT
    ROW_NUMBER() OVER () AS datetime_id,
    start_trip,
    end_trip,
    start_hour,
    start_day,
    start_month,
    start_year,
    start_weekend,
    start_quarter,
    start_season,
    end_hour,
    end_day,
    end_month,
    end_year,
    end_weekend,
    end_quarter,
    end_season
FROM dim_date
