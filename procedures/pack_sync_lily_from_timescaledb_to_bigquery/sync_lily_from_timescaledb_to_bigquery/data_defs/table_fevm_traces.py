
import logging

from pyspark.sql.types import *

from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableFevmTraces(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super().__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.message_state_root
               , t.message_cid
               , t.transaction_hash
               , t.trace_cid
               , t.from
               , t.to
               , t.from_filecoin_address
               , t.to_filecoin_address
               , t.value::text             AS value
               , t.method
               , t.parsed_method
               , t.actor_code
               , t.exit_code
               , t.params
               , t.returns
               , t.index
               , t.parsed_params::text     AS parsed_params
               , t.parsed_returns::text    AS parsed_returns
               , t.params_codec
               , t.returns_codec
               , t.from_actor_name
               , t.to_actor_name
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("message_state_root", StringType(), False),
          StructField("message_cid", StringType(), False),
          StructField("transaction_hash", StringType(), False),
          StructField("trace_cid", StringType(), False),
          StructField("from", StringType(), False),
          StructField("to", StringType(), False),
          StructField("from_filecoin_address", StringType(), False),
          StructField("to_filecoin_address", StringType(), False),
          StructField("value", StringType(), False),
          StructField("method", LongType(), False),
          StructField("parsed_method", StringType(), False),
          StructField("actor_code", StringType(), False),
          StructField("exit_code", LongType(), False),
          StructField("params", StringType(), False),
          StructField("returns", StringType(), False),
          StructField("index", LongType(), False),
          StructField("parsed_params", StringType(), False),
          StructField("parsed_returns", StringType(), False),
          StructField("params_codec", LongType(), False),
          StructField("returns_codec", LongType(), False),
          StructField("from_actor_name", StringType(), False),
          StructField("to_actor_name", StringType(), False)
        ])

