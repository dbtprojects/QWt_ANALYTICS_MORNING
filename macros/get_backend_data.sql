{% macro get_line_numbers() %}

    {% set get_line_number_query %}

        SELECT distinct lineno
        from {{ref('fct_orders')}}
        order by lineno

    {% endset %}

    {% set results = run_query(get_line_number_query) %}

    {% if execute %}
    {# Return the first column #}
    {% set results_list = results.columns[0].values() %}
    {% else %}
    {% set results_list = [] %}
    {% endif %}

    {{ return(results_list) }}

{% endmacro %}

{% macro get_min_orderdate() %}

    {% set get_min_orderdate_query %}

        SELECT min(orderdate)
        from {{ref('fct_orders')}}
     
    {% endset %}

    {% set results = run_query(get_min_orderdate_query) %}

    {% if execute %}
    {# Return the first column #}
    {% set results_list = results.columns[0][0] %}
    {% else %}
    {% set results_list = [] %}
    {% endif %}

    {{ return(results_list) }}

{% endmacro %}

{% macro get_max_orderdate() %}

    {% set get_max_orderdate_query %}

        SELECT max(orderdate)
        from {{ref('fct_orders')}}
     
    {% endset %}

    {% set results = run_query(get_max_orderdate_query) %}

    {% if execute %}
    {# Return the first column #}
    {% set results_list = results.columns[0][0] %}
    {% else %}
    {% set results_list = [] %}
    {% endif %}

    {{ return(results_list) }}

{% endmacro %}