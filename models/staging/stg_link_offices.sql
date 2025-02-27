{{config(materialized = 'table')}}

select 
md5(ho.officehashkey || re.empid) as empofficehashkey,
current_timestamp as loaddate,
ho.recordsource,
ho.officehashkey,
re.empid
from
{{ref('stg_hub_offices')}} as ho 
inner join {{source("qwt_raw", 'raw_employees')}} re on
ho.officeid = re.office

