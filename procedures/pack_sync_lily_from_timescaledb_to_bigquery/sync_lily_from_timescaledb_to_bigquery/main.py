# coding=utf-8
import sys
import pkgutil
import logging
from datetime import date
import configparser
import io

from pyspark.sql import SparkSession

from sync_lily_from_timescaledb_to_bigquery.data_defs.tables_to_sync import LILY_TABLES


logFormatter = logging.Formatter('%(asctime)s [%(levelname)s] (%(pathname)s:%(lineno)d@%(funcName)s) -> %(message)s')
logger = logging.getLogger("sync_lily_from_timescaledb_to_bigquery")
logger.setLevel(logging.INFO)

consoleHandler = logging.StreamHandler()
consoleHandler.setFormatter(logFormatter)
logger.addHandler(consoleHandler)


def parse_binary_conf(conf_bin_data):
    conf_loader = configparser.ConfigParser()
    conf_loader.read_file(io.StringIO(conf_bin_data.decode("utf-8")))
    return conf_loader


def base_operations(lily_table_name: str):
    logger.info(f"Table name: {lily_table_name}")

    args = sys.argv
    logger.info(f"Params: {sys.argv}")
    logger.info(f"Params length: {len(sys.argv)}")

    stat_date_str = args[1].strip()
    stat_date = date.fromisoformat(stat_date_str)
    logger.info(f"stat_date = {stat_date}")

    CONFIGFILE_DATA = pkgutil.get_data(__package__, "config.ini")
    config = parse_binary_conf(CONFIGFILE_DATA)

    spark = SparkSession.builder.appName(f"sync_{lily_table_name}_from_timescaledb_to_bigquery").getOrCreate()

    return (spark, config, stat_date)


def simple_run(table_name: str) -> None:
    spark, config, stat_date = base_operations(table_name)
    sync_job_class = LILY_TABLES.get(table_name, None)
    if sync_job_class is None:
        logger.warn(f"Target table {table_name} not found !")
    else:
        logger.info(f"Run stat_date={stat_date} for {table_name}")
        sync_job = sync_job_class(table_name, config)
        height_start, height_end = sync_job.get_height_range(spark, stat_date)
        sync_job.process(spark, height_start, height_end)
    return None


def proc_dummy():
    _, _, _ = base_operations("dummy")
    return None


# Not run
def proc_actor_codes():
    return simple_run("actor_codes")

# Not run
def proc_actor_events():
    return simple_run("actor_events")

def proc_actor_methods():
    return simple_run("actor_methods")

def proc_actor_states():
    return simple_run("actor_states")

def proc_actors():
    return simple_run("actors")

def proc_block_headers():
    return simple_run("block_headers")

def proc_block_messages():
    return simple_run("block_messages")

# Not run
def proc_block_parents():
    return simple_run("block_parents")

def proc_builtin_actor_events():
    return simple_run("builtin_actor_events")

# Not run
def proc_chain_consensus():
    return simple_run("chain_consensus")

def proc_chain_economics():
    return simple_run("chain_economics")

def proc_chain_powers():
    return simple_run("chain_powers")

def proc_chain_rewards():
    return simple_run("chain_rewards")

def proc_data_cap_balances():
    return simple_run("data_cap_balances")

def proc_derived_gas_outputs():
    return simple_run("derived_gas_outputs")

def proc_drand_block_entries():
    return simple_run("drand_block_entries")

# Not run
def proc_fevm_actor_dumps():
    return simple_run("fevm_actor_dumps")

def proc_fevm_actor_stats():
    return simple_run("fevm_actor_stats")

# Not run
def proc_fevm_block_headers():
    return simple_run("fevm_block_headers")

# Not run
def proc_fevm_contracts():
    return simple_run("fevm_contracts")

# Not run
def proc_fevm_receipts():
    return simple_run("fevm_receipts")

# Not run
def proc_fevm_traces():
    return simple_run("fevm_traces")

# Not run
def proc_fevm_transactions():
    return simple_run("fevm_transactions")

def proc_id_addresses():
    return simple_run("id_addresses")

# Not run
def proc_internal_messages():
    return simple_run("internal_messages")

# Not run
def proc_internal_parsed_messages():
    return simple_run("internal_parsed_messages")

def proc_market_deal_proposals():
    return simple_run("market_deal_proposals")

def proc_market_deal_states():
    return simple_run("market_deal_states")

def proc_message_gas_economy():
    return simple_run("message_gas_economy")

# Not run
def proc_message_params():
    return simple_run("message_params")

def proc_messages():
    return simple_run("messages")

# Not run
def proc_miner_actor_dumps():
    return simple_run("miner_actor_dumps")

def proc_miner_beneficiaries():
    return simple_run("miner_beneficiaries")

# Not run
def proc_miner_current_deadline_infos():
    return simple_run("miner_current_deadline_infos")

def proc_miner_fee_debts():
    return simple_run("miner_fee_debts")

def proc_miner_infos():
    return simple_run("miner_infos")

def proc_miner_locked_funds():
    return simple_run("miner_locked_funds")

# Not run
def proc_miner_pre_commit_infos():
    return simple_run("miner_pre_commit_infos")

# Not run
def proc_miner_pre_commit_infos_v9():
    return simple_run("miner_pre_commit_infos_v9")

def proc_miner_sector_deals():
    return simple_run("miner_sector_deals")

def proc_miner_sector_deals_v2():
    return simple_run("miner_sector_deals_v2")

def proc_miner_sector_events():
    return simple_run("miner_sector_events")

def proc_miner_sector_infos():
    return simple_run("miner_sector_infos")

def proc_miner_sector_infos_v7():
    return simple_run("miner_sector_infos_v7")

# Not run
def proc_miner_sector_posts():
    return simple_run("miner_sector_posts")

def proc_multisig_approvals():
    return simple_run("multisig_approvals")

def proc_multisig_transactions():
    return simple_run("multisig_transactions")

def proc_parsed_messages():
    return simple_run("parsed_messages")

def proc_power_actor_claims():
    return simple_run("power_actor_claims")

# Not run
def proc_receipt_returns():
    return simple_run("receipt_returns")

def proc_receipts():
    return simple_run("receipts")

# Not run
def proc_surveyed_miner_protocols():
    return simple_run("surveyed_miner_protocols")

# Not run
def proc_surveyed_peer_agents():
    return simple_run("surveyed_peer_agents")

def proc_unsynced_block_headers():
    return simple_run("unsynced_block_headers")

# Not run
def proc_verified_registry_claims():
    return simple_run("verified_registry_claims")

def proc_verified_registry_verified_clients():
    return simple_run("verified_registry_verified_clients")

def proc_verified_registry_verifiers():
    return simple_run("verified_registry_verifiers")

def proc_vm_messages():
    return simple_run("vm_messages")

