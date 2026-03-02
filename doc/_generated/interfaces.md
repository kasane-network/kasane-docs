# Interfaces

## TL;DR
- 外部I/Fは `Candid`（canister直呼び）と `HTTP JSON-RPC`（gateway）の2系統。
- JSON-RPCは Ethereum完全互換ではなく、制限付き実装。
- `eth_sendRawTransaction` は submit成功≠実行成功。`eth_getTransactionReceipt.status` を成功条件にする。
- pending/mempool は Ethereum互換APIとしては未対応。送信済み tx の追跡は canister `get_pending(tx_id)` を使う。

## 1. Candid API（公開service）
公開定義: `crates/ic-evm-wrapper/evm_canister.did`

### 主要query
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

### 主要update
- `rpc_eth_send_raw_transaction`
- `submit_ic_tx`
- `set_block_gas_limit`
- `set_instruction_soft_limit`
- `set_prune_policy`
- `set_pruning_enabled`
- `set_log_filter`
- `prune_blocks`

## 2. Gateway JSON-RPC
実装: `tools/rpc-gateway/src/handlers.ts` の `handleRpc` switch

### 実装済みメソッド
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

### 未対応（READMEの互換表）
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

## 3. 制約の正本
- 全体ポリシーの正本: `../rpc/overview.md`
- JSON-RPC差分の正本: `../compatibility/json-rpc-deviations.md`
- pending/mempool運用の正本: `../rpc/overview.md` の「Pending/Mempoolポリシー」

本ページは「インターフェース一覧」の要約に限定し、詳細な挙動差分は上記正本に集約する。

## 4. 返却・識別子の注意
- canister内部識別子: `tx_id`
- Ethereum互換識別子: `eth_tx_hash`
- Gateway `eth_sendRawTransaction` は canister戻り `tx_id` から `eth_tx_hash` を解決して返す。

## 5. 型境界（代表）
- `RpcCallObjectView`（Candid）
- `EthBlockView` / `EthTxView` / `EthReceiptView`
- `RpcBlockLookupView`（`NotFound` / `Found` / `Pruned`）
- `RpcReceiptLookupView`（`NotFound` / `Found` / `PossiblyPruned` / `Pruned`）
- `PendingStatusView`（`Queued` / `Included` / `Dropped` / `Unknown`）

## 根拠
- `crates/ic-evm-wrapper/evm_canister.did`
- `tools/rpc-gateway/src/handlers.ts`
- `tools/rpc-gateway/README.md`
- `crates/ic-evm-wrapper/src/lib.rs`（`get_pending`, `rpc_eth_send_raw_transaction`）
