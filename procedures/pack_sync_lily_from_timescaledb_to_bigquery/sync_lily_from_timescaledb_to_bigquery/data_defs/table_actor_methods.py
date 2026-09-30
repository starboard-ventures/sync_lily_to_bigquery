
import logging

from pyspark.sql.types import *

from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableActorMethods(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super().__init__(table_name, config)
        self.bqy_table_if_overwrite = True


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.family
               , t.method_name
               , t.method
            FROM {self.pg_table_name} t
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("family", StringType(), False),
          StructField("method_name", StringType(), False),
          StructField("method", LongType(), False)
        ])

