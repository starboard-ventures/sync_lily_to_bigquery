# coding=utf-8

import logging
from pyspark.sql.types import *
from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableVerifiedRegistryClaims(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super(TableVerifiedRegistryClaims, self).__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.state_root
               , t.claim_id
               , t.provider
               , t.client
               , t.data
               , t.size
               , t.term_min
               , t.term_max
               , t.term_start
               , t.sector
               , t.event
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("state_root", StringType(), False),
          StructField("claim_id", LongType(), False),
          StructField("provider", StringType(), False),
          StructField("client", StringType(), False),
          StructField("data", StringType(), False),
          StructField("size", LongType(), False),
          StructField("term_min", LongType(), False),
          StructField("term_max", LongType(), False),
          StructField("term_start", LongType(), False),
          StructField("sector", LongType(), False),
          StructField("event", StringType(), False)
        ])

