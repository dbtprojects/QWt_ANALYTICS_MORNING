{{config(materialized = 'view', schema = 'reporting_dev')}}

{% set v_linenumbers = get_line_numbers()  %}


select 

orderid,

{% for linenumber in v_linenumbers -%}

sum(case when lineno = {{linenumber}} then linesalesamount end) as lineno{{linenumber}}_sales,

{% endfor %}


from

{{ref('fct_orders')}}

group by orderid