<!-- ja-source-hash: cf8708848f1bd5cd3cd72415af31fb117c4c07a0 -->
> Japanese version: /ja/doc/rpc/transactions-and-receipts.html

# Transaction & Receipt Methods

## TL;DR
- Transaction lookups are keyed by `eth_tx_hash`.
- Receipt lookups can explicitly return `PossiblyPruned/Pruned`.

## Methods
- `eth_getTransactionByHash` -> `rpc_eth_get_transaction_by_eth_hash`
- `eth_getTransactionReceipt` -> `rpc_eth_get_transaction_receipt_with_status_by_eth_hash`

## Notes
- `tx_id` is an internal key; use `eth_tx_hash` for external integrations.
- For internal operations that directly use tx_id, call `rpc_eth_get_transaction_receipt_with_status_by_tx_id`.
- During migration/corrupt states, methods can return `state unavailable`.

## Sources
- `tools/rpc-gateway/src/handlers.ts`
- `crates/ic-evm-rpc/src/lib.rs`
