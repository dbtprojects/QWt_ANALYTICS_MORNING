{{config(materialized = 'view', schema = 'reporting_dev')}}

select 

e.officecity, 
c.companyname, 
c.contactname,
count(o.orderid) as total_orders, 
sum(o.quantity) as total_quantity ,
sum(o.linesalesamount) as total_sales, 
avg(o.margin) as avg_margin

from 

{{ref('fct_orders')}} as o inner join
{{ref('dim_customers')}} as c on 
o.customerid = c.customerid

inner join {{ref('dim_employees')}} as e 
on e.employee_id = o.employeeid

where e.officecity = '{{var('v_city', 'Paris')}}'

group by e.officecity, c.companyname,c.contactname