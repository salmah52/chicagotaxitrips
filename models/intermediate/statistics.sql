-- Display the summary statistics of the numerical columns in the DataFrame
SELECT COUNT(*) AS num_trips, 
       ROUND(AVG(trip_seconds),2) AS avg_trip_seconds, 
       ROUND(AVG(trip_miles),2) AS avg_trip_miles, 
       ROUND(AVG(fare),2) AS avg_fare, 
       ROUND(AVG(tips),2) AS avg_tips,
       ROUND(AVG(tolls),2) AS avg_tolls
FROM {{ref('fact_taxitrips')}}