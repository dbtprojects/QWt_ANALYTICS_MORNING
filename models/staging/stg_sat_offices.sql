{{config(materialized = 'table')}}

select 

ho.officehashkey,
current_timestamp as loaddate,
ho.recordsource,
ro.officeaddress,
ro.officepostalcode,
ro.officecity,
ro.officestateprovince,
ro.officephone,
ro.officefax,
ro.officecountry


from
{{ref('stg_hub_offices')}}  as ho inner join
{{source('qwt_raw', 'raw_offices')}} as ro on ho.officeid = ro.officeid