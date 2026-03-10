<!-- ja-source-hash: 728582a7db00facc5bfbc20001de7befc97fe74b -->
> Japanese version: /ja/doc/integration/indexer-integration-points.html

# Indexer Integration Points

## TL;DR
- Pull entrypoint is `export_blocks(cursor,max_bytes)`.
- Log backfill helper is `rpc_eth_get_logs_paged`.
- Design cursor workflow with pruning in mind.

## Sources
- `crates/ic-evm-gateway/evm_canister.did`
- `tools/indexer/README.md`
- `docs/specs/indexer-v1.md`
