-- 为 PL 部署的 lily 表，同步到 BigQuery 。
-- 替换 <project-name> 为实际的 project name 。
-- 替换 <dataset-name> 为实际的 dataset name 。
-- BigQuery 限制每个分区表最多可以有 4,000 个分区。按每30天高度划分，约得333年的分区。


--! not run
DROP TABLE IF EXISTS <project-name>.<dataset-name>.actor_codes ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.actor_codes
(
    cid     STRING     NOT NULL OPTIONS( description = 'CID of the actor from builtin actors.' )
  , code    STRING     NOT NULL OPTIONS( description = 'Human-readable identifier for the actor.' )
  , PRIMARY KEY (cid, code) NOT ENFORCED
)
OPTIONS( description = 'A mapping of a builtin actors CID to a human friendly name.' )
;


--! not run
DROP TABLE IF EXISTS <project-name>.<dataset-name>.actor_events ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.actor_events
(
    height        BIGINT     NOT NULL
  , state_root    STRING     NOT NULL
  , message_cid   STRING     NOT NULL
  , event_index   BIGINT     NOT NULL
  , entry_index   BIGINT     NOT NULL
  , emitter       STRING     NOT NULL
  , flags         STRING     NOT NULL OPTIONS( description = '(The origin data type is BYTEA)' )
  , codec         BIGINT     NOT NULL
  , key           STRING     NOT NULL
  , value         STRING     NOT NULL OPTIONS( description = '(The origin data type is BYTEA)' )
  , PRIMARY KEY (height, state_root, message_cid, event_index, entry_index) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 28944000, 86400))
