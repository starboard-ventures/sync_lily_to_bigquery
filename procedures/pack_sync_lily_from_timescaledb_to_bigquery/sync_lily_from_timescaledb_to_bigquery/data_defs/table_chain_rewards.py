# coding=utf-8

import logging
from pyspark.sql.types import *
from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableChainRewards(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super(TableChainRewards, self).__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.state_root
               , t.cum_sum_baseline::text                       AS cum_sum_baseline
               , t.cum_sum_realized::text                       AS cum_sum_realized
               , t.effective_baseline_power::text               AS effective_baseline_power
               , t.new_baseline_power::text                     AS new_baseline_power
               , t.new_reward_smoothed_position_estimate::text  AS new_reward_smoothed_position_estimate
               , t.new_reward_smoothed_velocity_estimate::text  AS new_reward_smoothed_velocity_estimate
               , t.total_mined_reward::text                     AS total_mined_reward
               , t.new_reward::text                             AS new_reward
               , t.effective_network_time
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("state_root", StringType(), False),
          StructField("cum_sum_baseline", StringType(), False),
          StructField("cum_sum_realized", StringType(), False),
          StructField("effective_baseline_power", StringType(), True),
          StructField("new_baseline_power", StringType(), False),
          StructField("new_reward_smoothed_position_estimate", StringType(), False),
          StructField("new_reward_smoothed_velocity_estimate", StringType(), False),
          StructField("total_mined_reward", StringType(), False),
          StructField("new_reward", StringType(), True),
          StructField("effective_network_time", LongType(), False)
        ])

