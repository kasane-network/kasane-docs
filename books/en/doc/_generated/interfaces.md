<!-- ja-source-hash: cfa8f79823b13688e6d93001d8ed28ada8adcbde -->
> Japanese version: /ja/doc/_generated/interfaces.html

# Interfaces

## TL;DR
- External interfaces are provided via two paths: `Candid` (direct canister) and `HTTP JSON-RPC` (gateway).
- JSON-RPC is not full Ethereum compatibility; it is a constrained implementation.
- In `eth_sendRawTransaction`, submit success is not execution success. Use `eth_getTransactionReceipt.status` for final success.
- pending/mempool is not available as Ethereum-compatible APIs; use canister `get_pending(tx_id)` to track submitted tx.

## 1. Candid API (Public Service)
Public definition: `crates/ic-evm-gateway/evm_canister.did`

- Measurement-only precompile profiling methods are not part of the public DID.
- Internal profiling builds use a separate admin DID: `crates/ic-evm-gateway/evm_canister_precompile_profile_admin.did`.

### Main query methods
- `rpc_eth_chain_id`
- `rpc_eth_block_number`
- `rpc_eth_get_block_by_number`
- `rpc_eth_get_block_by_number_with_status`
- `rpc_eth_get_transaction_by_eth_hash`
- `rpc_eth_get_transaction_by_tx_id`
- `rpc_eth_get_transaction_receipt_by_eth_hash`
- `rpc_eth_get_transaction_receipt_with_status_by_eth_hash`
- `rpc_eth_get_transaction_receipt_with_status_by_tx_id`
- `rpc_eth_get_balance`
- `rpc_eth_get_code`
- `rpc_eth_get_storage_at`
- `rpc_eth_call_object`
- `rpc_eth_call_rawtx`
- `rpc_eth_estimate_gas_object`
- `rpc_eth_get_logs_paged`
- `rpc_eth_get_block_number_by_hash`
- `rpc_eth_gas_price`
- `rpc_eth_max_priority_fee_per_gas`
- `rpc_eth_fee_history`
- `expected_nonce_by_address`
- `get_receipt`
- `get_pending`
- `export_blocks`
- `get_ops_status`
- `health`
- `metrics`

### Main update methods
- `rpc_eth_send_raw_transaction`
- `submit_ic_tx`
- `set_block_gas_limit`
- `set_instruction_soft_limit`
- `set_prune_policy`
- `set_pruning_enabled`
- `set_log_filter`
- `prune_blocks`

## 2. Gateway JSON-RPC
Implementation: `handleRpc` switch in `tools/rpc-gateway/src/handlers.ts`

### Implemented methods
- `web3_clientVersion`
- `net_version`
- `eth_chainId`
- `eth_blockNumber`
- `eth_gasPrice`
- `eth_maxPriorityFeePerGas`
- `eth_feeHistory`
- `eth_syncing`
- `eth_getBlockByNumber`
- `eth_getTransactionByHash`
- `eth_getTransactionReceipt`
- `eth_getBalance`
- `eth_getTransactionCount`
- `eth_getCode`
- `eth_getStorageAt`
- `eth_getLogs`
- `eth_call`
- `eth_estimateGas`
- `eth_sendRawTransaction`

### Unsupported methods (README compatibility matrix)
- `eth_getBlockByHash`
- `eth_getTransactionByBlockHashAndIndex`
- `eth_getTransactionByBlockNumberAndIndex`
- `eth_getBlockTransactionCountByHash`
- `eth_getBlockTransactionCountByNumber`
- `eth_newFilter`
- `eth_getFilterChanges`
- `eth_uninstallFilter`
- `eth_subscribe`
- `eth_unsubscribe`
- `eth_pendingTransactions`

## 3. Canonical Constraint References
- Canonical overall policy: `../rpc/overview.md`
- Canonical JSON-RPC differences: `../compatibility/json-rpc-deviations.md`
- Canonical pending/mempool policy: "Pending/Mempool Policy" in `../rpc/overview.md`

This page is intentionally limited to interface inventory. Detailed behavior differences belong to the canonical pages above.

## 4. Return/Identifier Notes
- Internal canister identifier: `tx_id`
- Ethereum-compatible identifier: `eth_tx_hash`
- Gateway `eth_sendRawTransaction` resolves and returns `eth_tx_hash` from canister-returned `tx_id`.

## 5. Type Boundaries (Representative)
- `RpcCallObjectView` (Candid)
- `EthBlockView` / `EthTxView` / `EthReceiptView`
- `RpcBlockLookupView` (`NotFound` / `Found` / `Pruned`)
- `RpcReceiptLookupView` (`NotFound` / `Found` / `PossiblyPruned` / `Pruned`)
- `PendingStatusView` (`Queued` / `Included` / `Dropped` / `Unknown`)

## Sources
- `crates/ic-evm-gateway/evm_canister.did`
- `crates/ic-evm-gateway/evm_canister_precompile_profile_admin.did`
- `tools/rpc-gateway/src/handlers.ts`
- `tools/rpc-gateway/README.md`
- `crates/ic-evm-gateway/src/lib.rs` (`get_pending`, `rpc_eth_send_raw_transaction`)
