<!-- ja-source-hash: 7f8c42299f508fc54741434f8cf27c91aad56353 -->
> Japanese version: /ja/doc/concepts/blocks-receipts-logs.html

# Blocks, Receipts, Logs

## TL;DR
- Blocks/receipts/logs are exposed via Candid types.
- Receipt includes `status`, `gas_used`, `effective_gas_price`, `contract_address`, and `logs`.

## Key Points
- `logs[].logIndex` is the in-block ordinal index
- receipt lookup can return `Found/NotFound/PossiblyPruned/Pruned`

## Pitfalls
- Designing as if pruned history is always permanently queryable
- Mixing `tx_id` and `eth_tx_hash` lookup paths

## Sources
- `crates/ic-evm-wrapper/evm_canister.did`
- `crates/ic-evm-rpc/src/lib.rs`
- `tools/rpc-gateway/src/handlers.ts`
