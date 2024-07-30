# coding=utf-8

import logging
from pyspark.sql.types import *
from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableMessages(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super(TableMessages, self).__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.cid
               , t.from
               , t.to
               , t.size_bytes
               , t.nonce
               , t.value::text         AS value
               , t.gas_fee_cap::text   AS gas_fee_cap
               , t.gas_premium::text   AS gas_premium
               , t.gas_limit
               , t.method
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("cid", StringType(), False),
          StructField("from", StringType(), False),
          StructField("to", StringType(), False),
          StructField("size_bytes", LongType(), False),
          StructField("nonce", LongType(), False),
          StructField("value", StringType(), False),
          StructField("gas_fee_cap", StringType(), False),
          StructField("gas_premium", StringType(), False),
          StructField("gas_limit", LongType(), False),
          StructField("method", LongType(), False)
        ])

