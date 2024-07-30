# coding=utf-8

import logging
from pyspark.sql.types import *
from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableMarketDealProposals(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super(TableMarketDealProposals, self).__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.deal_id
               , t.state_root
               , t.piece_cid
               , t.padded_piece_size
               , t.unpadded_piece_size
               , t.is_verified
               , t.client_id
               , t.provider_id
               , t.start_epoch
               , t.end_epoch
               , t.slashed_epoch
               , t.storage_price_per_epoch
               , t.provider_collateral
               , t.client_collateral
               , t.label
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("deal_id", LongType(), False),
          StructField("state_root", StringType(), False),
          StructField("piece_cid", StringType(), False),
          StructField("padded_piece_size", LongType(), False),
          StructField("unpadded_piece_size", LongType(), False),
          StructField("is_verified", BooleanType(), False),
          StructField("client_id", StringType(), False),
          StructField("provider_id", StringType(), False),
          StructField("start_epoch", LongType(), False),
          StructField("end_epoch", LongType(), False),
          StructField("slashed_epoch", LongType(), True),
          StructField("storage_price_per_epoch", StringType(), False),
          StructField("provider_collateral", StringType(), False),
          StructField("client_collateral", StringType(), False),
          StructField("label", StringType(), True)
        ])

