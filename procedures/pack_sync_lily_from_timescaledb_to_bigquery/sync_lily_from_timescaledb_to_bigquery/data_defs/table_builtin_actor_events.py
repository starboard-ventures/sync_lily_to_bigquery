# coding=utf-8

import logging
from pyspark.sql.types import *
from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableBuiltinActorEvents(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super(TableBuiltinActorEvents, self).__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.cid
               , t.emitter
               , t.event_type
               , t.event_idx
               , t.event_entries::text   AS event_entries
               , t.event_payload::text   AS event_payload
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("cid", StringType(), False),
          StructField("emitter", StringType(), False),
          StructField("event_type", StringType(), False),
          StructField("event_idx", LongType(), False),
          StructField("event_entries", StringType(), False),
          StructField("event_payload", StringType(), False)
        ])

