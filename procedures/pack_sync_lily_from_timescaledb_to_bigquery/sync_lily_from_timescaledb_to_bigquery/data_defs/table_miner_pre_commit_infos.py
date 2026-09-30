
import logging

from pyspark.sql.types import *

from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableMinerPreCommitInfos(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super().__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.miner_id
               , t.sector_id
               , t.state_root
               , t.sealed_cid
               , t.seal_rand_epoch
               , t.expiration_epoch
               , t.pre_commit_deposit::text    AS pre_commit_deposit
               , t.pre_commit_epoch
               , t.deal_weight::text           AS deal_weight
               , t.verified_deal_weight::text  AS verified_deal_weight
               , t.is_replace_capacity
               , t.replace_sector_deadline
               , t.replace_sector_partition
               , t.replace_sector_number
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
          StructField("seal_rand_epoch", LongType(), True),
          StructField("expiration_epoch", LongType(), True),
          StructField("pre_commit_deposit", StringType(), False),
          StructField("pre_commit_epoch", LongType(), False),
          StructField("deal_weight", StringType(), False),
          StructField("verified_deal_weight", StringType(), False),
          StructField("is_replace_capacity", BooleanType(), False),
          StructField("replace_sector_deadline", LongType(), True),
          StructField("replace_sector_partition", LongType(), True),
          StructField("replace_sector_number", LongType(), True)
        ])

