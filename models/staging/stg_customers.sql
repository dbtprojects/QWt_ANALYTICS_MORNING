{{config(materialized = 'table', sql_header = 'use warehouse loading_wh;')}}

select *
from
{{source('qwt_raw', 'raw_customers')}}