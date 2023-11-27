## Chicago Taxi Trips dbt Project Documentation
## Project Title: Creating an ELT Data Pipeline for Chicago Taxi Trips
## Welcome to my Chicago Taxitrips ETL Pipeline

This project focuses on building a comprehensive Extract, Load, Transform (ELT) data pipeline to collect information from the Chicago Data Portal's Taxi Trips dataset using its API.The extracted data is then loaded into a PostgreSQL database, transferred to a Google  Cloud Storage (GCS) bucket, and finally moved to BigQuery.

## Data Architecture:
A robust data architecture is crucial for ensuring data quality, integrity, and accessibility. Here's the architecture for your Eviction Notices Data Pipeline:

<img width="626" alt="image" src="https://github.com/salmah52/chicagotaxitrips/assets/44398948/3389d5d5-a2fa-4707-907a-e6d4f94081b8">

1. Data Source:
   - Chicago Data Portal API (Taxi Trips dataset)

2. ETL (Extract, Transform, Load) Pipeline:
   - Apache Airflow for orchestration and automation
   - Custom operators for extracting data from the API and loading it into PostgreSQL, and Google Cloud Storage (GGCS) 
   - Google Cloud Storage (GCS)
   - Google Cloud Storage (GCS) for intermediate storage of raw data

3. Data Warehouse:
   - Google BigQuery for data warehousing
   - Create a dedicated dataset in BigQuery (e.g., raw_data_table)
   - Use tables in BigQuery to store raw and transformed data

4. Data Transformation:
   - dbt (Data Build Tool) for data modeling, transformation, and analytics
   - Data Reporting and Visualization:

5. Business Intelligence (BI) tools such as Tableau, Looker, or Google Data Studio

## Dataset Description:
- **Name:** Taxi Trips
- **Category:** Transporation
- **Data Source:** ity of Chicago
- **Description:** Taxi trips reported to the City of Chicago in its role as a regulatory agency. To protect privacy but allow for aggregate analyses, the Taxi ID is consistent for any given taxi medallion number but does not show the number, Census Tracts are suppressed in some cases, and times are rounded to the nearest 15 minute


## Columns in the Dataset- Data Dictionary

**Rows** - 211M   
**Columns** - 23

# Project Stages:
1. Data Extraction and Loading (Extract and Load Pipeline):
   
# Code Explanation - Data Extraction and Loading
Code 1: TaxitripsToPostgresOperator
This code defines a custom Airflow Operator (TaxitripsToPostgresOperator) responsible for extracting data from the Chicago taxi trips API and loading it into a PostgreSQL database. Let's break down the key components:

Initialization: The constructor (__init__ method) initializes various parameters, including the API details, PostgreSQL connection ID, table name, and other configuration options.

Execution Method (execute):

Constructs the API URL based on the provided endpoint.
Sets up parameters for the API request, including limit and order.
Sends a GET request to the API with proper headers and parameters.
Checks for errors in the API response.
If the response is successful (status code 200), converts the JSON data to a Pandas DataFrame and drops unnecessary columns (pickup_centroid_location and dropoff_centroid_location).
Logs information about the data extraction.
Uses SQLAlchemy to send the processed DataFrame to the PostgreSQL database.
Code 2: Airflow DAG Definition
This code defines an Airflow Directed Acyclic Graph (DAG) to orchestrate the data extraction and loading process. Key details include:

DAG Configuration (dag):

Sets default arguments, including owner, start date, and retry policies.
Defines the DAG with a unique identifier ('taxitrips_extraction_dag0009'), a description, and a schedule interval (every day in this case).
Tasks:

start_task: A dummy task marking the start of the DAG.
extract_and_load_task: An instance of the TaxitripsToPostgresOperator representing the data extraction and loading task. Configured with specific parameters.
end_task: Another dummy task marking the end of the DAG.
Task Dependencies (start_task >> extract_and_load_task >> end_task):

Specifies the order in which tasks should be executed. In this case, the DAG starts with start_task, followed by extract_and_load_task, and finally end_task.
Why This Approach?
Custom Operator: The custom operator encapsulates the logic for data extraction and loading, promoting reusability and readability.

Pandas DataFrame: Leveraging Pandas allows for convenient data manipulation and transformation before loading it into PostgreSQL.

Dynamic API Configuration: The operator is configurable, allowing users to specify API details, order, and other parameters during instantiation.

Airflow DAG: The DAG orchestrates the entire process, defining the sequence of tasks to be executed.

Docker-Ready: This approach is containerization-friendly, ensuring easy deployment and scalability in a Dockerized environment.

This design promotes modularity, making it easy to extend the pipeline for future stages and modifications. The DAG provides a visual representation of the workflow, making it comprehensible and adaptable to changing requirements.
 


This capstone project aims to design and implement a robust data pipeline using various technologies and 
tools. The goal is to extract data from a choser any other 
suitable dataset accessible via API), transform it, and load it into a structured data warehouse for further 
analysis and reporting
1. Data Extraction and Loading (Extract and Load Pipeline)
Objective: Utilize custom-built Airflow Hooks and Operators to connect with the selected API and create a pipeline for extracting data from the API endpoint. The extracted data will be loaded into a PostgreSQL database.

Components:

Airflow Hooks and Operators: Custom-built components that facilitate the interaction between Airflow and the API as well as the PostgreSQL database.

DAG (Directed Acyclic Graph): An Airflow DAG named taxitrips_extraction_dag is created to orchestrate the ETL workflow.

Tasks:

Create Table Task (create_table): A task responsible for creating the PostgreSQL table if it does not exist. Uses the PostgresOperator to execute SQL commands.

Extract and Load Task (extract_and_load): A task using a custom TaxitripsToPostgresOperator to fetch data from the API, transform it, and load it into the PostgreSQL table.

Dependencies:

The extract_and_load task depends on the successful completion of the create_table task.
Configuration:

The API endpoint, API token, PostgreSQL connection details, and other parameters are configured in the Airflow DAG and the custom operator (TaxitripsToPostgresOperator).

Retry and timeout configurations are set to handle potential issues during data extraction.

2. Data Transformation and Integration (ELT Pipeline)
Objective: Implement an ELT pipeline to transfer data from the PostgreSQL database to a Google Cloud Storage (GCS) data lake. Further move data from GCS to Google BigQuery for enhanced analytics capabilities.

Components:

Custom ELT Operators: Develop custom operators to perform data extraction from PostgreSQL, storage in GCS, and loading into Google BigQuery.

DAG Configuration: Extend the existing Airflow DAG (taxitrips_extraction_dag) to incorporate ELT tasks.

3. Transformation Layer and Analytics Modeling (dbt Implementation)
Objective: Develop a transformation layer using dbt (data build tool) with diverse metrics, aligning with staging, intermediate, and final (mart) models. Adopt the star schema or Kimball's model for effective data modeling in the transformation layer, referencing the provided model diagram. Create at least two analytics metrics models in dbt, demonstrating their value addition to analytics.

Components:

dbt Models: Implement dbt models based on the provided data modeling strategy.

Star Schema or Kimball's Model: Adopt a suitable data modeling approach for effective analytics.

DAG Configuration:

Add tasks to the Airflow DAG (taxitrips_extraction_dag) to trigger dbt runs after the ELT pipeline.

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
