# coding=utf-8

import logging
from pyspark.sql.types import *
from sync_lily_from_timescaledb_to_bigquery.data_defs.lily_table import LilyTable

logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")


class TableMinerActorDumps(LilyTable):

    def __init__(self, table_name: str, config: dict):
        super(TableMinerActorDumps, self).__init__(table_name, config)


    def make_source_data_query(self, height_start: int, height_end: int) -> str:
        return (f"""
          SELECT t.height
               , t.miner_id
               , t.miner_address
               , t.state_root
               , t.owner_id
               , t.owner_address
               , t.worker_id
               , t.worker_address
               , t.consensus_faulted_elapsed
               , t.peer_id
               , t.control_addresses::text     AS control_addresses
               , t.beneficiary
               , t.beneficiary_address
               , t.sector_size
               , t.num_live_sectors
               , t.raw_byte_power::text        AS raw_byte_power
               , t.quality_adj_power::text     AS quality_adj_power
               , t.total_locked_funds::text    AS total_locked_funds
               , t.vesting_funds::text         AS vesting_funds
               , t.initial_pledge::text        AS initial_pledge
               , t.pre_commit_deposits::text   AS pre_commit_deposits
               , t.available_balance::text     AS available_balance
               , t.balance::text               AS balance
               , t.fee_debt::text              AS fee_debt
            FROM {self.pg_table_name} t
           WHERE t.height >= {height_start}
             AND t.height <  {height_end}
        """)


    def make_target_data_schema(self,) -> StructType:
        return StructType([
          StructField("height", LongType(), False),
          StructField("miner_id", StringType(), False),
          StructField("miner_address", StringType(), False),
          StructField("state_root", StringType(), True),
          StructField("owner_id", StringType(), True),
          StructField("owner_address", StringType(), True),
          StructField("worker_id", StringType(), True),
          StructField("worker_address", StringType(), True),
          StructField("consensus_faulted_elapsed", LongType(), True),
          StructField("peer_id", StringType(), True),
          StructField("control_addresses", StringType(), True),
          StructField("beneficiary", StringType(), True),
          StructField("beneficiary_address", StringType(), True),
          StructField("sector_size", LongType(), True),
          StructField("num_live_sectors", LongType(), True),
          StructField("raw_byte_power", StringType(), True),
          StructField("quality_adj_power", StringType(), True),
          StructField("total_locked_funds", StringType(), True),
          StructField("vesting_funds", StringType(), True),
          StructField("initial_pledge", StringType(), True),
          StructField("pre_commit_deposits", StringType(), True),
          StructField("available_balance", StringType(), True),
          StructField("balance", StringType(), True),
          StructField("fee_debt", StringType(), True)
        ])

