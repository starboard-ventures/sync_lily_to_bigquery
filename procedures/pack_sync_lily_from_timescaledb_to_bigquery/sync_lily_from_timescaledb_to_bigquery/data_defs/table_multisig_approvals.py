
import logging

from pyspark.sql.types import *

from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableMultisigApprovals(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super().__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.state_root
               , t.multisig_id
               , t.message
               , t.method
               , t.approver
               , t.threshold
               , t.initial_balance::text  AS initial_balance
               , t.gas_used
               , t.transaction_id
               , t.to
               , t.value::text            AS value
               , t.signers::text          AS signers
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("state_root", StringType(), False),
          StructField("multisig_id", StringType(), False),
          StructField("message", StringType(), False),
          StructField("method", LongType(), False),
          StructField("approver", StringType(), False),
          StructField("threshold", LongType(), False),
          StructField("initial_balance", StringType(), True),
          StructField("gas_used", LongType(), False),
          StructField("transaction_id", LongType(), False),
          StructField("to", StringType(), False),
          StructField("value", StringType(), False),
          StructField("signers", StringType(), False)
        ])

