<!-- ja-source-hash: 6d777c9cbb68f4e02c269e324918cbbca32b1e61 -->
> Japanese version: /ja/doc/rpc/chain-and-block.html

# Chain & Block Methods

## TL;DR
- Provides `eth_chainId`, `net_version`, `eth_blockNumber`, and `eth_getBlockByNumber`.
- `eth_getBlockByNumber` returns `-32001` in pruned ranges.

## Methods
- `eth_chainId` -> canister `rpc_eth_chain_id`
- `net_version` -> decimal string conversion of `rpc_eth_chain_id`
- `eth_blockNumber` -> canister `rpc_eth_block_number`
- `eth_getBlockByNumber` -> canister `rpc_eth_get_block_by_number_with_status`

## blockTag Constraints
- `latest/pending/safe/finalized` are treated as head-level tags
- pruned data returns `resource not found`

## Sources
- `tools/rpc-gateway/src/handlers.ts`
- `crates/ic-evm-rpc/src/lib.rs`

For detailed constraints, see `../compatibility/json-rpc-deviations.md`.
