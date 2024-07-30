# coding=utf-8

import logging
from pyspark.sql.types import *
from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableFevmActorStats(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super(TableFevmActorStats, self).__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.contract_balance
               , t.eth_account_balance
               , t.placeholder_balance
               , t.contract_count
               , t.unique_contract_count
               , t.eth_account_count
               , t.placeholder_count
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("contract_balance", StringType(), False),
          StructField("eth_account_balance", StringType(), False),
          StructField("placeholder_balance", StringType(), False),
          StructField("contract_count", LongType(), False),
          StructField("unique_contract_count", LongType(), False),
          StructField("eth_account_count", LongType(), False),
          StructField("placeholder_count", LongType(), False)
        ])

