WITH dim_pick_up AS (
    SELECT
        ROW_NUMBER() OVER () AS pick_up_id,
        pickup_community_area AS community_area,
        pickup_centroid_latitude AS latitude,
        pickup_centroid_longitude AS longitude,
        pickup_centroid_location AS location_name,
        pickup_census_tract AS census_tract,
        -- Generate random pick_up_id
        --ABS(FARM_FINGERPRINT(CAST(CONCAT(pickup_community_area, pickup_centroid_latitude, pickup_centroid_longitude) AS STRING))) AS pick_up_id
    FROM {{ ref('stg_taxitrips') }}
)

SELECT * FROM dim_pick_up
