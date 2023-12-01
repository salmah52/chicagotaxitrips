# Import necessary modules
import time
from typing import Dict, Any
from airflow.hooks.http_hook import HttpHook
from airflow.models import BaseOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook
import pandas as pd
from sqlalchemy import create_engine
import requests
from datetime import timedelta

class TaxitripsToPostgresOperator(BaseOperator):

    def __init__(
        self,
        api_token: str,
        order_by: str,
        postgres_conn_id: str = "",
        table: str = "taxitrips_data02",
        api_url: str = "https://data.cityofchicago.org/resource/",
        api_endpoint: str = "wrvz-psew.json",
        max_results: int = ,
        timeout: int = 900,
        retries: int = 0,
        retry_delay: timedelta = timedelta(minutes=5),
        *args,
        **kwargs
    ) -> None:
        super().__init__(*args, retries=retries, retry_delay=retry_delay, **kwargs)
        self.api_url = api_url
        self.api_token = api_token
        self.max_results = max_results
        self.endpoint = api_endpoint
        self.order_by = order_by
        self.postgres_conn_id = postgres_conn_id
        self.table = table
        self.timeout = timeout

    def execute(self, context):
        api_url = self.api_url + self.endpoint
        self.log.info(f"API url is: {api_url}")

        limit = self.max_results
        offset = 0
        params = {
            '$limit': limit,
            '$offset': offset,
            '$order': self.order_by,
        }

        headers = {
            'X-App-Token': self.api_token,
        }

        try:
            response = requests.get(api_url, headers=headers, params=params)
            response.raise_for_status()
        except requests.exceptions.RequestException as e:
            self.log.error(f"Error during data download: {e}")
            raise

        if response.status_code == 200:
            data = response.json()
            d = pd.DataFrame(data)
            
            
            columns_to_drop = ['pickup_centroid_location', 'dropoff_centroid_location']
            df = d.drop(columns=columns_to_drop)
            self.log.info(f"Dataframe currently has {df.shape[0]} rows")
            
              # Convert timestamp columns to datetime
            timestamp_columns = ['trip_start_timestamp', 'trip_end_timestamp']
            for timestamp_column in timestamp_columns:
                if timestamp_column in df.columns:
                    df[timestamp_column] = pd.to_datetime(df[timestamp_column])
                else:
                    self.log.warning(f"Column '{timestamp_column}' not found in DataFrame.")

            if len(data) < limit:
                self.log.info("Data download complete.")
            else:
                self.log.warning("Number of rows reached the limit. Consider increasing the limit.")
        else:
            self.log.info(f"Request failed with status code: {response.status_code}")
            if response.status_code == 403:
                self.log.warning("API returned a 403 Forbidden error. Check API key and permissions.")
            else:
                self.log.error("Unexpected error during data download.")
            raise

        # SQLAlchemy logic to send data to PostgreSQL
        postgres_hook = PostgresHook(postgres_conn_id=self.postgres_conn_id)
        engine = postgres_hook.get_sqlalchemy_engine()
        df.to_sql(name=self.table, con=engine, index=False, if_exists="replace")
        self.log.info("Table successfully loaded")
