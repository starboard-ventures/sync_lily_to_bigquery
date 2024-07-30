# coding=utf-8

import logging
from pyspark.sql.types import *
from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableChainPowers(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super(TableChainPowers, self).__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.state_root
               , t.total_raw_bytes_power::text          AS total_raw_bytes_power
               , t.total_raw_bytes_committed::text      AS total_raw_bytes_committed
               , t.total_qa_bytes_power::text           AS total_qa_bytes_power
               , t.total_qa_bytes_committed::text       AS total_qa_bytes_committed
               , t.total_pledge_collateral::text        AS total_pledge_collateral
               , t.qa_smoothed_position_estimate::text  AS qa_smoothed_position_estimate
               , t.qa_smoothed_velocity_estimate::text  AS qa_smoothed_velocity_estimate
               , t.miner_count
               , t.participating_miner_count
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("state_root", StringType(), False),
          StructField("total_raw_bytes_power", StringType(), False),
          StructField("total_raw_bytes_committed", StringType(), False),
          StructField("total_qa_bytes_power", StringType(), False),
          StructField("total_qa_bytes_committed", StringType(), False),
          StructField("total_pledge_collateral", StringType(), False),
          StructField("qa_smoothed_position_estimate", StringType(), False),
          StructField("qa_smoothed_velocity_estimate", StringType(), False),
          StructField("miner_count", LongType(), True),
          StructField("participating_miner_count", LongType(), True)
        ])

