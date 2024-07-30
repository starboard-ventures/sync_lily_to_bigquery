# coding=utf-8

import logging
from pyspark.sql.types import *
from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableMessageParams(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super(TableMessageParams, self).__init__(table_name, config)
        self.bqy_table_if_overwrite = True


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.cid
               , t.params::text   AS params
            FROM {self.pg_table_name} t
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("cid", StringType(), False),
          StructField("params", StringType(), False)
        ])

