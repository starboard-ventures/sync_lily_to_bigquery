# coding=utf-8

import logging
from pyspark.sql.types import *
from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableDerivedGasOutputs(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super(TableDerivedGasOutputs, self).__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.cid
               , t.state_root
               , t.from
               , t.to
               , t.value::text                 AS value
               , t.gas_fee_cap::text           AS gas_fee_cap
               , t.gas_premium::text           AS gas_premium
               , t.gas_limit
               , t.size_bytes
               , t.nonce
               , t.method
               , t.exit_code
               , t.gas_used
               , t.parent_base_fee::text       AS parent_base_fee
               , t.base_fee_burn::text         AS base_fee_burn
               , t.over_estimation_burn::text  AS over_estimation_burn
               , t.miner_penalty::text         AS miner_penalty
               , t.miner_tip::text             AS miner_tip
               , t.refund::text                AS refund
               , t.gas_refund
               , t.gas_burned
               , t.actor_name
               , t.actor_family
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("cid", StringType(), False),
          StructField("state_root", StringType(), False),
          StructField("from", StringType(), False),
          StructField("to", StringType(), False),
          StructField("value", StringType(), False),
          StructField("gas_fee_cap", StringType(), False),
          StructField("gas_premium", StringType(), False),
          StructField("gas_limit", LongType(), True),
          StructField("size_bytes", LongType(), True),
          StructField("nonce", LongType(), True),
          StructField("method", LongType(), True),
          StructField("exit_code", LongType(), False),
          StructField("gas_used", LongType(), False),
          StructField("parent_base_fee", StringType(), False),
          StructField("base_fee_burn", StringType(), False),
          StructField("over_estimation_burn", StringType(), False),
          StructField("miner_penalty", StringType(), False),
          StructField("miner_tip", StringType(), False),
          StructField("refund", StringType(), False),
          StructField("gas_refund", LongType(), False),
          StructField("gas_burned", LongType(), False),
          StructField("actor_name", StringType(), False),
          StructField("actor_family", StringType(), False)
        ])

