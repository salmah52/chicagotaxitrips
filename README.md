# Chicago Taxi Trips dbt Project Documentation

## Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- `dbt run`
- `dbt test`

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

## dbt Project Documentation

### Overview

This documentation provides an overview of the dbt (data build tool) project for the Chicago Taxi Trips dataset. The project follows a dimensional modeling approach to transform raw data into a structured analytics-ready format. The primary objectives include creating dimension and fact tables, generating diverse metrics, and implementing tests for data accuracy and reliability.

### Project Structure

The dbt project is organized into the following directories:

- **data/:** Contains raw data files.
- **models/:** Contains dbt models for staging, dimensions, facts, and metrics.
- **macros/:** Stores reusable SQL code snippets (macros).
- **analysis/:** Houses SQL queries for ad-hoc analysis.

### Staging Data

**stg_taxitrips Model:**
The staging model stg_taxitrips is responsible for ingesting and staging raw data from the data/ directory. It performs basic transformations such as data type casting and cleaning. The raw data includes information about taxi trips in Chicago.

### Dimensional Modeling

**Dimensions:**

1. **dim_date Model:**
   Extracts temporal attributes from the trip_start_timestamp and trip_end_timestamp. Attributes include start and end times, hour, day, month, year, weekday/weekend classification, quarter, and season.

2. **dim_drop_off Model:**
   Extracts information related to drop-off locations, including community area, latitude, longitude, location name, and census tract.

3. **dim_payment Model:**
   Extracts payment-related information, including payment types.

4. **dim_pick_up Model:**
   Extracts information related to pick-up locations, including community area, latitude, longitude, location name, and census tract.

**Facts:**

- **fact_taxitrips Model:**
  Combines data from the staging model and dimensions to create a fact table. It includes information such as trip details, fare, tips, trip duration, and more. The model adheres to the star schema for effective data modeling.

### Metrics Modeling

**Metrics Models:**

1. **Revenue Metrics Model (revenue_metrics):**
   - Total Revenue Over Time: Calculates total revenue (trip_total) over time.
   - Revenue by Month, Quarter, and Year: Aggregates revenue at different time granularities.
   - Average Revenue Per Trip: Calculates the average revenue per trip.
   - Top Revenue-Generating Taxis or Companies: Identifies top revenue-generating entities.

2. **Usage Metrics Model (usage_metrics):**
   - Total Number of Trips: Calculates the total number of trips.
   - Number of Trips by Hour, Day, Month, and Year: Aggregates trip counts at different time granularities.
   - Average Trip Duration: Calculates the average duration of trips.
   - Busiest Hours, Days, and Months: Identifies the busiest periods.

3. **Customer Metrics Model (customer_metrics):**
   - Number of Unique Customers: Calculates the count of unique customers.
   - Customer Retention Rate: Measures customer retention over time.
   - Average Trips Per Customer: Calculates the average trips taken by each customer.
   - Customer Segments Based on Usage Patterns: Segments customers based on their usage patterns.

4. **Geospatial Metrics Model (geospatial_metrics):**
   - Popular Pickup and Drop-off Locations: Identifies the most popular locations for pickups and drop-offs.
   - Distance Covered by Taxis: Calculates the total distance covered by taxis.
   - Heatmap of Trip Densities in Different Areas: Visualizes trip densities in various geographical areas.

### Tests

**Test Models:**

1. **Data Quality Tests (data_quality_tests):**
   - Ensures that critical fields in the stg_taxitrips model do not contain NULL values.
   - Validates that timestamps in the dim_date model fall within expected date ranges.
   - Verifies the integrity of foreign keys in fact and dimension tables.

2. **Metric Accuracy Tests (metric_accuracy_tests):**
   - Validates the accuracy of calculated metrics in revenue, usage, customer, and geospatial models.


## Conclusion
This documentation provides an in-depth understanding of the dbt project for Chicago Taxi Trips. It covers the entire process from staging raw data to creating dimension and fact tables, generating diverse metrics, and implementing tests for data quality and accuracy. Regularly update and expand this documentation as the project evolves.
