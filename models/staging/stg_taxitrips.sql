-- models/staging/stg_taxitrips.sql

WITH stg_taxitrips AS (
    SELECT
        trip_id,
        taxi_id,
        trip_start_timestamp,
        trip_end_timestamp,
        trip_seconds,
        trip_miles,
        pickup_community_area,
        dropoff_community_area,
        fare,
        tips,
        tolls,
        extras,
        trip_total,
        payment_type,
        company,
        pickup_centroid_latitude,
        pickup_centroid_longitude,
        pickup_centroid_location,
        dropoff_centroid_latitude,
        dropoff_centroid_longitude,
        dropoff_centroid_location,
        pickup_census_tract,
        dropoff_census_tract
    FROM {{ source('maintaxitrips009', 'raw_data_table') }}
)

{{ config(
    materialized='table',
    unique_key='trip_id'
) }}

SELECT
    *
FROM stg_taxitrips
