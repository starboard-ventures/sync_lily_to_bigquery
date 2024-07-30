# coding=utf-8

import logging
from pyspark.sql.types import *
from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableMinerLockedFunds(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super(TableMinerLockedFunds, self).__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.miner_id
               , t.state_root
               , t.locked_funds::text         AS locked_funds
               , t.initial_pledge::text       AS initial_pledge
               , t.pre_commit_deposits::text  AS pre_commit_deposits
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("miner_id", StringType(), False),
          StructField("state_root", StringType(), False),
          StructField("locked_funds", StringType(), False),
          StructField("initial_pledge", StringType(), False),
          StructField("pre_commit_deposits", StringType(), False)
        ])