OPTIONS( description = 'get the chain event from lotus api:  ChainGetEvents returns the events under an event AMT root CID' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.actor_methods ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.actor_methods
(
    family        STRING     NOT NULL OPTIONS( description = 'The actor family.' )
  , method_name   STRING     NOT NULL OPTIONS( description = 'Human-readable identifier for the actor method.' )
  , method        BIGINT     NOT NULL OPTIONS( description = 'Method as bigint.' )
  , PRIMARY KEY (family, method) NOT ENFORCED
)
OPTIONS( description = 'A mapping of a builtin actors CID to a human friendly name.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.actor_states ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.actor_states
(
    height        BIGINT     NOT NULL OPTIONS( description = 'Epoch when this state change happened.' )
  , head          STRING     NOT NULL OPTIONS( description = 'CID of the root of the state tree for the actor.' )
  , code          STRING     NOT NULL OPTIONS( description = 'CID identifier for the type of the actor.' )
  , state         STRING     NOT NULL OPTIONS( description = '(The origin data type is JSONB) Top level of state data.' )
  , address       STRING     NOT NULL
  , PRIMARY KEY (height, head, code, address) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Actor states that were changed at an epoch. Associates actors states as single-level trees with CIDs pointing to complete state tree with the root CID (head) for that actor’s state.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.actors ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.actors
(
    height        BIGINT     NOT NULL OPTIONS( description = 'Epoch when this actor was created or updated.' )
  , id            STRING     NOT NULL OPTIONS( description = 'Actor address.' )
  , state_root    STRING     NOT NULL OPTIONS( description = 'CID of the state root.' )
  , code          STRING     NOT NULL OPTIONS( description = 'Human readable identifier for the type of the actor.' )
  , head          STRING     NOT NULL OPTIONS( description = 'CID of the root of the state tree for the actor.' )
  , nonce         BIGINT     NOT NULL OPTIONS( description = 'The next actor nonce that is expected to appear on chain.' )
  , balance       STRING     NOT NULL OPTIONS( description = 'Actor balance in attoFIL.' )
  , state         STRING              OPTIONS( description = '(The origin data type is JSONB) Top level of state data.' )
  , code_cid      STRING              OPTIONS( description = 'CID identifier for the type of the actor.' )
  , PRIMARY KEY (height, id, state_root) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Actors on chain that were added or updated at an epoch. Associates the actor’s state root CID (head) with the chain state root CID from which it decends. Includes account ID nonce and balance at each state.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.block_headers ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.block_headers
(
    height              BIGINT     NOT NULL OPTIONS( description = 'Epoch when this block was mined.' )
  , cid                 STRING     NOT NULL OPTIONS( description = 'CID of the block.' )
  , parent_weight       STRING     NOT NULL OPTIONS( description = 'Aggregate chain weight of the block’s parent set.' )
  , parent_state_root   STRING     NOT NULL OPTIONS( description = 'CID of the block’s parent state root.' )
  , miner               STRING     NOT NULL OPTIONS( description = 'Address of the miner who mined this block.' )
  , timestamp           BIGINT     NOT NULL OPTIONS( description = 'Time the block was mined in Unix time, the number of seconds elapsed since January 1, 1970 UTC.' )
  , win_count           BIGINT              OPTIONS( description = 'Number of reward units won in this block.' )
  , parent_base_fee     STRING     NOT NULL OPTIONS( description = 'The base fee after executing the parent tipset.' )
  , fork_signaling      BIGINT     NOT NULL OPTIONS( description = 'Flag used as part of signaling forks.' )
  , PRIMARY KEY (height, cid) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Blocks included in tipsets at an epoch.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.block_messages ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.block_messages
(
    height    BIGINT     NOT NULL OPTIONS( description = 'Epoch when the block was mined.' )
  , block     STRING     NOT NULL OPTIONS( description = 'CID of the block that contains the message.' )
  , message   STRING     NOT NULL OPTIONS( description = 'CID of a message in the block.' )
  , PRIMARY KEY (height, block, message) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Message CIDs and the Blocks CID which contain them.' )
;


--! not run
DROP TABLE IF EXISTS <project-name>.<dataset-name>.block_parents ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.block_parents
(
    height  BIGINT     NOT NULL  OPTIONS( description = 'Epoch when the block was mined.' )
  , block   STRING     NOT NULL  OPTIONS( description = 'CID of the block.' )
  , parent  STRING     NOT NULL  OPTIONS( description = 'CID of the parent block.' )
  , PRIMARY KEY (height, block, parent) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Block CIDs to many parent Block CIDs.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.builtin_actor_events ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.builtin_actor_events
(
    height                 BIGINT     NOT NULL OPTIONS( description = 'Epoch when the event was created or updated.' )
  , cid                    STRING     NOT NULL OPTIONS( description = 'Content identifier related to the event.' )
  , emitter                STRING     NOT NULL OPTIONS( description = 'Identifier of the entity that emitted the event.' )
  , event_type             STRING     NOT NULL OPTIONS( description = 'Type or category of the event.' )
  , event_idx              BIGINT     NOT NULL OPTIONS( description = 'Event index at the specific height.' )
  , event_entries          STRING     NOT NULL OPTIONS( description = '(The origin data type is JSONB) JSON array containing entries related to the event.' )
  , event_payload          STRING     NOT NULL OPTIONS( description = '(The origin data type is JSONB) Convert the event_entries into key-value pairs.' )
  , PRIMARY KEY (height, cid, emitter, event_type, event_idx) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Built-in actor events in the Verified Registry, Miner and Market Actors.' )
;


--! not run
DROP TABLE IF EXISTS <project-name>.<dataset-name>.chain_consensus ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.chain_consensus
(
    height             BIGINT  NOT NULL OPTIONS( description = 'Epoch when the blocks were mined in this tipset.' )
  , parent_state_root  STRING  NOT NULL OPTIONS( description = 'CID of the parent tipset state root' )
  , parent_tip_set     STRING  NOT NULL OPTIONS( description = 'CID of the parent tipset' )
  , tip_set            STRING           OPTIONS( description = 'CID of the tipset or NULL_ROUND' )
  , PRIMARY KEY (height, parent_state_root, parent_tip_set) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Hight and TipSet to Parent TipSet or Null Round.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.chain_economics ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.chain_economics
(
    height                BIGINT     NOT NULL OPTIONS( description = 'Epoch of the economic summary.' )
  , parent_state_root     STRING     NOT NULL OPTIONS( description = 'CID of the parent state root.' )
  , circulating_fil       STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) The amount of FIL (attoFIL) circulating and tradeable in the economy. The basis for Market Cap calculations.' )
  , vested_fil            STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Total amount of FIL (attoFIL) that is vested from genesis allocation.' )
  , mined_fil             STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) The amount of FIL (attoFIL) that has been mined by storage miners.' )
  , burnt_fil             STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Total FIL (attoFIL) burned as part of penalties and on-chain computations.' )
  , locked_fil            STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) The amount of FIL (attoFIL) locked as part of mining, deals, and other mechanisms.' )
  , fil_reserve_disbursed STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) The amount of FIL (attoFIL) that has been disbursed from the mining reserve.' )
  , PRIMARY KEY (height, parent_state_root) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Economic summaries per state root CID.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.chain_economics_v2 ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.chain_economics_v2
(
    height                BIGINT     NOT NULL
  , parent_state_root     STRING     NOT NULL
  , circulating_fil_v2    STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC)' )
  , vested_fil            STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC)' )
  , mined_fil             STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC)' )
  , burnt_fil             STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC)' )
  , locked_fil_v2         STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC)' )
  , fil_reserve_disbursed STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC)' )
  , PRIMARY KEY (height, parent_state_root) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.chain_powers ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.chain_powers
(
    height                        BIGINT     NOT NULL OPTIONS( description = 'Epoch this power summary applies to.' )
  , state_root                    STRING     NOT NULL OPTIONS( description = 'CID of the parent state root.' )
  , total_raw_bytes_power         STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Total storage power in bytes in the network. Raw byte power is the size of a sector in bytes.' )
  , total_raw_bytes_committed     STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Total provably committed storage power in bytes. Raw byte power is the size of a sector in bytes.' )
  , total_qa_bytes_power          STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Total quality adjusted storage power in bytes in the network. Quality adjusted power is a weighted average of the quality of its space and it is based on the size, duration and quality of its deals.' )
  , total_qa_bytes_committed      STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Total provably committed, quality adjusted storage power in bytes. Quality adjusted power is a weighted average of the quality of its space and it is based on the size, duration and quality of its deals.' )
  , total_pledge_collateral       STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Total locked FIL (attoFIL) miners have pledged as collateral in order to participate in the economy.' )
  , qa_smoothed_position_estimate STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Total power smoothed position estimate - Alpha Beta Filter "position" (value) estimate in Q.128 format.' )
  , qa_smoothed_velocity_estimate STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Total power smoothed velocity estimate - Alpha Beta Filter "velocity" (rate of change of value) estimate in Q.128 format.' )
  , miner_count                   BIGINT              OPTIONS( description = 'Total number of miners.' )
  , participating_miner_count     BIGINT              OPTIONS( description = 'Total number of miners with power above the minimum miner threshold.' )
  , PRIMARY KEY (height, state_root) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Power summaries from the Power actor.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.chain_rewards ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.chain_rewards
(
    height                                BIGINT     NOT NULL OPTIONS( description = 'Epoch this rewards summary applies to.' )
  , state_root                            STRING     NOT NULL OPTIONS( description = 'CID of the parent state root.' )
  , cum_sum_baseline                      STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Target that CumsumRealized needs to reach for EffectiveNetworkTime to increase. It is measured in byte-epochs (space * time) representing power committed to the network for some duration.' )
  , cum_sum_realized                      STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Cumulative sum of network power capped by BaselinePower(epoch). It is measured in byte-epochs (space * time) representing power committed to the network for some duration.' )
  , effective_baseline_power              STRING              OPTIONS( description = '(The origin data type is NUMERIC) The baseline power (in bytes) at the EffectiveNetworkTime epoch.' )
  , new_baseline_power                    STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) The baseline power (in bytes) the network is targeting.' )
  , new_reward_smoothed_position_estimate STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Smoothed reward position estimate - Alpha Beta Filter "position" (value) estimate in Q.128 format.' )
  , new_reward_smoothed_velocity_estimate STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Smoothed reward velocity estimate - Alpha Beta Filter "velocity" (rate of change of value) estimate in Q.128 format.' )
  , total_mined_reward                    STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) The total FIL (attoFIL) awarded to block miners.' )
  , new_reward                            STRING              OPTIONS( description = '(The origin data type is NUMERIC) The reward to be paid in per WinCount to block producers. The actual reward total paid out depends on the number of winners in any round. This value is recomputed every non-null epoch and used in the next non-null epoch.' )
  , effective_network_time                BIGINT     NOT NULL OPTIONS( description = 'Ceiling of real effective network time "theta" based on CumsumBaselinePower(theta) == CumsumRealizedPower. Theta captures the notion of how much the network has progressed in its baseline and in advancing network time.' )
  , PRIMARY KEY (height, state_root) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Reward summaries from the Reward actor.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.data_cap_balances ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.data_cap_balances
(
    height           BIGINT     NOT NULL OPTIONS( description = 'Epoch when this actors balances map was modified.' )
  , state_root       STRING     NOT NULL OPTIONS( description = 'CID of the parent state root at this epoch.' )
  , address          STRING     NOT NULL OPTIONS( description = 'Address of the actor whose balance was created or modified.' )
  , data_cap         STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Datacap of the actor with address after it was created or modified.' )
  , event            STRING     NOT NULL OPTIONS( description = 'Name of the event that occurred (ADDED, MODIFIED, REMOVED).' )
  , address_type     STRING
  , PRIMARY KEY (height, state_root, address) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'DataCap balances on-chain per each DataCap state change.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.derived_gas_outputs ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.derived_gas_outputs
(
    height                BIGINT     NOT NULL OPTIONS( description = 'Epoch this message was executed at.' )
  , cid                   STRING     NOT NULL OPTIONS( description = 'CID of the message.' )
  , state_root            STRING     NOT NULL OPTIONS( description = 'CID of the parent state root.' )
  , `from`                STRING     NOT NULL OPTIONS( description = 'Address of actor that sent the message.' )
  , `to`                  STRING     NOT NULL OPTIONS( description = 'Address of actor that received the message.' )
  , value                 STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) The FIL value transferred (attoFIL) to the message receiver.' )
  , gas_fee_cap           STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) The maximum price that the message sender is willing to pay per unit of gas.' )
  , gas_premium           STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) The price per unit of gas (measured in attoFIL/gas) that the message sender is willing to pay (on top of the BaseFee) to "tip" the miner that will include this message in a block.' )
  , gas_limit             BIGINT              OPTIONS( description = 'A hard limit on the amount of gas (i.e., number of units of gas) that a message’s execution should be allowed to consume on chain. It is measured in units of gas.' )
  , size_bytes            BIGINT              OPTIONS( description = 'Size in bytes of the serialized message.' )
  , nonce                 BIGINT              OPTIONS( description = 'The message nonce, which protects against duplicate messages and multiple messages with the same values.' )
  , method                BIGINT              OPTIONS( description = 'The method number to invoke. Only unique to the actor the method is being invoked on. A method number of 0 is a plain token transfer - no method exectution.' )
  , exit_code             BIGINT     NOT NULL OPTIONS( description = 'The exit code that was returned as a result of executing the message. Exit code 0 indicates success. Codes 0-15 are reserved for use by the runtime. Codes 16-31 are common codes shared by different actors. Codes 32+ are actor specific.' )
  , gas_used              BIGINT     NOT NULL OPTIONS( description = 'A measure of the amount of resources (or units of gas) consumed, in order to execute a message.' )
  , parent_base_fee       STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) The set price per unit of gas (measured in attoFIL/gas unit) to be burned (sent to an unrecoverable address) for every message execution.' )
  , base_fee_burn         STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) The amount of FIL (in attoFIL) to burn as a result of the base fee. It is parent_base_fee (or gas_fee_cap if smaller) multiplied by gas_used. Note: successful window PoSt messages are not charged this burn.' )
  , over_estimation_burn  STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) The fee to pay (in attoFIL) for overestimating the gas used to execute a message. The overestimated gas to burn (gas_burned) is a portion of the difference between gas_limit and gas_used. The over_estimation_burn value is gas_burned * parent_base_fee.' )
  , miner_penalty         STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Any penalty fees (in attoFIL) the miner incured while executing the message.' )
  , miner_tip             STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) The amount of FIL (in attoFIL) the miner receives for executing the message. Typically it is gas_premium * gas_limit but may be lower if the total fees exceed the gas_fee_cap.' )
  , refund                STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) The amount of FIL (in attoFIL) to refund to the message sender after base fee, miner tip and overestimation amounts have been deducted.' )
  , gas_refund            BIGINT     NOT NULL OPTIONS( description = 'The overestimated units of gas to refund. It is a portion of the difference between gas_limit and gas_used.' )
  , gas_burned            BIGINT     NOT NULL OPTIONS( description = 'The overestimated units of gas to burn. It is a portion of the difference between gas_limit and gas_used.' )
  , actor_name            STRING     NOT NULL OPTIONS( description = 'Human readable identifier for the type of the actor.' )
  , actor_family          STRING     NOT NULL
  , PRIMARY KEY (height, cid, state_root) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Derived gas costs resulting from execution of a message in the VM.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.drand_block_entries ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.drand_block_entries
(
    `round`   BIGINT     NOT NULL OPTIONS( description = 'The round number of the randomness used.' )
  , block     STRING     NOT NULL OPTIONS( description = 'CID of the block.' )
  , PRIMARY KEY (`round`, block) NOT ENFORCED
)
OPTIONS( description = 'Drand randomness round numbers used in each block.' )
;


