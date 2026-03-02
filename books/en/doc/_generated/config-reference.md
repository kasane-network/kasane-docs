<!-- ja-source-hash: 020a6dfb0b6f6aaa4977addc91533543a6c35043 -->
> Japanese version: /ja/doc/_generated/config-reference.html

# Config Reference

## TL;DR
- Required settings are Gateway: `EVM_CANISTER_ID`, Indexer: `EVM_CANISTER_ID` + `INDEXER_DATABASE_URL`.
- Default `chain_id` is `4801360`.
- Gas/mining/prune defaults are managed as Rust constants.

## 1. Gateway Environment Variables
Definition: `tools/rpc-gateway/src/config.ts`

- Required
  - `EVM_CANISTER_ID`
- Optional (default)
  - `RPC_GATEWAY_IC_HOST` (`https://icp-api.io`)
  - `RPC_GATEWAY_FETCH_ROOT_KEY` (`false`)
  - `RPC_GATEWAY_IDENTITY_PEM_PATH` (`null`)
  - `RPC_GATEWAY_HOST` (`127.0.0.1`)
  - `RPC_GATEWAY_PORT` (`8545`)
  - `RPC_GATEWAY_CLIENT_VERSION` (`kasane/phase2-gateway/v0.1.0`)
  - `RPC_GATEWAY_MAX_HTTP_BODY_SIZE` (`262144`)
  - `RPC_GATEWAY_MAX_BATCH_LEN` (`20`)
  - `RPC_GATEWAY_MAX_JSON_DEPTH` (`20`)
  - `RPC_GATEWAY_CORS_ORIGIN` (`*`)

## 2. Indexer Environment Variables
Definition: `tools/indexer/src/config.ts`

- Required
  - `EVM_CANISTER_ID`
  - `INDEXER_DATABASE_URL`
- Optional (default)
  - `INDEXER_IC_HOST` (`https://icp-api.io`)
  - `INDEXER_DB_POOL_MAX` (`10`)
  - `INDEXER_RETENTION_DAYS` (`90`)
  - `INDEXER_RETENTION_ENABLED` (`true`)
  - `INDEXER_RETENTION_DRY_RUN` (`false`)
  - `INDEXER_ARCHIVE_GC_DELETE_ORPHANS` (`false`)
  - `INDEXER_MAX_BYTES` (`1200000`)
  - `INDEXER_BACKOFF_INITIAL_MS` (`200`)
  - `INDEXER_BACKOFF_MAX_MS` (`5000`)
  - `INDEXER_IDLE_POLL_MS` (`1000`)
  - `INDEXER_PRUNE_STATUS_POLL_MS` (`30000`)
  - `INDEXER_OPS_METRICS_POLL_MS` (`30000`)
  - `INDEXER_FETCH_ROOT_KEY` (`false`)
  - `INDEXER_ARCHIVE_DIR` (`./archive`)
  - `INDEXER_CHAIN_ID` (`4801360`)
  - `INDEXER_ZSTD_LEVEL` (`3`)
  - `INDEXER_MAX_SEGMENT` (`2`)

## 3. Chain / Runtime Constants

### chain constants
Definition: `crates/evm-db/src/chain_data/constants.rs`
- `CHAIN_ID = 4_801_360`
- `MAX_TX_SIZE = 128 * 1024`
- `MAX_TXS_PER_BLOCK = 1024`
- `MAX_PENDING_GLOBAL = 8192`
- `MAX_PENDING_PER_SENDER = 64`
- `MAX_PENDING_PER_PRINCIPAL = 32`
- `MAX_NONCE_WINDOW = 64`
- `MAX_LOGS_PER_TX = 64`
- `MAX_LOG_TOPICS = 4`

### runtime defaults
Definition: `crates/evm-db/src/chain_data/runtime_defaults.rs`
- `DEFAULT_MINING_INTERVAL_MS = 2000`
- `DEFAULT_BASE_FEE = 250_000_000_000`
- `DEFAULT_MIN_GAS_PRICE = 250_000_000_000`
- `DEFAULT_MIN_PRIORITY_FEE = 250_000_000_000`
- `DEFAULT_BLOCK_GAS_LIMIT = 3_000_000`
- `DEFAULT_INSTRUCTION_SOFT_LIMIT = 4_000_000_000`
- `DEFAULT_PRUNE_TIMER_INTERVAL_MS = 3_600_000`
- `DEFAULT_PRUNE_MAX_OPS_PER_TICK = 5_000`
- `MIN_PRUNE_TIMER_INTERVAL_MS = 1_000`
- `MIN_PRUNE_MAX_OPS_PER_TICK = 1`

## 4. Risky Values / Notes
- If `INDEXER_CHAIN_ID` does not match the real chain, signing/verification operations can fail.
- Increasing `RPC_GATEWAY_MAX_HTTP_BODY_SIZE` too much weakens DoS resistance.
- Lowering `DEFAULT_MIN_GAS_PRICE` / `DEFAULT_MIN_PRIORITY_FEE` without clear rationale reduces low-fee spam resistance.

## Sources
- `tools/rpc-gateway/src/config.ts`
- `tools/indexer/src/config.ts`
- `crates/evm-db/src/chain_data/constants.rs`
- `crates/evm-db/src/chain_data/runtime_defaults.rs`
