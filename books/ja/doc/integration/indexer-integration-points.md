> English version: /en/doc/integration/indexer-integration-points.html

# Indexer Integration Points

## TL;DR
- 取得起点は `export_blocks(cursor,max_bytes)`。
- logs補助取得は `rpc_eth_get_logs_paged`。
- prune 前提で cursor 運用を設計する。

## 根拠
- `crates/ic-evm-gateway/evm_canister.did`
- `tools/indexer/README.md`
- `docs/specs/indexer-v1.md`
