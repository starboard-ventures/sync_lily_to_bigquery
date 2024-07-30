# coding=utf-8

import logging
from pyspark.sql.types import *
from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableInternalParsedMessages(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super(TableInternalParsedMessages, self).__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.cid
               , t.from
               , t.to
               , t.value::text   AS value
               , t.method
               , t.params::text  AS params
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("cid", StringType(), False),
          StructField("from", StringType(), False),
          StructField("to", StringType(), False),
          StructField("value", StringType(), False),
          StructField("method", StringType(), False),
          StructField("params", StringType(), False)
        ])

