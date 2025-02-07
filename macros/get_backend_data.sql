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