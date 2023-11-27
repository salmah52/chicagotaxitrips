{% macro calculate_average(column_name) %}
    select
        avg({{ column_name }}) as avg_{{ column_name }}
    from {{ ref('stg_taxitrips') }};
{% endmacro %}
