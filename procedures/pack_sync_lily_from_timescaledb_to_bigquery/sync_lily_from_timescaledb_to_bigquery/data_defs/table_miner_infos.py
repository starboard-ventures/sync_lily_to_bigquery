
import logging

from pyspark.sql.types import *

from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableMinerInfos(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super().__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.miner_id
               , t.state_root
               , t.owner_id
               , t.worker_id
               , t.new_worker
               , t.worker_change_epoch
               , t.consensus_faulted_elapsed
               , t.peer_id
               , t.control_addresses::text       AS control_addresses
               , t.multi_addresses::text         AS multi_addresses
               , t.sector_size
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("miner_id", StringType(), False),
          StructField("state_root", StringType(), False),
          StructField("owner_id", StringType(), False),
          StructField("worker_id", StringType(), False),
          StructField("new_worker", StringType(), True),
          StructField("worker_change_epoch", LongType(), False),
          StructField("consensus_faulted_elapsed", LongType(), False),
          StructField("peer_id", StringType(), True),
          StructField("control_addresses", StringType(), True),
          StructField("multi_addresses", StringType(), True),
          StructField("sector_size", LongType(), False)
        ])

