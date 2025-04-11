# coding=utf-8

import logging
from pyspark.sql.types import *
from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableMinerSectorInfosV7(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super(TableMinerSectorInfosV7, self).__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.miner_id
               , t.sector_id
               , t.state_root
               , t.sealed_cid
               , t.activation_epoch
               , t.expiration_epoch
               , t.deal_weight::text              AS deal_weight
               , t.verified_deal_weight::text     AS verified_deal_weight
               , t.initial_pledge::text           AS initial_pledge
               , t.expected_day_reward::text      AS expected_day_reward
               , t.expected_storage_pledge::text  AS expected_storage_pledge
               , t.sector_key_cid
               , t.replaced_day_reward::text      AS replaced_day_reward
               , t.power_base_epoch               AS power_base_epoch
               , t.daily_fee::text                AS daily_fee
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("miner_id", StringType(), False),
          StructField("sector_id", LongType(), False),
          StructField("state_root", StringType(), False),
          StructField("sealed_cid", StringType(), False),
          StructField("activation_epoch", LongType(), True),
          StructField("expiration_epoch", LongType(), True),
          StructField("deal_weight", StringType(), False),
          StructField("verified_deal_weight", StringType(), False),
          StructField("initial_pledge", StringType(), False),
          StructField("expected_day_reward", StringType(), False),
          StructField("expected_storage_pledge", StringType(), False),
          StructField("sector_key_cid", StringType(), True),
          StructField("replaced_day_reward", StringType(), False),
          StructField("power_base_epoch", LongType(), False),
          StructField("daily_fee", StringType(), False)
        ])

