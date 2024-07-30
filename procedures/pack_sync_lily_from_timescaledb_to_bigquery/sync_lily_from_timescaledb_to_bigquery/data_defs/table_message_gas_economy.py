# coding=utf-8

import logging
from pyspark.sql.types import *
from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableMessageGasEconomy(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super(TableMessageGasEconomy, self).__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.state_root
               , t.gas_limit_total
               , t.gas_limit_unique_total
               , t.base_fee
               , t.base_fee_change_log
               , t.gas_fill_ratio
               , t.gas_capacity_ratio
               , t.gas_waste_ratio
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("state_root", StringType(), False),
          StructField("gas_limit_total", StringType(), False),
          StructField("gas_limit_unique_total", StringType(), True),
          StructField("base_fee", StringType(), False),
          StructField("base_fee_change_log", DoubleType(), False),
          StructField("gas_fill_ratio", DoubleType(), True),
          StructField("gas_capacity_ratio", DoubleType(), True),
          StructField("gas_waste_ratio", DoubleType(), True)
        ])

