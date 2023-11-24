WITH dim_drop_off AS (
    SELECT
        ROW_NUMBER() OVER () AS drop_off_id,
        dropoff_community_area AS community_area,
        dropoff_centroid_latitude AS latitude,
        dropoff_centroid_longitude AS longitude,
        dropoff_centroid_location AS location_name,
        dropoff_census_tract AS census_tract,
        -- Generate random pick_up_id
        --ABS(FARM_FINGERPRINT(CAST(CONCAT(pickup_community_area, pickup_centroid_latitude, pickup_centroid_longitude) AS STRING))) AS pick_up_id
    FROM {{ ref('stg_taxitrips') }}
)

SELECT * FROM dim_drop_off
