-- Reference tests
{{ config(
    materialized='view',
    post-hook='tests/customer_metrics_test.sql'
) }}

-- Test to ensure that the number of unique customers is not NULL
select count(*)
from {{ ref('customer_metrics') }}
where num_unique_customers is null

-- Test to ensure that the number of unique customers is greater than or equal to 0
select count(*)
from {{ ref('customer_metrics') }}
where num_unique_customers < 0
