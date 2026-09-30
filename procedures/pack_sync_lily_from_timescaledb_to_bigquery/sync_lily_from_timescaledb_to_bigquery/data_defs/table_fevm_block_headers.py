
import logging

from pyspark.sql.types import *

from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableFevmBlockHeaders(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super().__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.hash
               , t.parent_hash
               , t.miner
               , t.state_root
               , t.transactions_root
               , t.receipts_root
               , t.difficulty
               , t.number
               , t.gas_limit
               , t.gas_used
               , t.timestamp
               , t.extra_data
               , t.mix_hash
               , t.nonce
               , t.base_fee_per_gas
               , t.size
               , t.sha3_uncles
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("hash", StringType(), False),
          StructField("parent_hash", StringType(), False),
          StructField("miner", StringType(), False),
          StructField("state_root", StringType(), False),
          StructField("transactions_root", StringType(), False),
          StructField("receipts_root", StringType(), False),
          StructField("difficulty", LongType(), True),
          StructField("number", LongType(), True),
          StructField("gas_limit", LongType(), True),
          StructField("gas_used", LongType(), True),
          StructField("timestamp", LongType(), True),
          StructField("extra_data", StringType(), True),
          StructField("mix_hash", StringType(), True),
          StructField("nonce", StringType(), True),
          StructField("base_fee_per_gas", StringType(), False),
          StructField("size", LongType(), True),
          StructField("sha3_uncles", StringType(), False)
        ])

