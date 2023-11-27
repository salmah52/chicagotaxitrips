-- Test to ensure that the total revenue is not NULL
select count(*)
from {{ ref('revenue') }}
where total_revenue is null;

-- Test to ensure that the total revenue is greater than or equal to 0
select count(*)
from {{ ref('revenue') }}
where total_revenue < 0


-- Reference tests
{{ config(
    materialized='view',
    post-hook='tests/revenue_metrics_test.sql'
) }}

