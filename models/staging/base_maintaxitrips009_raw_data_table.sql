with source as (
      select * from {{ source('maintaxitrips009', 'raw_data_table') }}
),
renamed as (
    select
        {{ adapter.quote("trip_id") }},
        {{ adapter.quote("taxi_id") }},
        {{ adapter.quote("trip_start_timestamp") }},
        {{ adapter.quote("trip_end_timestamp") }},
        {{ adapter.quote("trip_seconds") }},
        {{ adapter.quote("trip_miles") }},
        {{ adapter.quote("pickup_community_area") }},
        {{ adapter.quote("dropoff_community_area") }},
        {{ adapter.quote("fare") }},
        {{ adapter.quote("tips") }},
        {{ adapter.quote("tolls") }},
        {{ adapter.quote("extras") }},
        {{ adapter.quote("trip_total") }},
        {{ adapter.quote("payment_type") }},
        {{ adapter.quote("company") }},
        {{ adapter.quote("pickup_centroid_latitude") }},
        {{ adapter.quote("pickup_centroid_longitude") }},
        {{ adapter.quote("pickup_centroid_location") }},
        {{ adapter.quote("dropoff_centroid_latitude") }},
        {{ adapter.quote("dropoff_centroid_longitude") }},
        {{ adapter.quote("dropoff_centroid_location") }},
        {{ adapter.quote("pickup_census_tract") }},
        {{ adapter.quote("dropoff_census_tract") }}

    from source
)
select * from renamed
  