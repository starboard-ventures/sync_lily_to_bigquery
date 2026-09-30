
import logging

from pyspark.sql.types import *

from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableBlockHeaders(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super().__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.cid
               , t.parent_weight
               , t.parent_state_root
               , t.miner
               , t.timestamp
               , t.win_count
               , t.parent_base_fee
               , t.fork_signaling
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("cid", StringType(), False),
          StructField("parent_weight", StringType(), False),
          StructField("parent_state_root", StringType(), False),
          StructField("miner", StringType(), False),
          StructField("timestamp", LongType(), False),
          StructField("win_count", LongType(), True),
          StructField("parent_base_fee", StringType(), False),
          StructField("fork_signaling", LongType(), False)
        ])

