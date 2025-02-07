{{config(materialized = 'incremental', unique_key = ['orderid', 'lineno'])}}

select 
od.*,
o.orderdate
from
{{source('qwt_raw', 'raw_orderdetails')}} as od inner join
{{source('qwt_raw', 'raw_orders')}} as o on od.orderid = o.orderid

{% if is_incremental() %}

where o.orderdate > (select max(orderdate) from {{this}})

{% endif %}