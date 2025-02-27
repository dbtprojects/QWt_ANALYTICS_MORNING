{{config(materialized = 'table', schema = env_var('DBT_TRANSFORMSCHEMA', 'TRANSFORMING_DEV'))}}

with recursive managers 
      
      (indent, officeid, employee_id, manager_id, employee_title, manager_title, employee_name, manager_name) 
    as
      (

        -- Anchor Clause
        select '*' as indent, office, empid, IFF(reportsto is null, empid, reportsto), 
        title as employee_title, title as manager_title, lastname as employee_name, lastname as manager_name from {{ref('stg_employees')}}
          where title = 'President'

        union all

        -- Recursive Clause
        select
            indent || ' *' as indent, emp.office, emp.empid, emp.reportsto, emp.title, 
            mgr.employee_title, emp.lastname as employee_name, mgr.employee_name as manager_name
          from {{ref('stg_employees')}} as emp inner join managers as mgr
            on emp.reportsto = mgr.employee_id
      ),

      offices (officeid, officecity, officecountry)
      as
      (
      select ho.officeid, so.officecity, so.officecountry from {{ref('stg_sat_offices')}} as so inner join
      {{ref("stg_hub_offices") }} as ho on so.officehashkey = ho.officehashkey
      )

  -- This is the "main select".
  select managers.indent, managers.employee_id, offices.officecity, offices.officecountry, 
  managers.employee_title, managers.manager_id, managers.manager_title, managers.employee_name, 
  managers.manager_name
    from managers left join offices on managers.officeid = offices.officeid