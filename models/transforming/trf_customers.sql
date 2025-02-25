{{config(materialized = 'table', schema = env_var('DBT_TRANSFORMSCHEMA', 'TRANSFORMING_DEV'))}}

select 

c.customerid,
c.companyname,
c.contactname,
c.city,
c.country,
d.divisionname,
c.address,
c.fax,
c.phone,
c.postacode,
IFF(c.stateprovince = '', 'NA', c.stateprovince) as stateprovincename

from

{{ref('stg_customers')}} as c left join {{ref('lkp_divisions')}} as d

on c.divisionid = d.divisionid