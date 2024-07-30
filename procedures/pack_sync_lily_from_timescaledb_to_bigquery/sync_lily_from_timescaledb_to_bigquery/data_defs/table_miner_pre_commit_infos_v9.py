# coding=utf-8

import logging
from pyspark.sql.types import *
from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableMinerPreCommitInfosV9(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super(TableMinerPreCommitInfosV9, self).__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.miner_id
               , t.sector_id
               , t.state_root
               , t.pre_commit_deposit::text  AS pre_commit_deposit
               , t.pre_commit_epoch
               , t.sealed_cid
               , t.seal_rand_epoch
               , t.expiration_epoch
               , t.deal_ids
               , t.unsealed_cid
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
          StructField("pre_commit_deposit", StringType(), False),
          StructField("pre_commit_epoch", LongType(), False),
          StructField("sealed_cid", StringType(), False),
          StructField("seal_rand_epoch", LongType(), False),
          StructField("expiration_epoch", LongType(), False),
          StructField("deal_ids", ArrayType(LongType(), True), True),
          StructField("unsealed_cid", StringType(), True)
        ])

