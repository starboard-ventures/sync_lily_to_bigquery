# Synchronize lily tables from TimescaleDB to BigQuery for PL

**Notice: Not all lily tables have data.**

- Tables marked :white_check_mark: have data.
- Tables marked :black_circle: have historical data and would not refresh.
- Tables marked :heavy_multiplication_x: have not data.
- Tables marked **Not run** do not exist in Starboard too.


## lily table list:

- :heavy_multiplication_x: `actor_codes` (Not run)
- :heavy_multiplication_x: `actor_events` (Not run)
- :white_check_mark: `actor_methods`
- :white_check_mark: `actor_states`
- :white_check_mark: `actors`
- :white_check_mark: `block_headers`
- :white_check_mark: `block_messages`
- :heavy_multiplication_x: `block_parents` (Not run)
- :white_check_mark: `builtin_actor_events`
- :heavy_multiplication_x: `chain_consensus` (Not run)
- :white_check_mark: `chain_economics`
- :white_check_mark: `chain_economics_v2`
- :white_check_mark: `chain_powers`
- :white_check_mark: `chain_rewards`
- :white_check_mark: `data_cap_balances`
- :white_check_mark: `derived_gas_outputs`
- :white_check_mark: `drand_block_entries`
- :heavy_multiplication_x: `fevm_actor_dumps` (Not run)
- :white_check_mark: `fevm_actor_stats`
- :heavy_multiplication_x: `fevm_block_headers` (Not run)
- :heavy_multiplication_x: `fevm_contracts` (Not run)
- :heavy_multiplication_x: `fevm_receipts` (Not run)
- :heavy_multiplication_x: `fevm_traces` (Not run)
- :heavy_multiplication_x: `fevm_transactions` (Not run)
- :white_check_mark: `id_addresses`
- :heavy_multiplication_x: `internal_messages` (Not run)
- :heavy_multiplication_x: `internal_parsed_messages` (Not run)
- :white_check_mark: `market_deal_proposals`
- :white_check_mark: `market_deal_states`
- :white_check_mark: `message_gas_economy`
- :heavy_multiplication_x: `message_params` (Not run)
- :white_check_mark: `messages`
- :heavy_multiplication_x: `miner_actor_dumps` (Not run)
- :heavy_multiplication_x: `miner_beneficiaries` (Not run)
- :heavy_multiplication_x: `miner_current_deadline_infos` (Not run)
- :white_check_mark: `miner_fee_debts`
- :white_check_mark: `miner_infos`
- :white_check_mark: `miner_locked_funds`
- :heavy_multiplication_x: `miner_pre_commit_infos` (Not run)
- :heavy_multiplication_x: `miner_pre_commit_infos_v9` (Not run)
- :black_circle: `miner_sector_deals` (Not run any more)
- :white_check_mark: `miner_sector_deals_v2`
- :white_check_mark: `miner_sector_events`
- :black_circle: `miner_sector_infos` (Not run any more)
- :white_check_mark: `miner_sector_infos_v7`
- :heavy_multiplication_x: `miner_sector_posts` (Not run)
- :white_check_mark: `multisig_approvals`
- :white_check_mark: `multisig_transactions`
- :white_check_mark: `parsed_messages`
- :white_check_mark: `power_actor_claims`
- :heavy_multiplication_x: `receipt_returns` (Not run)
- :white_check_mark: `receipts`
- :heavy_multiplication_x: `surveyed_miner_protocols` (Not run)
- :heavy_multiplication_x: `surveyed_peer_agents` (Not run)
- :heavy_multiplication_x: `unsynced_block_headers` (No need)
- :heavy_multiplication_x: `verified_registry_claims` (Not run)
- :black_circle: `verified_registry_verified_clients` (Not run any more)
- :white_check_mark: `verified_registry_verifiers`
- :white_check_mark: `vm_messages`

注意，除了 `message_gas_economy` 和 `power_actor_claims` 外的表，NUMERIC 类型的字段的数据类型，均改为了 STRING 类型。

