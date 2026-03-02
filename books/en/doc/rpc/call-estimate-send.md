<!-- ja-source-hash: 4ac513a987371ac828bbe371663a986e17ffaae9 -->
> Japanese version: /ja/doc/rpc/call-estimate-send.html

# Call, Estimate, Send

## TL;DR
- `eth_call` / `eth_estimateGas` have callObject constraints.
- `eth_estimateGas` returns minimum successful `gas`, not `gas_used`.
- `eth_sendRawTransaction` delegates to canister submit API.

## Methods
- `eth_call` -> `rpc_eth_call_object`
- `eth_estimateGas` -> `rpc_eth_estimate_gas_object`
- `eth_sendRawTransaction` -> `rpc_eth_send_raw_transaction`

## callObject Constraints
- Supported keys: `to/from/gas/gasPrice/value/data/nonce/maxFeePerGas/maxPriorityFeePerGas/chainId/type/accessList`
- `type=0x0` / `0x2` only
- Fee parameter combinations must follow validation rules

## Send Operation
- Always monitor receipt `status` after submit success

## Sources
- `tools/rpc-gateway/README.md`
- `tools/rpc-gateway/src/handlers.ts`
- `crates/ic-evm-rpc/src/lib.rs`
