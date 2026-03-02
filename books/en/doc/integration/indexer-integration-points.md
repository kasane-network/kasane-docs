<!-- ja-source-hash: 913a4bacf6383f76f60380425660e9c7172ed45d -->
> Japanese version: /ja/doc/integration/indexer-integration-points.html

# Indexer Integration Points

## TL;DR
- Pull entrypoint is `export_blocks(cursor,max_bytes)`.
- Log backfill helper is `rpc_eth_get_logs_paged`.
- Design cursor workflow with pruning in mind.

## Sources
- `crates/ic-evm-wrapper/evm_canister.did`
- `tools/indexer/README.md`
- `docs/specs/indexer-v1.md`