--! not run
DROP TABLE IF EXISTS <project-name>.<dataset-name>.fevm_actor_dumps ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.fevm_actor_dumps
(

    height          BIGINT     NOT NULL OPTIONS( description = 'Epoch at contract was added or changed.' )
  , actor_id        STRING     NOT NULL OPTIONS( description = 'Actor Filecoin address.' )
  , eth_address     STRING              OPTIONS( description = 'Actor ETH address.' )
  , byte_code       STRING              OPTIONS( description = 'Contract Bytecode. null when actor is ethaccount or placeholder.' )
  , byte_code_hash  STRING              OPTIONS( description = 'Contract Bytecode is encoded in hash by Keccak256. null when actor is ethaccount or placeholder' )
  , balance         STRING              OPTIONS( description = '(The origin data type is NUMERIC) Balance of EVM actor in attoFIL.' )
  , nonce           BIGINT     NOT NULL OPTIONS( description = 'The next actor nonce that is expected to appear on chain.' )
  , actor_name      STRING              OPTIONS( description = 'Human-readable identifier of actor.' )
  , PRIMARY KEY (height, actor_id, nonce) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'The fevm_actor_dumps table serves as a repository for capturing the full dump of the status of various actors associated with the FEVM at specific block heights. These actors encompass three main categories: evm, ethaccount, and placeholder.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.fevm_actor_stats ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.fevm_actor_stats
(
    height                 BIGINT     NOT NULL OPTIONS( description = 'Epoch.' )
  , contract_balance       STRING     NOT NULL OPTIONS( description = 'Balance of EVM actor in attoFIL.' )
  , eth_account_balance    STRING     NOT NULL OPTIONS( description = 'Balance of ETH account actor in attoFIL.' )
  , placeholder_balance    STRING     NOT NULL OPTIONS( description = 'Balance of Placeholder Actor in attoFIL.' )
  , contract_count         BIGINT     NOT NULL OPTIONS( description = 'Number of contracts.' )
  , unique_contract_count  BIGINT     NOT NULL OPTIONS( description = 'Number of unique contracts.' )
  , eth_account_count      BIGINT     NOT NULL OPTIONS( description = 'Number of ETH account actors.' )
  , placeholder_count      BIGINT     NOT NULL OPTIONS( description = 'Number of placeholder actors.' )
  , PRIMARY KEY (height) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'FEVM Actor related statistical data.' )
;


--! not run
DROP TABLE IF EXISTS <project-name>.<dataset-name>.fevm_block_headers ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.fevm_block_headers
(
    height             BIGINT     NOT NULL OPTIONS( description = 'Epoch when this block was mined.' )
  , `hash`             STRING     NOT NULL OPTIONS( description = 'Block hash.' )
  , parent_hash        STRING     NOT NULL OPTIONS( description = 'The hash of the preceding block.' )
  , miner              STRING     NOT NULL OPTIONS( description = 'ETH Address of the miner who mined this block.' )
  , state_root         STRING     NOT NULL OPTIONS( description = 'Block state root ETH hash.' )
  , transactions_root  STRING     NOT NULL OPTIONS( description = 'Set to a hardcoded value which is used by some clients to determine if has no transactions.' )
  , receipts_root      STRING     NOT NULL OPTIONS( description = 'Hash of the transaction receipts trie.' )
  , difficulty         BIGINT              OPTIONS( description = 'ETH mining difficulty.' )
  , `number`           BIGINT              OPTIONS( description = 'The number of the current block.' )
  , gas_limit          BIGINT              OPTIONS( description = 'Maximum gas allowed in this block.' )
  , gas_used           BIGINT              OPTIONS( description = 'The actual amount of gas used in this block.' )
  , `timestamp`        BIGINT              OPTIONS( description = 'The block time.' )
  , extra_data         STRING              OPTIONS( description = 'Arbitrary additional data as raw bytes.' )
  , mix_hash           STRING
  , nonce              STRING
  , base_fee_per_gas   STRING     NOT NULL OPTIONS( description = 'The base fee value.' )
  , `size`             BIGINT              OPTIONS( description = ' Block size.' )
  , sha3_uncles        STRING     NOT NULL
  , PRIMARY KEY (height) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Blocks included in tipsets at an epoch.' )
;


--! not run
DROP TABLE IF EXISTS <project-name>.<dataset-name>.fevm_contracts ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.fevm_contracts
(
    height          BIGINT     NOT NULL OPTIONS( description = 'Epoch at contract was added or changed.' )
  , actor_id        STRING     NOT NULL OPTIONS( description = 'Actor Filecoin address.' )
  , eth_address     STRING              OPTIONS( description = 'Actor ETH address.' )
  , byte_code       STRING              OPTIONS( description = 'Contract Bytecode.' )
  , byte_code_hash  STRING              OPTIONS( description = 'Contract Bytecode is encoded in hash by Keccak256.' )
  , balance         STRING              OPTIONS( description = '(The origin data type is NUMERIC) Balance of EVM actor in attoFIL.' )
  , nonce           BIGINT     NOT NULL OPTIONS( description = 'The next actor nonce that is expected to appear on chain.' )
  , PRIMARY KEY (height, actor_id, nonce) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'The table is designed to maintain a comprehensive record of changes made to contracts in the FEVM system. This table captures both the creation of new contracts and any subsequent updates or modifications made to existing contracts.' )
;


--! not run
DROP TABLE IF EXISTS <project-name>.<dataset-name>.fevm_receipts ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.fevm_receipts
(
    height               BIGINT     NOT NULL OPTIONS( description = 'Epoch when this receipt been created.' )
  , transaction_hash     STRING     NOT NULL OPTIONS( description = 'Hash of transaction.' )
  , transaction_index    BIGINT              OPTIONS( description = 'Integer of the transactions index position in the block.' )
  , block_hash           STRING              OPTIONS( description = 'Hash of the block where this transaction was in.' )
  , block_number         BIGINT              OPTIONS( description = 'Block number where this transaction was in.' )
  , `from`               STRING              OPTIONS( description = 'Address of the sender.' )
  , `to`                 STRING              OPTIONS( description = 'Address of the receiver. null when its a contract creation transaction.' )
  , contract_address     STRING              OPTIONS( description = 'The contract address created, if the transaction was a contract creation, otherwise null.' )
  , status               BIGINT              OPTIONS( description = '0 indicates transaction failure , 1 indicates transaction succeeded.' )
  , cumulative_gas_used  BIGINT              OPTIONS( description = 'The total amount of gas used when this transaction was executed in the block.' )
  , gas_used             BIGINT              OPTIONS( description = 'The actual amount of gas used in this block.' )
  , effective_gas_price  BIGINT              OPTIONS( description = 'The actual value per gas deducted from the senders account.' )
  , logs_bloom           STRING              OPTIONS( description = 'Includes the bloom filter representation of the logs.' )
  , logs                 STRING              OPTIONS( description = '(The origin data type is JSONB) Array of log objects, which this transaction generated.' )
  , message              STRING              OPTIONS( description = 'The cid in filecoin' )
  , PRIMARY KEY (height, transaction_hash) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Data returned by an Ethereum client to represent the result of a particular transaction' )
;


--! not run
DROP TABLE IF EXISTS <project-name>.<dataset-name>.fevm_traces ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.fevm_traces
(
    height                 BIGINT     NOT NULL OPTIONS( description = 'Epoch when this trace been created.' )
  , message_state_root     STRING     NOT NULL OPTIONS( description = 'StateRoot message was applied to.' )
  , message_cid            STRING     NOT NULL OPTIONS( description = 'On-chain message triggering the message.' )
  , transaction_hash       STRING     NOT NULL OPTIONS( description = 'On-chain message ETH transaction hash.' )
  , trace_cid              STRING     NOT NULL OPTIONS( description = 'Cid of the trace.' )
  , `from`                 STRING     NOT NULL OPTIONS( description = 'Address of the sender.' )
  , `to`                   STRING     NOT NULL OPTIONS( description = 'Address of the receiver. null when its a contract creation transaction.' )
  , from_filecoin_address  STRING     NOT NULL OPTIONS( description = 'Filecoin Address of the sender.' )
  , to_filecoin_address    STRING     NOT NULL OPTIONS( description = 'Filecoin Address of the receive.' )
  , value                  STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Value attoFIL contained in message.' )
  , method                 BIGINT     NOT NULL OPTIONS( description = 'Method called on To (receiver).' )
  , parsed_method          STRING     NOT NULL OPTIONS( description = 'Method in readable name.' )
  , actor_code             STRING     NOT NULL OPTIONS( description = 'ActorCode of To (receiver).' )
  , exit_code              BIGINT     NOT NULL OPTIONS( description = 'ExitCode of message execution.' )
  , params                 STRING     NOT NULL OPTIONS( description = 'Params contained in message encode in eth bytes.' )
  , returns                STRING     NOT NULL OPTIONS( description = 'Returns value of message receipt encode in eth bytes.' )
  , `index`                BIGINT     NOT NULL OPTIONS( description = 'Index indicating the order of the messages execution.' )
  , parsed_params          STRING     NOT NULL OPTIONS( description = '(The origin data type is JSONB) Parsed Params contained in message.' )
  , parsed_returns         STRING     NOT NULL OPTIONS( description = '(The origin data type is JSONB) Parsed Returns value of message receipt.' )
  , params_codec           BIGINT     NOT NULL OPTIONS( description = 'Params codec.' )
  , returns_codec          BIGINT     NOT NULL OPTIONS( description = 'Returns codec.' )
  , from_actor_name        STRING     NOT NULL OPTIONS( description = 'Human-readable identifier of sender (From).' )
  , to_actor_name          STRING     NOT NULL OPTIONS( description = 'Human-readable identifier of receiver (To).' )
  , PRIMARY KEY (height, `index`, message_cid) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Messages sent internally through the VM not appearing on chain.' )
;


--! not run
DROP TABLE IF EXISTS <project-name>.<dataset-name>.fevm_transactions ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.fevm_transactions
(
    height                    BIGINT     NOT NULL OPTIONS( description = 'Epoch when this transaction been created.' )
  , `hash`                    STRING     NOT NULL OPTIONS( description = 'Hash of transaction.' )
  , transaction_index         BIGINT              OPTIONS( description = 'Integer of the transactions index position in the block.' )
  , block_hash                STRING              OPTIONS( description = 'Hash of the block where this transaction was in.' )
  , block_number              BIGINT              OPTIONS( description = 'Block number where this transaction was in.' )
  , nonce                     BIGINT              OPTIONS( description = 'A sequentially incrementing counter which indicates the transaction number from the account.' )
  , `from`                    STRING              OPTIONS( description = 'Address of the sender.' )
  , `to`                      STRING              OPTIONS( description = 'Address of the receiver. null when its a contract creation transaction.' )
  , chain_id                  BIGINT              OPTIONS( description = 'EVM network id.' )
  , value                     STRING              OPTIONS( description = 'Amount of attoFIL to transfer from sender to recipient.' )
  , input                     STRING              OPTIONS( description = 'The data sent along with the transaction.' )
  , `type`                    BIGINT              OPTIONS( description = 'Type of transactions.' )
  , gas                       BIGINT              OPTIONS( description = 'Gas provided by the sender.' )
  , max_fee_per_gas           STRING              OPTIONS( description = '(The origin data type is NUMERIC) The maximum fee per unit of gas willing to be paid for the transaction.' )
  , max_priority_fee_per_gas  STRING              OPTIONS( description = '(The origin data type is NUMERIC) The maximum price of the consumed gas to be included as a tip to the validator.' )
  , v                         STRING              OPTIONS( description = 'Transaction’s signature. Recovery Identifier.' )
  , r                         STRING              OPTIONS( description = 'Transaction’s signature. Outputs of an ECDSA signature.' )
  , s                         STRING              OPTIONS( description = 'Transaction’s signature. Putputs of an ECDSA signature.' )
  , from_filecoin_address     STRING              OPTIONS( description = 'Filecoin Address of the sender.' )
  , to_filecoin_address       STRING              OPTIONS( description = 'Filecoin Address of the receiver.' )
  , from_actor_name           STRING              OPTIONS( description = 'Human-readable identifier of sender (From).' )
  , to_actor_name             STRING              OPTIONS( description = 'Human-readable identifier of receiver (To).' )
  , message_cid               STRING              OPTIONS( description = 'On-chain message cid.' )
  , access_list               STRING              OPTIONS( description = '(The origin data type is JSONB)' )
  , PRIMARY KEY (height, `hash`) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Transactions, which change the state of the EVM, need to be broadcast to the whole network.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.id_addresses ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.id_addresses
(
    height           BIGINT     NOT NULL OPTIONS( description = 'Epoch at which this address mapping was added.' )
  , id               STRING     NOT NULL OPTIONS( description = 'ID of the actor.' )
  , address          STRING     NOT NULL OPTIONS( description = 'Robust address of the actor.' )
  , state_root       STRING     NOT NULL OPTIONS( description = 'CID of the parent state root at which this address mapping was added.' )
  , PRIMARY KEY (height, id, address, state_root) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Mapping of IDs to robust addresses from the init actor’s state.' )
;


--! not run
DROP TABLE IF EXISTS <project-name>.<dataset-name>.internal_messages ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.internal_messages
(
    height          BIGINT     NOT NULL OPTIONS( description = 'Epoch this message was executed at.' )
  , cid             STRING     NOT NULL OPTIONS( description = 'CID of the message.' )
  , state_root      STRING     NOT NULL OPTIONS( description = 'CID of the parent state root at which this message was executed.' )
  , source_message  STRING     NOT NULL OPTIONS( description = 'CID of the message that caused this message to be sent.' )
  , `from`          STRING     NOT NULL OPTIONS( description = 'Address of the actor that sent the message.' )
  , `to`            STRING     NOT NULL OPTIONS( description = 'Address of the actor that received the message.' )
  , value           STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Amount of FIL (in attoFIL) transferred by this message.' )
  , method          BIGINT     NOT NULL OPTIONS( description = 'The method number invoked on the recipient actor. Only unique to the actor the method is being invoked on. A method number of 0 is a plain token transfer - no method exectution.' )
  , actor_name      STRING     NOT NULL OPTIONS( description = 'The full versioned name of the actor that received the message (for example fil/3/storagepower).' )
  , actor_family    STRING     NOT NULL OPTIONS( description = 'The short unversioned name of the actor that received the message (for example storagepower).' )
  , exit_code       BIGINT     NOT NULL OPTIONS( description = 'The exit code that was returned as a result of executing the message. Exit code 0 indicates success. Codes 0-15 are reserved for use by the runtime. Codes 16-31 are common codes shared by different actors. Codes 32+ are actor specific.' )
  , gas_used        BIGINT     NOT NULL OPTIONS( description = 'A measure of the amount of resources (or units of gas) consumed, in order to execute a message.' )
  , PRIMARY KEY (height, cid) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Messages generated implicitly by system actors and by using the runtime send method.' )
;


--! not run
DROP TABLE IF EXISTS <project-name>.<dataset-name>.internal_parsed_messages ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.internal_parsed_messages
(
    height    BIGINT     NOT NULL OPTIONS( description = 'Epoch this message was executed at.' )
  , cid       STRING     NOT NULL OPTIONS( description = 'CID of the message.' )
  , `from`    STRING     NOT NULL OPTIONS( description = 'Address of the actor that sent the message.' )
  , `to`      STRING     NOT NULL OPTIONS( description = 'Address of the actor that received the message.' )
  , value     STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Amount of FIL (in attoFIL) transferred by this message.' )
  , method    STRING     NOT NULL OPTIONS( description = 'The method number invoked on the recipient actor. Only unique to the actor the method is being invoked on. A method number of 0 is a plain token transfer - no method exectution.' )
  , params    STRING     NOT NULL OPTIONS( description = '(The origin data type is JSONB) Method parameters parsed and serialized as a JSON object.' )
  , PRIMARY KEY (height, cid) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Internal messages parsed to extract useful information.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.market_deal_proposals ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.market_deal_proposals
(
    height                  BIGINT     NOT NULL OPTIONS( description = 'Epoch at which this deal proposal was added or changed.' )
  , deal_id                 BIGINT     NOT NULL OPTIONS( description = 'Identifier for the deal.' )
  , state_root              STRING     NOT NULL OPTIONS( description = 'CID of the parent state root for this deal.' )
  , piece_cid               STRING     NOT NULL OPTIONS( description = 'CID of a sector piece. A Piece is an object that represents a whole or part of a File.' )
  , padded_piece_size       BIGINT     NOT NULL OPTIONS( description = 'The piece size in bytes with padding.' )
  , unpadded_piece_size     BIGINT     NOT NULL OPTIONS( description = 'The piece size in bytes without padding.' )
  , is_verified             BOOLEAN    NOT NULL OPTIONS( description = 'Deal is with a verified provider.' )
  , client_id               STRING     NOT NULL OPTIONS( description = 'Address of the actor proposing the deal.' )
  , provider_id             STRING     NOT NULL OPTIONS( description = 'Address of the actor providing the services.' )
  , start_epoch             BIGINT     NOT NULL OPTIONS( description = 'The epoch at which this deal with begin. Storage deal must appear in a sealed (proven) sector no later than start_epoch, otherwise it is invalid.' )
  , end_epoch               BIGINT     NOT NULL OPTIONS( description = 'The epoch at which this deal with end.' )
  , slashed_epoch           BIGINT              OPTIONS( description = 'The epoch at which this deal was slashed or null.' )
  , storage_price_per_epoch STRING     NOT NULL OPTIONS( description = 'The amount of FIL (in attoFIL) that will be transferred from the client to the provider every epoch this deal is active for.' )
  , provider_collateral     STRING     NOT NULL OPTIONS( description = 'The amount of FIL (in attoFIL) the provider has pledged as collateral. The Provider deal collateral is only slashed when a sector is terminated before the deal expires.' )
  , client_collateral       STRING     NOT NULL OPTIONS( description = 'The amount of FIL (in attoFIL) the client has pledged as collateral.' )
  , label                   STRING              OPTIONS( description = 'An arbitrary client chosen label to apply to the deal.' )
  , PRIMARY KEY (height, deal_id) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'All storage deal states with latest values applied to end_epoch when updates are detected on- chain.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.market_deal_states ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.market_deal_states
(
    height             BIGINT     NOT NULL OPTIONS( description = 'Epoch at which this deal was added or changed.' )
  , deal_id            BIGINT     NOT NULL OPTIONS( description = 'Identifier for the deal.' )
  , state_root         STRING     NOT NULL OPTIONS( description = 'CID of the parent state root for this deal.' )
  , sector_start_epoch BIGINT     NOT NULL OPTIONS( description = 'Epoch this deal was included in a proven sector. -1 if not yet included in proven sector.' )
  , last_update_epoch  BIGINT     NOT NULL OPTIONS( description = 'Epoch this deal was last updated at. -1 if deal state never updated.' )
  , slash_epoch        BIGINT     NOT NULL OPTIONS( description = 'Epoch this deal was slashed at. -1 if deal was never slashed.' )
  , PRIMARY KEY (height, deal_id, state_root) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'All storage deal state transitions detected on-chain.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.message_gas_economy ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.message_gas_economy
(
    height                  BIGINT     NOT NULL OPTIONS( description = 'Epoch these economics apply to.' )
  , state_root              STRING     NOT NULL OPTIONS( description = 'CID of the parent state root at this epoch.' )
  , gas_limit_total         STRING     NOT NULL OPTIONS( description = 'The sum of all the gas limits.' )
  , gas_limit_unique_total  STRING              OPTIONS( description = 'The sum of all the gas limits of unique messages.' )
  , base_fee                STRING     NOT NULL OPTIONS( description = 'The set price per unit of gas (measured in attoFIL/gas unit) to be burned (sent to an unrecoverable address) for every message execution.' )
  , base_fee_change_log     FLOAT64    NOT NULL OPTIONS( description = 'The logarithm of the change between new and old base fee.' )
  , gas_fill_ratio          FLOAT64             OPTIONS( description = 'The gas_limit_total / target gas limit total for all blocks.' )
  , gas_capacity_ratio      FLOAT64             OPTIONS( description = 'The gas_limit_unique_total / target gas limit total for all blocks.' )
  , gas_waste_ratio         FLOAT64             OPTIONS( description = '(gas_limit_total - gas_limit_unique_total) / target gas limit total for all blocks.' )
  , PRIMARY KEY (height, state_root) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Gas economics for all messages in all blocks at each epoch.' )
;


--! not run
DROP TABLE IF EXISTS <project-name>.<dataset-name>.message_params ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.message_params
(
    cid        STRING     NOT NULL OPTIONS( description = 'The CID of a message.' )
  , params     STRING     NOT NULL OPTIONS( description = '(The origin data type is BYTEA) The parameters of the message as bytes.' )
  , PRIMARY KEY (cid) NOT ENFORCED
)
OPTIONS( description = 'Raw parameters of on chain messages.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.messages ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.messages
(
    height        BIGINT     NOT NULL OPTIONS( description = 'Epoch this message was executed at.' )
  , cid           STRING     NOT NULL OPTIONS( description = 'CID of the message.' )
  , `from`        STRING     NOT NULL OPTIONS( description = 'Address of the actor that sent the message.' )
  , `to`          STRING     NOT NULL OPTIONS( description = 'Address of the actor that received the message.' )
  , size_bytes    BIGINT     NOT NULL OPTIONS( description = 'Size of the serialized message in bytes.' )
  , nonce         BIGINT     NOT NULL OPTIONS( description = 'The message nonce, which protects against duplicate messages and multiple messages with the same values.' )
  , value         STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Amount of FIL (in attoFIL) transferred by this message.' )
  , gas_fee_cap   STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) The maximum price that the message sender is willing to pay per unit of gas.' )
  , gas_premium   STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) The price per unit of gas (measured in attoFIL/gas) that the message sender is willing to pay (on top of the BaseFee) to "tip" the miner that will include this message in a block.' )
  , gas_limit     BIGINT     NOT NULL OPTIONS( description = 'The upper bound unit of gas set on the computation required to process the message.' )
  , method        BIGINT     NOT NULL OPTIONS( description = 'The method number invoked on the recipient actor. Only unique to the actor the method is being invoked on. A method number of 0 is a plain token transfer - no method exectution.' )
  , PRIMARY KEY (height, cid) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Validated on-chain messages by their CID and their metadata.' )
;


--! not run
DROP TABLE IF EXISTS <project-name>.<dataset-name>.miner_actor_dumps ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.miner_actor_dumps
(
    height                      BIGINT     NOT NULL OPTIONS( description = 'Epoch' )
  , miner_id                    STRING     NOT NULL OPTIONS( description = 'Address of the miner.' )
  , miner_address               STRING     NOT NULL OPTIONS( description = 'Robust Address of the miner.' )
  , state_root                  STRING              OPTIONS( description = 'CID of the parent state root.' )
  , owner_id                    STRING              OPTIONS( description = 'Address of actor designated as the owner. The owner address is the address that created the miner, paid the collateral, and has block rewards paid out to it.' )
  , owner_address               STRING              OPTIONS( description = 'Robust Address of actor designated as the owner.' )
  , worker_id                   STRING              OPTIONS( description = 'Address of actor designated as the worker.' )
  , worker_address              STRING              OPTIONS( description = 'Robust Address of actor designated as the worker.' )
  , consensus_faulted_elapsed   BIGINT              OPTIONS( description = 'The next epoch this miner is eligible for certain permissioned actor methods and winning block elections as a result of being reported for a consensus fault.' )
  , peer_id                     STRING              OPTIONS( description = 'Current libp2p Peer ID of the miner.' )
  , control_addresses           STRING              OPTIONS( description = '(The origin data type is JSONB) JSON array of control addresses. Control addresses are used to submit WindowPoSts proofs to the chain.' )
  , beneficiary                 STRING              OPTIONS( description = 'Address of the beneficiary. The beneficiary is set to the same address of Owner when initiating a miner without specifying a beneficiary address (for back-compatibility).' )
  , beneficiary_address         STRING              OPTIONS( description = 'Robust Address of the beneficiary.' )
  , sector_size                 BIGINT              OPTIONS( description = 'Size of a sector.' )
  , num_live_sectors            BIGINT              OPTIONS( description = 'The number of live sectors.' )
  , raw_byte_power              STRING              OPTIONS( description = '(The origin data type is NUMERIC) The storage power in bytes.' )
  , quality_adj_power           STRING              OPTIONS( description = '(The origin data type is NUMERIC) The quality adjusted storage power in bytes.' )
  , total_locked_funds          STRING              OPTIONS( description = '(The origin data type is NUMERIC) vesting funds + initial pledge + PreCommit deposits.' )
  , vesting_funds               STRING              OPTIONS( description = '(The origin data type is NUMERIC) Amount of FIL (in attoFIL) locked due to vesting.' )
  , initial_pledge              STRING              OPTIONS( description = '(The origin data type is NUMERIC) Amount of FIL (in attoFIL) locked due to it being pledged as collateral. When a Miner ProveCommits a Sector, they must supply an “initial pledge” for the Sector, which acts as collateral.' )
  , pre_commit_deposits         STRING              OPTIONS( description = '(The origin data type is NUMERIC) Amount of FIL (in attoFIL) locked due to it being used as a PreCommit deposit. When a Miner PreCommits a Sector, they must supply a “precommit deposit” for the Sector, which acts as collateral.' )
  , available_balance           STRING              OPTIONS( description = '(The origin data type is NUMERIC) balance - total_locked_funds.' )
  , balance                     STRING              OPTIONS( description = '(The origin data type is NUMERIC) Miner balance in attoFIL.' )
  , fee_debt                    STRING              OPTIONS( description = '(The origin data type is NUMERIC) Absolute value of debt this miner owes from unpaid fees in attoFIL.' )
  , termination_fee             STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) A penalty imposed when a sector is prematurely terminated in attoFIL.' )
  , daily_fee                   STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Sum of daily fee payable of miner active sectors.' )
  , termination_fee_v2          STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) A penalty imposed when a sector is prematurely terminated in attoFIL (after nv25).' )
  , PRIMARY KEY (height, miner_id, miner_address) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'The miner_actor_dumps table serves as a repository for capturing the full dump of the status of miner at specific block heights.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.miner_beneficiaries ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.miner_beneficiaries
(
    height                   BIGINT     NOT NULL OPTIONS( description = 'Epoch at which this beneficiary was added or change.' )
  , state_root               STRING     NOT NULL OPTIONS( description = 'CID of the parent state root at which this beneficiary was added or change.' )
  , miner_id                 STRING     NOT NULL OPTIONS( description = 'Address of the miner this beneficiary relates to.' )
  , beneficiary              STRING     NOT NULL OPTIONS( description = 'Address of the beneficiary. The beneficiary is set to the same address of Owner when initiating a miner without specifying a beneficiary address (for back-compatibility).' )
  , quota                    STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Quota of the beneficiary.' )
  , used_quota               STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Quota currently used by the beneficiary.' )
  , expiration               BIGINT     NOT NULL OPTIONS( description = 'Epoch at which the beneficiary expired.' )
  , new_beneficiary          STRING              OPTIONS( description = 'Address of a proposed beneficiary.' )
  , new_quota                STRING              OPTIONS( description = '(The origin data type is NUMERIC) Quota of proposed beneficiary.' )
  , new_expiration           BIGINT              OPTIONS( description = 'Expiration epoch of proposed beneficiary.' )
  , approved_by_beneficiary  BOOLEAN             OPTIONS( description = 'If new_beneficiary, new_quota and new_expiration are approved by beneficiary.' )
  , approved_by_nominee      BOOLEAN             OPTIONS( description = 'If new_beneficiary, new_quota and new_expiration are approved by nominee.' )
  , PRIMARY KEY (height, miner_id, state_root) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
;


--! not run
DROP TABLE IF EXISTS <project-name>.<dataset-name>.miner_current_deadline_infos ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.miner_current_deadline_infos
(
    height          BIGINT     NOT NULL OPTIONS( description = 'Epoch at which this info was calculated.' )
  , miner_id        STRING     NOT NULL OPTIONS( description = 'Address of the miner this info relates to.' )
  , state_root      STRING     NOT NULL OPTIONS( description = 'CID of the parent state root at this epoch.' )
  , deadline_index  BIGINT     NOT NULL OPTIONS( description = 'A deadline index, in [0..d.WPoStProvingPeriodDeadlines) unless period elapsed.' )
  , period_start    BIGINT     NOT NULL OPTIONS( description = 'First epoch of the proving period (<= CurrentEpoch).' )
  , `open`          BIGINT     NOT NULL OPTIONS( description = 'First epoch from which a proof may be submitted (>= CurrentEpoch).' )
  , `close`         BIGINT     NOT NULL OPTIONS( description = 'First epoch from which a proof may no longer be submitted (>= Open).' )
  , challenge       BIGINT     NOT NULL OPTIONS( description = 'Epoch at which to sample the chain for challenge (< Open).' )
  , fault_cutoff    BIGINT     NOT NULL OPTIONS( description = 'First epoch at which a fault declaration is rejected (< Open).' )
  , PRIMARY KEY (height, miner_id, state_root) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Deadline refers to the window during which proofs may be submitted.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.miner_fee_debts ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.miner_fee_debts
(
    height          BIGINT     NOT NULL OPTIONS( description = 'Epoch at which this debt applies.' )
  , miner_id        STRING     NOT NULL OPTIONS( description = 'Address of the miner that owes fees.' )
  , state_root      STRING     NOT NULL OPTIONS( description = 'CID of the parent state root at this epoch.' )
  , fee_debt        STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Absolute value of debt this miner owes from unpaid fees in attoFIL.' )
  , PRIMARY KEY (height, miner_id, state_root) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Miner debts per epoch from unpaid fees.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.miner_infos ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.miner_infos
(
    height                     BIGINT     NOT NULL OPTIONS( description = 'Epoch at which this miner info was added/changed.' )
  , miner_id                   STRING     NOT NULL OPTIONS( description = 'Address of miner this info applies to.' )
  , state_root                 STRING     NOT NULL OPTIONS( description = 'CID of the parent state root at this epoch.' )
  , owner_id                   STRING     NOT NULL OPTIONS( description = 'Address of actor designated as the owner. The owner address is the address that created the miner, paid the collateral, and has block rewards paid out to it.' )
  , worker_id                  STRING     NOT NULL OPTIONS( description = 'Address of actor designated as the worker. The worker is responsible for doing all of the work, submitting proofs, committing new sectors, and all other day to day activities.' )
  , new_worker                 STRING              OPTIONS( description = 'Address of a new worker address that will become effective at worker_change_epoch.' )
  , worker_change_epoch        BIGINT     NOT NULL OPTIONS( description = 'Epoch at which a new_worker address will become effective.' )
  , consensus_faulted_elapsed  BIGINT     NOT NULL OPTIONS( description = 'The next epoch this miner is eligible for certain permissioned actor methods and winning block elections as a result of being reported for a consensus fault.' )
  , peer_id                    STRING              OPTIONS( description = 'Current libp2p Peer ID of the miner.' )
  , control_addresses          STRING              OPTIONS( description = '(The origin data type is JSONB) JSON array of control addresses. Control addresses are used to submit WindowPoSts proofs to the chain. WindowPoSt is the mechanism through which storage is verified in Filecoin and is required by miners to submit proofs for all sectors every 24 hours. Those proofs are submitted as messages to the blockchain and therefore need to pay the respective fees.' )
  , multi_addresses            STRING              OPTIONS( description = '(The origin data type is JSONB) JSON array of multiaddrs at which this miner can be reached.' )
  , sector_size                BIGINT     NOT NULL OPTIONS( description = 'The sector size used by this miner.' )
  , PRIMARY KEY (height, miner_id, state_root) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Miner Account IDs for all associated addresses plus peer ID. See https://lotus.filecoin.io/storage-providers/operate/addresses/ for more information.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.miner_locked_funds ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.miner_locked_funds
(
    height               BIGINT     NOT NULL OPTIONS( description = 'Epoch at which these details were added/changed.' )
  , miner_id             STRING     NOT NULL OPTIONS( description = 'Address of the miner these details apply to.' )
  , state_root           STRING     NOT NULL OPTIONS( description = 'CID of the parent state root at this epoch.' )
  , locked_funds         STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Amount of FIL (in attoFIL) locked due to vesting. When a Miner receives tokens from block rewards, the tokens are locked and added to the Miner’s vesting table to be unlocked linearly over some future epochs.' )
  , initial_pledge       STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Amount of FIL (in attoFIL) locked due to it being pledged as collateral. When a Miner ProveCommits a Sector, they must supply an "initial pledge" for the Sector, which acts as collateral. If the Sector is terminated, this deposit is removed and burned along with rewards earned by this sector up to a limit.' )
  , pre_commit_deposits  STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Amount of FIL (in attoFIL) locked due to it being used as a PreCommit deposit. When a Miner PreCommits a Sector, they must supply a "precommit deposit" for the Sector, which acts as collateral. If the Sector is not ProveCommitted on time, this deposit is removed and burned.' )
  , PRIMARY KEY (height, miner_id, state_root) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Details of Miner funds locked and unavailable for use.' )
;


--! not run
DROP TABLE IF EXISTS <project-name>.<dataset-name>.miner_pre_commit_infos ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.miner_pre_commit_infos
(
    height                    BIGINT     NOT NULL OPTIONS( description = 'Epoch this PreCommit information was added/changed.' )
  , miner_id                  STRING     NOT NULL OPTIONS( description = 'Address of the miner who owns the sector.' )
  , sector_id                 BIGINT     NOT NULL OPTIONS( description = 'Numeric identifier for the sector.' )
  , state_root                STRING     NOT NULL OPTIONS( description = 'CID of the parent state root at this epoch.' )
  , sealed_cid                STRING     NOT NULL OPTIONS( description = 'CID of the sealed sector.' )
  , seal_rand_epoch           BIGINT              OPTIONS( description = 'Seal challenge epoch. Epoch at which randomness should be drawn to tie Proof-of-Replication to a chain.' )
  , expiration_epoch          BIGINT              OPTIONS( description = 'Epoch this sector expires.' )
  , pre_commit_deposit        STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Amount of FIL (in attoFIL) used as a PreCommit deposit. If the Sector is not ProveCommitted on time, this deposit is removed and burned.' )
  , pre_commit_epoch          BIGINT     NOT NULL OPTIONS( description = 'Epoch this PreCommit was created.' )
  , deal_weight               STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Total space*time of submitted deals.' )
  , verified_deal_weight      STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Total space*time of submitted verified deals.' )
  , is_replace_capacity       BOOLEAN    NOT NULL OPTIONS( description = 'Whether to replace a "committed capacity" no-deal sector (requires non-empty DealIDs).' )
  , replace_sector_deadline   BIGINT              OPTIONS( description = 'The deadline location of the sector to replace.' )
  , replace_sector_partition  BIGINT              OPTIONS( description = 'The partition location of the sector to replace.' )
  , replace_sector_number     BIGINT              OPTIONS( description = 'ID of the committed capacity sector to replace.' )
  , PRIMARY KEY (height, miner_id, sector_id, state_root) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Information on sector PreCommits.' )
;


--! not run
DROP TABLE IF EXISTS <project-name>.<dataset-name>.miner_pre_commit_infos_v9 ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.miner_pre_commit_infos_v9
(
    height              BIGINT     NOT NULL OPTIONS( description = 'Epoch this PreCommit information was added/changed.' )
  , miner_id            STRING     NOT NULL OPTIONS( description = 'Address of the miner who owns the sector.' )
  , sector_id           BIGINT     NOT NULL OPTIONS( description = 'Numeric identifier for the sector.' )
  , state_root          STRING     NOT NULL OPTIONS( description = 'CID of the parent state root at this epoch.' )
  , pre_commit_deposit  STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Amount of FIL (in attoFIL) used as a PreCommit deposit. If the Sector is not ProveCommitted on time, this deposit is removed and burned.' )
  , pre_commit_epoch    BIGINT     NOT NULL OPTIONS( description = 'Epoch this PreCommit was created.' )
  , sealed_cid          STRING     NOT NULL OPTIONS( description = 'CID of the sealed sector.' )
  , seal_rand_epoch     BIGINT     NOT NULL OPTIONS( description = 'Seal challenge epoch. Epoch at which randomness should be drawn to tie Proof-of-Replication to a chain.' )
  , expiration_epoch    BIGINT     NOT NULL OPTIONS( description = 'Epoch this sector expires.' )
  , deal_ids            ARRAY<INT64>
  , unsealed_cid        STRING       
  , PRIMARY KEY (height, miner_id, sector_id, state_root) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Information on sector PreCommits for actors v9+ and above.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.miner_sector_deals ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.miner_sector_deals
(
    height           BIGINT     NOT NULL OPTIONS( description = 'Epoch at which this deal was added/updated.' )
  , miner_id         STRING     NOT NULL OPTIONS( description = 'Address of the miner the deal is with.' )
  , sector_id        BIGINT     NOT NULL OPTIONS( description = 'Numeric identifier of the sector the deal is for.' )
  , deal_id          BIGINT     NOT NULL OPTIONS( description = 'Numeric identifier for the deal.' )
  , PRIMARY KEY (height, miner_id, sector_id, deal_id) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Mapping of Deal IDs to their respective Miner and Sector IDs.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.miner_sector_deals_v2 ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.miner_sector_deals_v2
(
    height           BIGINT     NOT NULL OPTIONS( description = 'Epoch at which this deal was added/updated.' )
  , miner_id         STRING     NOT NULL OPTIONS( description = 'Address of the miner the deal is with.' )
  , sector_id        BIGINT     NOT NULL OPTIONS( description = 'Numeric identifier of the sector the deal is for.' )
  , deal_id          BIGINT     NOT NULL OPTIONS( description = 'Numeric identifier for the deal.' )
  , PRIMARY KEY (height, miner_id, sector_id, deal_id) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Mapping of Deal IDs to their respective Miner and Sector IDs. Start from height 3855361' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.miner_sector_events ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.miner_sector_events
(
    height           BIGINT     NOT NULL OPTIONS( description = 'Epoch at which this event occurred.' )
  , sector_id        BIGINT     NOT NULL OPTIONS( description = 'Numeric identifier of the sector.' )
  , event            STRING     NOT NULL OPTIONS( description = 'Name of the event that occurred.' )
  , miner_id         STRING     NOT NULL OPTIONS( description = 'Address of the miner who owns the sector.' )
  , state_root       STRING     NOT NULL OPTIONS( description = 'CID of the parent state root at this epoch.' )
  , PRIMARY KEY (height, sector_id, event, miner_id, state_root) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Sector events on-chain per Miner/Sector.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.miner_sector_infos ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.miner_sector_infos
(
    height                   BIGINT     NOT NULL OPTIONS( description = 'Epoch at which this sector info was added/updated.' )
  , miner_id                 STRING     NOT NULL OPTIONS( description = 'Address of the miner who owns the sector.' )
  , sector_id                BIGINT     NOT NULL OPTIONS( description = 'Numeric identifier of the sector.' )
  , state_root               STRING     NOT NULL OPTIONS( description = 'CID of the parent state root at this epoch.' )
  , sealed_cid               STRING     NOT NULL OPTIONS( description = 'The root CID of the Sealed Sector’s merkle tree. Also called CommR, or "replica commitment".' )
  , activation_epoch         BIGINT              OPTIONS( description = 'Epoch during which the sector proof was accepted.' )
  , expiration_epoch         BIGINT              OPTIONS( description = 'Epoch during which the sector expires.' )
  , deal_weight              STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Integral of active deals over sector lifetime.' )
  , verified_deal_weight     STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Integral of active verified deals over sector lifetime.' )
  , initial_pledge           STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Pledge collected to commit this sector (in attoFIL).' )
  , expected_day_reward      STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Expected one day projection of reward for sector computed at activation time (in attoFIL).' )
  , expected_storage_pledge  STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Expected twenty day projection of reward for sector computed at activation time (in attoFIL).' )
  , PRIMARY KEY (height, miner_id, sector_id, state_root) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Latest state of sectors by Miner.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.miner_sector_infos_v7 ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.miner_sector_infos_v7
(
    height                   BIGINT     NOT NULL OPTIONS( description = 'Epoch at which this sector info was added/updated.' )
  , miner_id                 STRING     NOT NULL OPTIONS( description = 'Address of the miner who owns the sector.' )
  , sector_id                BIGINT     NOT NULL OPTIONS( description = 'Numeric identifier of the sector.' )
  , state_root               STRING     NOT NULL OPTIONS( description = 'CID of the parent state root at this epoch.' )
  , sealed_cid               STRING     NOT NULL OPTIONS( description = 'The root CID of the Sealed Sector’s merkle tree. Also called CommR, or "replica commitment".' )
  , activation_epoch         BIGINT              OPTIONS( description = 'Epoch during which the sector proof was accepted.' )
  , expiration_epoch         BIGINT              OPTIONS( description = 'Epoch during which the sector expires.' )
  , deal_weight              STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Integral of active deals over sector lifetime.' )
  , verified_deal_weight     STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Integral of active verified deals over sector lifetime.' )
  , initial_pledge           STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Pledge collected to commit this sector (in attoFIL).' )
  , expected_day_reward      STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Expected one day projection of reward for sector computed at activation time (in attoFIL).' )
  , expected_storage_pledge  STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Expected twenty day projection of reward for sector computed at activation time (in attoFIL).' )
  , sector_key_cid           STRING              OPTIONS( description = 'SealedSectorCID is set when CC sector is snapped.' )
  , replaced_day_reward      STRING              OPTIONS( description = 'Day reward of this sector before its power was most recently updated (in attoFIL).' )
  , power_base_epoch         BIGINT              OPTIONS( description = 'Epoch at which this sector’s power was most recently updated.' )
  , daily_fee                STRING              OPTIONS( description = '(The origin data type is NUMERIC) The total fee payable per day for this sector.' )
  , PRIMARY KEY (height, miner_id, sector_id, state_root) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Latest state of sectors by Miner for actors v7 and above.' )
;


--! not run
DROP TABLE IF EXISTS <project-name>.<dataset-name>.miner_sector_posts ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.miner_sector_posts
(
    height            BIGINT     NOT NULL OPTIONS( description = 'Epoch at which this PoSt message was executed.' )
  , miner_id          STRING     NOT NULL OPTIONS( description = 'Address of the miner who owns the sector.' )
  , sector_id         BIGINT     NOT NULL OPTIONS( description = 'Numeric identifier of the sector.' )
  , post_message_cid  STRING              OPTIONS( description = 'CID of the PoSt message.' )
  , PRIMARY KEY (height, miner_id, sector_id) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Proof of Spacetime for sectors.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.multisig_approvals ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.multisig_approvals
(
    height            BIGINT     NOT NULL OPTIONS( description = 'Epoch at which this transaction was executed.' )
  , state_root        STRING     NOT NULL OPTIONS( description = 'CID of the parent state root at this epoch.' )
  , multisig_id       STRING     NOT NULL OPTIONS( description = 'Address of the multisig actor involved in the transaction.' )
  , message           STRING     NOT NULL
  , method            BIGINT     NOT NULL OPTIONS( description = 'The method number to invoke on the recipient if the proposal is approved. Only unique to the actor the method is being invoked on. A method number of 0 is a plain token transfer - no method exectution.' )
  , approver          STRING     NOT NULL
  , threshold         BIGINT     NOT NULL
  , initial_balance   STRING              OPTIONS( description = '(The origin data type is NUMERIC)' )
  , gas_used          BIGINT     NOT NULL
  , transaction_id    BIGINT     NOT NULL OPTIONS( description = 'Number identifier for the transaction - unique per multisig.' )
  , `to`              STRING     NOT NULL OPTIONS( description = 'Address of the recipient who will be sent a message if the proposal is approved.' )
  , value             STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Amount of FIL (in attoFIL) that will be transferred if the proposal is approved.' )
  , signers           STRING              OPTIONS( description = '(The origin data type is JSONB)' )
  , PRIMARY KEY (height, state_root, multisig_id, message, approver) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Message Transactions approved by Multsig Actors.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.multisig_transactions ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.multisig_transactions
(
    height            BIGINT    NOT NULL OPTIONS( description = 'Epoch at which this transaction was executed.' )
  , state_root        STRING    NOT NULL OPTIONS( description = 'CID of the parent state root at this epoch.' )
  , multisig_id       STRING    NOT NULL OPTIONS( description = 'Address of the multisig actor involved in the transaction.' )
  , transaction_id    BIGINT    NOT NULL OPTIONS( description = 'Number identifier for the transaction - unique per multisig.' )
  , `to`              STRING    NOT NULL OPTIONS( description = 'Address of the recipient who will be sent a message if the proposal is approved.' )
  , value             STRING    NOT NULL OPTIONS( description = 'Amount of FIL (in attoFIL) that will be transferred if the proposal is approved.' )
  , method            BIGINT    NOT NULL OPTIONS( description = 'The method number to invoke on the recipient if the proposal is approved. Only unique to the actor the method is being invoked on. A method number of 0 is a plain token transfer - no method exectution.' )
  , params            STRING             OPTIONS( description = '(The origin data type is BYTEA) CBOR encoded bytes of parameters to send to the method that will be invoked if the proposal is approved.' )
  , approved          STRING    NOT NULL OPTIONS( description = '(The origin data type is JSONB) Addresses of signers who have approved the transaction. 0th entry is the proposer.' )
  , PRIMARY KEY (height, state_root, multisig_id, transaction_id) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Details of pending transactions involving multisig actors.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.parsed_messages ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.parsed_messages
(
    height            BIGINT     NOT NULL  OPTIONS( description = 'Epoch this message was executed at.' )
  , cid               STRING     NOT NULL  OPTIONS( description = 'CID of the message.' )
  , `from`            STRING     NOT NULL  OPTIONS( description = 'Address of the actor that sent the message.' )
  , `to`              STRING     NOT NULL  OPTIONS( description = 'Address of the actor that received the message.' )
  , value             STRING     NOT NULL  OPTIONS( description = '(The origin data type is NUMERIC) Amount of FIL (in attoFIL) transferred by this message.' )
  , method            STRING     NOT NULL  OPTIONS( description = 'The name of the method that was invoked on the recipient actor.' )
  , params            STRING               OPTIONS( description = '(The origin data type is JSONB) Method parameters parsed and serialized as a JSON object.' )
  , PRIMARY KEY (height, cid) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Messages parsed to extract useful information.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.power_actor_claims ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.power_actor_claims
(
    height             BIGINT           NOT NULL OPTIONS( description = 'Epoch this claim was made.' )
  , miner_id           STRING           NOT NULL OPTIONS( description = 'Address of miner making the claim.' )
  , state_root         STRING           NOT NULL OPTIONS( description = 'CID of the parent state root at this epoch.' )
  , raw_byte_power     BIGNUMERIC(38,0) NOT NULL OPTIONS( description = 'Sum of raw byte storage power for a miner’s sectors. Raw byte power is the size of a sector in bytes.' )
  , quality_adj_power  BIGNUMERIC(38,0) NOT NULL OPTIONS( description = 'Sum of quality adjusted storage power for a miner’s sectors. Quality adjusted power is a weighted average of the quality of its space and it is based on the size, duration and quality of its deals.' )
  , PRIMARY KEY (height, miner_id, state_root) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Miner power claims recorded by the power actor.' )
;


--! not run
DROP TABLE IF EXISTS <project-name>.<dataset-name>.receipt_returns ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.receipt_returns
(
    message   STRING     NOT NULL OPTIONS( description = 'The CID of the message that produced in this receipt.' )
  , `return`  STRING     NOT NULL OPTIONS( description = 'The return of the receipt as bytes.' )
  , PRIMARY KEY (message) NOT ENFORCED
)
OPTIONS( description = 'Raw parameters of on chain receipt.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.receipts ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.receipts
(
    height          BIGINT     NOT NULL  OPTIONS( description = 'Epoch the message was executed and receipt generated.' )
  , message         STRING     NOT NULL  OPTIONS( description = 'CID of the message this receipt belongs to.' )
  , state_root      STRING     NOT NULL  OPTIONS( description = 'CID of the parent state root that this epoch.' )
  , idx             BIGINT     NOT NULL  OPTIONS( description = 'Index of message indicating execution order.' )
  , exit_code       BIGINT     NOT NULL  OPTIONS( description = 'The exit code that was returned as a result of executing the message. Exit code 0 indicates success. Codes 0-15 are reserved for use by the runtime. Codes 16-31 are common codes shared by different actors. Codes 32+ are actor specific.' )
  , gas_used        BIGINT     NOT NULL  OPTIONS( description = 'A measure of the amount of resources (or units of gas) consumed, in order to execute a message.' )
  , `return`        STRING               OPTIONS( description = '(The origin data type is BYTEA) Returns value of message receipt. ' )
  , parsed_return   STRING               OPTIONS( description = '(The origin data type is JSONB) Result returned from executing a message parsed and serialized as a JSON object. ' )
  , PRIMARY KEY (height, message, state_root) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Message reciepts after being applied to chain state by message CID and parent state root CID of tipset when message was executed.' )
;


--! not run
DROP TABLE IF EXISTS <project-name>.<dataset-name>.surveyed_miner_protocols ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.surveyed_miner_protocols
(
    observed_at  TIMESTAMP  NOT NULL OPTIONS( description = '(The origin data type is TIMESTAMPTZ) Timestamp of the observation.' )
  , miner_id     STRING     NOT NULL OPTIONS( description = 'Address (ActorID) of the miner.' )
  , peer_id      STRING              OPTIONS( description = 'PeerID of the miner advertised in on-chain MinerInfo structure.' )
  , agent        STRING              OPTIONS( description = 'Agent string as reported by the peer.' )
  , protocols    STRING              OPTIONS( description = '(The origin data type is JSONB) List of supported protocol strings supported by the peer.' )
  , PRIMARY KEY (observed_at, miner_id) NOT ENFORCED
)
OPTIONS( description = 'Observations of Filecoin storage provider supported protocols and agents over time.' )
;


--! not run
DROP TABLE IF EXISTS <project-name>.<dataset-name>.surveyed_peer_agents ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.surveyed_peer_agents
(
    surveyer_peer_id  STRING     NOT NULL OPTIONS( description = 'Peer ID of the node performing the survey.' )
  , observed_at       TIMESTAMP  NOT NULL OPTIONS( description = '(The origin data type is TIMESTAMPTZ) Timestamp of the observation.' )
  , raw_agent         STRING     NOT NULL OPTIONS( description = 'Unprocessed agent string as reported by a peer.' )
  , normalized_agent  STRING     NOT NULL OPTIONS( description = 'Agent string normalized to a software name with major and minor version.' )
  , `count`           BIGINT     NOT NULL OPTIONS( description = 'Number of peers that reported the same raw agent.' )
  , PRIMARY KEY (surveyer_peer_id, observed_at, raw_agent) NOT ENFORCED
)
OPTIONS( description = 'Observations of filecoin peer agent strings over time.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.unsynced_block_headers ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.unsynced_block_headers
(
    height             BIGINT     NOT NULL
  , cid                STRING     NOT NULL
  , miner              STRING
  , parent_weight      STRING
  , parent_base_fee    STRING
  , parent_state_root  STRING
  , win_count          BIGINT
  , `timestamp`        BIGINT
  , fork_signaling     BIGINT
  , is_orphan          BOOLEAN
  , PRIMARY KEY (height, cid) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
;


--! not run
DROP TABLE IF EXISTS <project-name>.<dataset-name>.verified_registry_claims ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.verified_registry_claims
(
    height      BIGINT     NOT NULL
  , state_root  STRING     NOT NULL
  , claim_id    BIGINT     NOT NULL
  , provider    STRING     NOT NULL
  , client      STRING     NOT NULL
  , `data`      STRING     NOT NULL
  , `size`      BIGINT     NOT NULL
  , term_min    BIGINT     NOT NULL
  , term_max    BIGINT     NOT NULL
  , term_start  BIGINT     NOT NULL
  , sector      BIGINT     NOT NULL
  , event       STRING     NOT NULL
  , PRIMARY KEY (height, state_root, claim_id) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'store the claim relationship between provider, client in each epoch.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.verified_registry_verified_clients ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.verified_registry_verified_clients
(
    height      BIGINT         NOT NULL OPTIONS( description = 'Epoch at which this verified client state changed.' )
  , state_root  STRING         NOT NULL OPTIONS( description = 'CID of the parent state root at this epoch.' )
  , address     STRING         NOT NULL OPTIONS( description = 'Address of verified client this state change applies to.' )
  , data_cap    STRING         NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) DataCap of verified client at this state change.' )
  , event       STRING         NOT NULL OPTIONS( description = 'Name of the event that occurred.' )
  , PRIMARY KEY (height, state_root, address) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Verifier on-chain per each verified client state change.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.verified_registry_verifiers ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.verified_registry_verifiers
(
    height      BIGINT        NOT NULL OPTIONS( description = 'Epoch at which this verifiers state changed.' )
  , state_root  STRING        NOT NULL OPTIONS( description = 'CID of the parent state root at this epoch.' )
  , address     STRING        NOT NULL OPTIONS( description = 'Address of verifier this state change applies to.' )
  , data_cap    STRING        NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) DataCap of verifier at this state change.' )
  , event       STRING        NOT NULL OPTIONS( description = 'Name of the event that occurred.' )
  , PRIMARY KEY (height, state_root, address) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Verifier on-chain per each verifier state change.' )
;


DROP TABLE IF EXISTS <project-name>.<dataset-name>.vm_messages ;
CREATE TABLE IF NOT EXISTS <project-name>.<dataset-name>.vm_messages
(
    height           BIGINT     NOT NULL OPTIONS( description = 'Height message was executed at.' )
  , state_root       STRING     NOT NULL OPTIONS( description = 'CID of the parent state root at which this message was executed.' )
  , cid              STRING     NOT NULL OPTIONS( description = 'CID of the message (note this CID does not appear on chain).' )
  , source           STRING     NOT NULL OPTIONS( description = 'CID of the on-chain message or implicit (internal) message that caused this message to be sent.' )
  , `from`           STRING     NOT NULL OPTIONS( description = 'Address of the actor that sent the message.' )
  , `to`             STRING     NOT NULL OPTIONS( description = 'Address of the actor that received the message.' )
  , value            STRING     NOT NULL OPTIONS( description = '(The origin data type is NUMERIC) Amount of FIL (in attoFIL) transferred by this message.' )
  , method           BIGINT     NOT NULL OPTIONS( description = 'The method number invoked on the recipient actor. Only unique to the actor the method is being invoked on. A method number of 0 is a plain token transfer - no method execution' )
  , actor_code       STRING     NOT NULL OPTIONS( description = 'The CID of the actor that received the message.' )
  , exit_code        BIGINT     NOT NULL OPTIONS( description = 'The exit code that was returned as a result of executing the message.' )
  , gas_used         BIGINT     NOT NULL OPTIONS( description = 'A measure of the amount of resources (or units of gas) consumed, in order to execute a message.' )
  , params           STRING              OPTIONS( description = '(The origin data type is JSONB) Message parameters parsed and serialized as a JSON object.' )
  , returns          STRING              OPTIONS( description = '(The origin data type is JSONB) Result returned from executing a message parsed and serialized as a JSON object.' )
  , `index`          BIGINT     NOT NULL OPTIONS( description = 'Order in which the message was applied.' )
  , PRIMARY KEY (height, state_root, cid, source, `index`) NOT ENFORCED
)
PARTITION BY RANGE_BUCKET(height, GENERATE_ARRAY(0, 345513600, 86400))
OPTIONS( description = 'Messages sent internally through the VM not appearing on chain.' )
;

