<!-- ja-source-hash: f7bf26e41c30cff192b9e9b5019377a33f7e488c -->
> Japanese version: /ja/doc/troubleshooting.html

# Troubleshooting Guide

## TL;DR
- First classify issues into one of: invalid input, state unavailable, or pruned.
- Observe submit and execute as separate phases.

## Common Errors and Fixes
- `invalid params (-32602)`
  - Cause: invalid address/hash length, invalid blockTag, callObject constraint violation
  - Action: re-check hex lengths and supported keys
- `state unavailable (-32000)`
  - Cause: migration in progress, critical_corrupt, execution failure
  - Action: check `get_ops_status`
- `resource not found (-32001)`
  - Cause: pruned range or missing resource
  - Action: use indexer history
- `limit exceeded (-32005)`
  - Cause: too wide logs range / too many results
  - Action: split by block range

## Pitfalls
- Calling `eth_getLogs` over a large range in one request
- Resending without monitoring and amplifying nonce conflicts

## Sources
- `tools/rpc-gateway/src/handlers.ts`
- `tools/rpc-gateway/README.md`
- `crates/ic-evm-wrapper/src/lib.rs` (`get_ops_status`)
