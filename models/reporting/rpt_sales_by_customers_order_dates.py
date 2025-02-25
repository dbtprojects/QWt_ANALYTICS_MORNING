import snowflake.snowpark.functions as F
import pandas as pd
import holidays

def is_holiday(holiday_date):

    french_holidays = holidays.France()

    is_holiday = (holiday_date in french_holidays)

    return is_holiday

def avgordervalue(nooforders, totalvalue):

    return totalvalue/nooforders

def model(dbt, session):

    dbt.config(materialized = 'table', schema = 'reporting_dev', packages = ['holidays'], pre_hook = 'use warehouse python_dbt_wh;')
    orders_df = dbt.ref('fct_orders')

    orders_agg_df = (
                    orders_df
                    .group_by('customerid')
                    .agg
                    (
                        F.min(F.col('orderdate')).alias('First_order_date'),
                        F.max(F.col('orderdate')).alias('Recent_order_Date'),
                        F.count(F.col('orderid')).alias('TotalOrders'),
                        F.countDistinct(F.col('productid')).alias('NoofProducts'),
                        F.sum(F.col('quantity')).alias('TotalQuantity'),
                        F.sum(F.col('LineSalesAmount')).alias('TotalSales'),
                        F.avg(F.col('margin')).alias('Avgmargin'),
                        
                    )
    )


    customers_df = dbt.ref('dim_customers')

    customer_orders_df = (
                            customers_df
                            .join(orders_agg_df, orders_agg_df.customerid == customers_df.customerid, 'left' )
                            .select(customers_df.companyname,
                                    customers_df.contactname,
                                    orders_agg_df.First_order_date,
                                    orders_agg_df.Recent_order_Date,
                                    orders_agg_df.TotalOrders,
                                    orders_agg_df.NoofProducts,
                                    orders_agg_df.TotalQuantity,
                                    orders_agg_df.TotalSales,
                                    orders_agg_df.Avgmargin
                                                           
                            
                            )
    )

    customer_orders_final_df = customer_orders_df.withColumn('AverageOrderAmount', avgordervalue(customer_orders_df["TotalQuantity"], customer_orders_df["TotalSales"]))

    final_df  = customer_orders_final_df.filter(F.col('FIRST_ORDER_DATE').isNotNull())

    final_orders_df = final_df.to_pandas()

    final_orders_df["is_first_order_on_holiday"] = final_orders_df["FIRST_ORDER_DATE"].apply(is_holiday)

    return final_orders_df