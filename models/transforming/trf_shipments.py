import snowflake.snowpark.functions as F

def model(dbt, session):

    dbt.config(materialized = 'table')

    shipments_df = dbt.ref('shipments_snapshot')

    shippers_df = dbt.ref('lkp_shippers')

    final_shipments_df = (
                            shipments_df
                            .join(shippers_df, shipments_df.shipperid == shippers_df.shipperid, 'left')
                            .select(
                                        shipments_df.orderid,
                                        shipments_df.lineno,
                                        shipments_df.shipmentdate,
                                        shipments_df.status,
                                        shippers_df.companyname
                            )
    )

    final_shipments_df = final_shipments_df.filter(F.col('dbt_valid_to').isNull())

    return final_shipments_df
                        