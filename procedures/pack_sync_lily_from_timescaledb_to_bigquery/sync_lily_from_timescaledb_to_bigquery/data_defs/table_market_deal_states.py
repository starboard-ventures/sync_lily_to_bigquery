
import logging

from pyspark.sql.types import *

from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableMarketDealStates(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super().__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.deal_id
               , t.state_root
               , t.sector_start_epoch
               , t.last_update_epoch
               , t.slash_epoch
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("deal_id", LongType(), False),
          StructField("state_root", StringType(), False),
          StructField("sector_start_epoch", LongType(), False),
          StructField("last_update_epoch", LongType(), False),
          StructField("slash_epoch", LongType(), False)
        ])

