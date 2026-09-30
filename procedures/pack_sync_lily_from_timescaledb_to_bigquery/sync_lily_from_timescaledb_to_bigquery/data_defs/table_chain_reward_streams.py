
import logging

from pyspark.sql.types import *

from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableChainRewardStreams(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super().__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.state_root
               , t.total_minted_reward::text      AS total_minted_reward
               , t.total_burn_minted::text        AS total_burn_minted
               , t.total_explicit_minted::text    AS total_explicit_minted
               , t.burn_weight::text              AS burn_weight
               , t.consensus_weight::text         AS consensus_weight
               , t.service_weight::text           AS service_weight
               , t.consensus_v_start::text        AS consensus_v_start
               , t.consensus_slope::text          AS consensus_slope
               , t.consensus_t_start              AS consensus_t_start
               , t.consensus_floor::text          AS consensus_floor
               , t.consensus_cap::text            AS consensus_cap
               , t.service_v_start::text          AS service_v_start
               , t.service_slope::text            AS service_slope
               , t.service_t_start                AS service_t_start
               , t.service_floor::text            AS service_floor
               , t.service_cap::text              AS service_cap
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("state_root", StringType(), False),
          StructField("total_minted_reward", StringType(), False),
          StructField("total_burn_minted", StringType(), False),
          StructField("total_explicit_minted", StringType(), False),
          StructField("burn_weight", StringType(), False),
          StructField("consensus_weight", StringType(), False),
          StructField("service_weight", StringType(), False),
          StructField("consensus_v_start", StringType(), False),
          StructField("consensus_slope", StringType(), False),
          StructField("consensus_t_start", LongType(), False),
          StructField("consensus_floor", StringType(), False),
          StructField("consensus_cap", StringType(), False),
          StructField("service_v_start", StringType(), False),
          StructField("service_slope", StringType(), False),
          StructField("service_t_start", LongType(), False),
          StructField("service_floor", StringType(), False),
          StructField("service_cap", StringType(), False)
        ])

