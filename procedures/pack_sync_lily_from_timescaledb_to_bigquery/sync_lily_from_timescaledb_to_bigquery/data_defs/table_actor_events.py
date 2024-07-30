# coding=utf-8

import logging
from pyspark.sql.types import *
from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableActorEvents(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super(TableActorEvents, self).__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.state_root
               , t.message_cid
               , t.event_index
               , t.entry_index
               , t.emitter
               , t.flags::text    AS flags
               , t.codec
               , t.key
               , t.value::text    AS value
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("state_root", StringType(), False),
          StructField("message_cid", StringType(), False),
          StructField("event_index", LongType(), False),
          StructField("entry_index", LongType(), False),
          StructField("emitter", StringType(), False),
          StructField("flags", StringType(), False),
          StructField("codec", LongType(), False),
          StructField("key", StringType(), False),
          StructField("value", StringType(), False)
        ])

