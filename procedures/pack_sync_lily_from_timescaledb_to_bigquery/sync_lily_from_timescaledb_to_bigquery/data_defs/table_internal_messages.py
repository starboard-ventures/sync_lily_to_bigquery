
import logging

from pyspark.sql.types import *

from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableInternalMessages(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super().__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.cid
               , t.state_root
               , t.source_message
               , t.from
               , t.to
               , t.value::text       AS value
               , t.method
               , t.actor_name
               , t.actor_family
               , t.exit_code
               , t.gas_used
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("cid", StringType(), False),
          StructField("state_root", StringType(), False),
          StructField("source_message", StringType(), False),
          StructField("from", StringType(), False),
          StructField("to", StringType(), False),
          StructField("value", StringType(), False),
          StructField("method", LongType(), False),
          StructField("actor_name", StringType(), False),
          StructField("actor_family", StringType(), False),
          StructField("exit_code", LongType(), False),
          StructField("gas_used", LongType(), False)
        ])

