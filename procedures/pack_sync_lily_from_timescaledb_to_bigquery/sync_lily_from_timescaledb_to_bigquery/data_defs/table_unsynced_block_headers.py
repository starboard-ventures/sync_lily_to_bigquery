# coding=utf-8

import logging
from pyspark.sql.types import *
from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableUnsyncedBlockHeaders(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super(TableUnsyncedBlockHeaders, self).__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.cid
               , t.miner
               , t.parent_weight
               , t.parent_base_fee
               , t.parent_state_root
               , t.win_count
               , t.timestamp
               , t.fork_signaling
               , t.is_orphan
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("cid", StringType(), False),
          StructField("miner", StringType(), True),
          StructField("parent_weight", StringType(), True),
          StructField("parent_base_fee", StringType(), True),
          StructField("parent_state_root", StringType(), True),
          StructField("win_count", LongType(), True),
          StructField("timestamp", LongType(), True),
          StructField("fork_signaling", LongType(), True),
          StructField("is_orphan", BooleanType(), True)
        ])

