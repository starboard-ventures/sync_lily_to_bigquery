# coding=utf-8

import logging
from pyspark.sql.types import *
from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableVmMessages(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super(TableVmMessages, self).__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.state_root
               , t.cid
               , t.source
               , t.from
               , t.to
               , t.value::text     AS value
               , t.method
               , t.actor_code
               , t.exit_code
               , t.gas_used
               , t.params::text    AS params
               , t.returns::text   AS returns
               , t.index
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("state_root", StringType(), False),
          StructField("cid", StringType(), False),
          StructField("source", StringType(), False),
          StructField("from", StringType(), False),
          StructField("to", StringType(), False),
          StructField("value", StringType(), False),
          StructField("method", LongType(), False),
          StructField("actor_code", StringType(), False),
          StructField("exit_code", LongType(), False),
          StructField("gas_used", LongType(), False),
          StructField("params", StringType(), True),
          StructField("returns", StringType(), True),
          StructField("index", LongType(), False)
        ])

