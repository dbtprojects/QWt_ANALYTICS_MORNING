import snowflake.snowpark.functions as F

def model(dbt, session):

    dbt.config(materialized = 'table')

    customers_df = dbt.source('qwt_raw', 'raw_customers')

    return customers_df