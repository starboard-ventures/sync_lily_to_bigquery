# coding=utf-8

import logging
from pyspark.sql.types import *
from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableMinerCurrentDeadlineInfos(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super(TableMinerCurrentDeadlineInfos, self).__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.miner_id
               , t.state_root
               , t.deadline_index
               , t.period_start
               , t.open
               , t.close
               , t.challenge
               , t.fault_cutoff
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("miner_id", StringType(), False),
          StructField("state_root", StringType(), False),
          StructField("deadline_index", LongType(), False),
          StructField("period_start", LongType(), False),
          StructField("open", LongType(), False),
          StructField("close", LongType(), False),
          StructField("challenge", LongType(), False),
          StructField("fault_cutoff", LongType(), False)
        ])

