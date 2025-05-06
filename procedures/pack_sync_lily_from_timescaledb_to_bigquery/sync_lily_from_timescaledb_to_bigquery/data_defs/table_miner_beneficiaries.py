# coding=utf-8

import logging
from pyspark.sql.types import *
from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


# 2025-05-06 Terry 确认该表不再产生新数据。
class TableMinerBeneficiaries(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super(TableMinerBeneficiaries, self).__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.state_root
               , t.miner_id
               , t.beneficiary
               , t.quota::text         AS quota
               , t.used_quota::text    AS used_quota
               , t.expiration
               , t.new_beneficiary
               , t.new_quota::text     AS new_quota
               , t.new_expiration
               , t.approved_by_beneficiary
               , t.approved_by_nominee
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("state_root", StringType(), False),
          StructField("miner_id", StringType(), False),
          StructField("beneficiary", StringType(), False),
          StructField("quota", StringType(), False),
          StructField("used_quota", StringType(), False),
          StructField("expiration", LongType(), False),
          StructField("new_beneficiary", StringType(), True),
          StructField("new_quota", StringType(), True),
          StructField("new_expiration", LongType(), True),
          StructField("approved_by_beneficiary", BooleanType(), True),
          StructField("approved_by_nominee", BooleanType(), True)
        ])

