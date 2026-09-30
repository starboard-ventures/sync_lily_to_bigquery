
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_actor_codes import (
  TableActorCodes,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_actor_events import (
  TableActorEvents,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_actor_methods import (
  TableActorMethods,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_actor_states import (
  TableActorStates,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_actors import TableActors
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_block_headers import (
  TableBlockHeaders,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_block_messages import (
  TableBlockMessages,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_block_parents import (
  TableBlockParents,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_builtin_actor_events import (
  TableBuiltinActorEvents,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_chain_consensus import (
  TableChainConsensus,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_chain_economics import (
  TableChainEconomics,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_chain_economics_v2 import (
  TableChainEconomicsV2,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_chain_powers import (
  TableChainPowers,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_chain_reward_streams import (
  TableChainRewardStreams,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_chain_rewards import (
  TableChainRewards,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_data_cap_balances import (
  TableDataCapBalances,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_derived_gas_outputs import (
  TableDerivedGasOutputs,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_drand_block_entries import (
  TableDrandBlockEntries,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_fevm_actor_dumps import (
  TableFevmActorDumps,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_fevm_actor_stats import (
  TableFevmActorStats,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_fevm_block_headers import (
  TableFevmBlockHeaders,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_fevm_contracts import (
  TableFevmContracts,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_fevm_receipts import (
  TableFevmReceipts,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_fevm_traces import (
  TableFevmTraces,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_fevm_transactions import (
  TableFevmTransactions,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_id_addresses import (
  TableIdAddresses,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_internal_messages import (
  TableInternalMessages,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_internal_parsed_messages import (
  TableInternalParsedMessages,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_market_deal_proposals import (
  TableMarketDealProposals,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_market_deal_states import (
  TableMarketDealStates,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_message_gas_economy import (
  TableMessageGasEconomy,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_message_params import (
  TableMessageParams,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_messages import (
  TableMessages,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_miner_actor_dumps import (
  TableMinerActorDumps,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_miner_beneficiaries import (
  TableMinerBeneficiaries,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_miner_cron_fees import (
  TableMinerCronFees,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_miner_current_deadline_infos import (
  TableMinerCurrentDeadlineInfos,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_miner_fee_debts import (
  TableMinerFeeDebts,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_miner_infos import (
  TableMinerInfos,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_miner_locked_funds import (
  TableMinerLockedFunds,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_miner_pre_commit_infos import (
  TableMinerPreCommitInfos,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_miner_pre_commit_infos_v9 import (
  TableMinerPreCommitInfosV9,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_miner_sector_deals import (
  TableMinerSectorDeals,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_miner_sector_deals_v2 import (
  TableMinerSectorDealsV2,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_miner_sector_events import (
  TableMinerSectorEvents,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_miner_sector_infos import (
  TableMinerSectorInfos,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_miner_sector_infos_v7 import (
  TableMinerSectorInfosV7,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_miner_sector_posts import (
  TableMinerSectorPosts,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_multisig_approvals import (
  TableMultisigApprovals,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_multisig_transactions import (
  TableMultisigTransactions,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_parsed_messages import (
  TableParsedMessages,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_power_actor_claims import (
  TablePowerActorClaims,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_receipt_returns import (
  TableReceiptReturns,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_receipts import (
  TableReceipts,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_surveyed_miner_protocols import (
  TableSurveyedMinerProtocols,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_surveyed_peer_agents import (
  TableSurveyedPeerAgents,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_unsynced_block_headers import (
  TableUnsyncedBlockHeaders,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_verified_registry_claims import (
  TableVerifiedRegistryClaims,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_verified_registry_verified_clients import (
  TableVerifiedRegistryVerifiedClients,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_verified_registry_verifiers import (
  TableVerifiedRegistryVerifiers,
)
from sync_lily_from_timescaledb_to_bigquery.data_defs.table_vm_messages import (
  TableVmMessages,
)

LILY_TABLES = {
  "actor_codes"                        : TableActorCodes ,
  "actor_events"                       : TableActorEvents ,
  "actor_methods"                      : TableActorMethods ,
  "actor_states"                       : TableActorStates ,
  "actors"                             : TableActors ,
  "block_headers"                      : TableBlockHeaders ,
  "block_messages"                     : TableBlockMessages ,
  "block_parents"                      : TableBlockParents ,
  "builtin_actor_events"               : TableBuiltinActorEvents ,
  "chain_consensus"                    : TableChainConsensus ,
  "chain_economics"                    : TableChainEconomics ,
  "chain_economics_v2"                 : TableChainEconomicsV2 ,
  "chain_powers"                       : TableChainPowers ,
  "chain_rewards"                      : TableChainRewards ,
  "chain_reward_streams"               : TableChainRewardStreams ,
  "data_cap_balances"                  : TableDataCapBalances ,
  "derived_gas_outputs"                : TableDerivedGasOutputs ,
  "drand_block_entries"                : TableDrandBlockEntries ,
  "fevm_actor_dumps"                   : TableFevmActorDumps ,
  "fevm_actor_stats"                   : TableFevmActorStats ,
  "fevm_block_headers"                 : TableFevmBlockHeaders ,
  "fevm_contracts"                     : TableFevmContracts ,
  "fevm_receipts"                      : TableFevmReceipts ,
  "fevm_traces"                        : TableFevmTraces ,
  "fevm_transactions"                  : TableFevmTransactions ,
  "id_addresses"                       : TableIdAddresses ,
  "internal_messages"                  : TableInternalMessages ,
  "internal_parsed_messages"           : TableInternalParsedMessages ,
  "market_deal_proposals"              : TableMarketDealProposals ,
  "market_deal_states"                 : TableMarketDealStates ,
  "message_gas_economy"                : TableMessageGasEconomy ,
  "message_params"                     : TableMessageParams ,
  "messages"                           : TableMessages ,
  "miner_actor_dumps"                  : TableMinerActorDumps ,
  "miner_beneficiaries"                : TableMinerBeneficiaries ,
  "miner_cron_fees"                    : TableMinerCronFees ,
  "miner_current_deadline_infos"       : TableMinerCurrentDeadlineInfos ,
  "miner_fee_debts"                    : TableMinerFeeDebts ,
  "miner_infos"                        : TableMinerInfos ,
  "miner_locked_funds"                 : TableMinerLockedFunds ,
  "miner_pre_commit_infos"             : TableMinerPreCommitInfos ,
  "miner_pre_commit_infos_v9"          : TableMinerPreCommitInfosV9 ,
  "miner_sector_deals"                 : TableMinerSectorDeals ,
  "miner_sector_deals_v2"              : TableMinerSectorDealsV2 ,
  "miner_sector_events"                : TableMinerSectorEvents ,
  "miner_sector_infos"                 : TableMinerSectorInfos ,
  "miner_sector_infos_v7"              : TableMinerSectorInfosV7 ,
  "miner_sector_posts"                 : TableMinerSectorPosts ,
  "multisig_approvals"                 : TableMultisigApprovals ,
  "multisig_transactions"              : TableMultisigTransactions ,
  "parsed_messages"                    : TableParsedMessages ,
  "power_actor_claims"                 : TablePowerActorClaims ,
  "receipt_returns"                    : TableReceiptReturns ,
  "receipts"                           : TableReceipts ,
  "surveyed_miner_protocols"           : TableSurveyedMinerProtocols ,
  "surveyed_peer_agents"               : TableSurveyedPeerAgents ,
  "unsynced_block_headers"             : TableUnsyncedBlockHeaders ,
  "verified_registry_claims"           : TableVerifiedRegistryClaims ,
  "verified_registry_verified_clients" : TableVerifiedRegistryVerifiedClients ,
  "verified_registry_verifiers"        : TableVerifiedRegistryVerifiers ,
  "vm_messages"                        : TableVmMessages
}

