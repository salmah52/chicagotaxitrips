# Import necessary modules
from datetime import datetime, timedelta
from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from web.operators.taxitrips_pg import TaxitripsToPostgresOperator
from airflow.operators.dummy_operator import DummyOperator
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator
from airflow.providers.dbt.cloud.operators.dbt import DbtCloudRunJobOperator
from airflow.providers.google.cloud.transfers.postgres_to_gcs import PostgresToGCSOperator


default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2023, 1, 1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'taxitrips_extraction_dag00099',
    default_args=default_args,
    description='DAG to extract data from Chicago taxi trips API and load into PostgreSQL',
    start_date=datetime(2023, 11, 27),
    schedule_interval=timedelta(days=1),  # Adjust the schedule as needed
)

start_task = DummyOperator(
    task_id='start_task',
    dag=dag,
)

extract_and_load_task = TaxitripsToPostgresOperator(
    task_id='extract_and_load',
    api_token='',  # Replace with your API token
    order_by='trip_id',  # Replace with the column to order by
    postgres_conn_id='',  # Replace with your PostgreSQL connection ID
    table='taxitrips_data02',  # Replace with your desired table name
    api_url='https://data.cityofchicago.org/resource/',
    api_endpoint='wrvz-psew.json',
    max_results= ,
    timeout=900,
    retries=1,
    retry_delay=timedelta(minutes=5),
    dag=dag,
)

# Load data from PostgreSQL to GCS
postgres_to_gcs_task = PostgresToGCSOperator(
    task_id='postgres_to_gcs',
    sql='SELECT * FROM taxitrips_data02',  # Replace with your SQL query
    postgres_conn_id='',  # Replace with your PostgreSQL connection ID
    bucket ='taxi-trips009',  # Replace with your GCS bucket name
    filename='taxitrips_data02.csv',  # Replace with your desired file name
    schema= None,  # Replace with your PostgreSQL schema
    field_delimiter=',',
    export_format='CSV',
    dag=dag,
)

# Load data from GCS to BigQuery
gcs_to_bigquery_task = GCSToBigQueryOperator(
    task_id='gcs_to_bigquery',
    bucket='taxi-trips009',  # Replace with your GCS bucket name
    source_objects=['taxitrips_data02.csv'],  # Replace with your GCS object path
    destination_project_dataset_table='',  # Replace with your BigQuery destination table
    schema_fields=None,  # Replace with your schema fields if needed
    create_disposition='CREATE_IF_NEEDED',        
    write_disposition='WRITE_TRUNCATE',  # Adjust as needed
  
    dag=dag,
)
trigger_job_run = DbtCloudRunJobOperator(
        task_id="trigger_job_run",
        dbt_cloud_conn_id = "dbt_conn", 
        job_id=464367,
        check_interval=10,
        timeout=300,
    )
end_task = DummyOperator(
    task_id='end_task',
    dag=dag,
)


# Set up task dependencies
start_task >> extract_and_load_task >> postgres_to_gcs_task >> gcs_to_bigquery_task  >> trigger_job_run >> end_task

