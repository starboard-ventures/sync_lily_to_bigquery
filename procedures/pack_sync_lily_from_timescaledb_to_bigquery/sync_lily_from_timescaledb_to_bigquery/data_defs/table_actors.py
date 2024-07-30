# coding=utf-8

import logging
from pyspark.sql.types import *
from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableActors(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super(TableActors, self).__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.id
               , t.state_root
               , t.code
               , t.head
               , t.nonce
               , t.balance
               , t.state::text    AS state
               , t.code_cid
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("id", StringType(), False),
          StructField("state_root", StringType(), False),
          StructField("code", StringType(), False),
          StructField("head", StringType(), False),
          StructField("nonce", LongType(), False),
          StructField("balance", StringType(), False),
          StructField("state", StringType(), True),
          StructField("code_cid", StringType(), True)
        ])

