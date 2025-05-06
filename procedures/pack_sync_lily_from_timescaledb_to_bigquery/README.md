# Synchronize lily tables from TimescaleDB to BigQuery for PL

**Notice: Not all lily tables have data.**

lily table list:

- `actor_codes` (Not run)
- `actor_events` (Not run)
- `actor_methods`
- `actor_states`
- `actors`
- `block_headers`
- `block_messages`
- `block_parents` (Not run)
- `builtin_actor_events`
- `chain_consensus` (Not run)
- `chain_economics`
- `chain_economics_v2`
- `chain_powers`
- `chain_rewards`
- `data_cap_balances`
- `derived_gas_outputs`
- `drand_block_entries`
- `fevm_actor_dumps` (Not run)
- `fevm_actor_stats`
- `fevm_block_headers` (Not run)
- `fevm_contracts` (Not run)
- `fevm_receipts` (Not run)
- `fevm_traces` (Not run)
- `fevm_transactions` (Not run)
- `id_addresses`
- `internal_messages` (Not run)
- `internal_parsed_messages` (Not run)
- `market_deal_proposals`
- `market_deal_states`
- `message_gas_economy`
- `message_params` (Not run)
- `messages`
- `miner_actor_dumps` (Not run)
- `miner_beneficiaries` (Not run)
- `miner_current_deadline_infos` (Not run)
- `miner_fee_debts`
- `miner_infos`
- `miner_locked_funds`
- `miner_pre_commit_infos` (Not run)
- `miner_pre_commit_infos_v9` (Not run)
- `miner_sector_deals` (Not run any more)
- `miner_sector_deals_v2`
- `miner_sector_events`
- `miner_sector_infos` (Not run any more)
- `miner_sector_infos_v7`
- `miner_sector_posts` (Not run)
- `multisig_approvals`
- `multisig_transactions`
- `parsed_messages`
- `power_actor_claims`
- `receipt_returns` (Not run)
- `receipts`
- `surveyed_miner_protocols` (Not run)
- `surveyed_peer_agents` (Not run)
- `unsynced_block_headers` (No need)
- `verified_registry_claims` (Not run)
- `verified_registry_verified_clients` (Not run any more)
- `verified_registry_verifiers`
- `vm_messages`

注意，除了 `message_gas_economy` 和 `power_actor_claims` 外的表，NUMERIC 类型的字段的数据类型，均改为了 STRING 类型。

