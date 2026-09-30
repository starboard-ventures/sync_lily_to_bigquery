
import logging

from pyspark.sql.types import *

from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableFevmTransactions(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super().__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.hash
               , t.transaction_index
               , t.block_hash
               , t.block_number
               , t.nonce
               , t.from
               , t.to
               , t.chain_id
               , t.value
               , t.input
               , t.type
               , t.gas
               , t.max_fee_per_gas::text           AS max_fee_per_gas
               , t.max_priority_fee_per_gas::text  AS max_priority_fee_per_gas
               , t.v
               , t.r
               , t.s
               , t.from_filecoin_address
               , t.to_filecoin_address
               , t.from_actor_name
               , t.to_actor_name
               , t.message_cid
               , t.access_list::text               AS access_list
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("hash", StringType(), False),
          StructField("transaction_index", LongType(), True),
          StructField("block_hash", StringType(), True),
          StructField("block_number", LongType(), True),
          StructField("nonce", LongType(), True),
          StructField("from", StringType(), True),
          StructField("to", StringType(), True),
          StructField("chain_id", LongType(), True),
          StructField("value", StringType(), True),
          StructField("input", StringType(), True),
          StructField("type", LongType(), True),
          StructField("gas", LongType(), True),
          StructField("max_fee_per_gas", StringType(), True),
          StructField("max_priority_fee_per_gas", StringType(), True),
          StructField("v", StringType(), True),
          StructField("r", StringType(), True),
          StructField("s", StringType(), True),
          StructField("from_filecoin_address", StringType(), True),
          StructField("to_filecoin_address", StringType(), True),
          StructField("from_actor_name", StringType(), True),
          StructField("to_actor_name", StringType(), True),
          StructField("message_cid", StringType(), True),
          StructField("access_list", StringType(), True)
        ])

