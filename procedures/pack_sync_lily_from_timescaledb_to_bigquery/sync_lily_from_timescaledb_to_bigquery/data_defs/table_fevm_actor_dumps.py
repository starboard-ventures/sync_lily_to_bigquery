# coding=utf-8

import logging
from pyspark.sql.types import *
from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableFevmActorDumps(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super(TableFevmActorDumps, self).__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.actor_id
               , t.eth_address
               , t.byte_code
               , t.byte_code_hash
               , t.balance::text     AS balance
               , t.nonce
               , t.actor_name
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("actor_id", StringType(), False),
          StructField("eth_address", StringType(), True),
          StructField("byte_code", StringType(), True),
          StructField("byte_code_hash", StringType(), True),
          StructField("balance", StringType(), True),
          StructField("nonce", LongType(), False),
          StructField("actor_name", StringType(), True)
        ])

