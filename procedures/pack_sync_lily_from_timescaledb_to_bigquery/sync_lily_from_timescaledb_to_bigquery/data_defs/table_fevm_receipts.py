
import logging

from pyspark.sql.types import *

from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableFevmReceipts(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super().__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.transaction_hash
               , t.transaction_index
               , t.block_hash
               , t.block_number
               , t.from
               , t.to
               , t.contract_address
               , t.status
               , t.cumulative_gas_used
               , t.gas_used
               , t.effective_gas_price
               , t.logs_bloom
               , t.logs::text             AS logs
               , t.message
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("transaction_hash", StringType(), False),
          StructField("transaction_index", LongType(), True),
          StructField("block_hash", StringType(), True),
          StructField("block_number", LongType(), True),
          StructField("from", StringType(), True),
          StructField("to", StringType(), True),
          StructField("contract_address", StringType(), True),
          StructField("status", LongType(), True),
          StructField("cumulative_gas_used", LongType(), True),
          StructField("gas_used", LongType(), True),
          StructField("effective_gas_price", LongType(), True),
          StructField("logs_bloom", StringType(), True),
          StructField("logs", StringType(), True),
          StructField("message", StringType(), True)
        ])

