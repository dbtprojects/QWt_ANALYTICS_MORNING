{{config(materialized = 'view', schema = 'salesmart_dev')}}

select *
from
{{ref('trf_date')}}