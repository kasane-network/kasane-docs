<!-- ja-source-hash: ae20545f7589761675350b63f4eebd849d4caaa2 -->
> Japanese version: /ja/doc/rpc/logs.html

# Logs

## TL;DR
- `eth_getLogs` is a constrained implementation built on `rpc_eth_get_logs_paged`.
- Exceeding range/filter limits returns `-32005`.

## Supported Patterns
- Single-address + topic0-centered retrieval
- OR arrays in `topics[0]` (up to 16)
- `blockHash` mode (without `fromBlock/toBlock`, within scan limits)

## Constraints
- `topics[1+]` conditions are currently unsupported
- multiple addresses in one request are unsupported

## Common Errors
- `logs.range_too_large`
- `logs.too_many_results`
- `UnsupportedFilter`

## Sources
- `crates/ic-evm-rpc/src/lib.rs` (`rpc_eth_get_logs_paged`)
- `tools/rpc-gateway/src/handlers.ts`
