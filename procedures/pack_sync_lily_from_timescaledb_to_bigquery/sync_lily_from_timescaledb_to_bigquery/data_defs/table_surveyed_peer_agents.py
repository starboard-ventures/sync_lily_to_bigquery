
import logging

from pyspark.sql.types import *

from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableSurveyedPeerAgents(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super().__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.surveyer_peer_id
               , (t.observed_at AT TIME ZONE 'UTC')  AS observed_at
               , t.raw_agent
               , t.normalized_agent
               , t.count
            FROM {self.pg_table_name} t
           WHERE (t.observed_at AT TIME ZONE 'UTC') >= to_timestamp({height_start} * 30 + 1598306400)
             AND (t.observed_at AT TIME ZONE 'UTC') <  to_timestamp({height_end} * 30 + 1598306400)
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("surveyer_peer_id", StringType(), False),
          StructField("observed_at", TimestampType(), False),
          StructField("raw_agent", StringType(), False),
          StructField("normalized_agent", StringType(), False),
          StructField("count", LongType(), False)
        ])

