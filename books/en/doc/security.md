<!-- ja-source-hash: d164afac48c3f143fc04102b29440c72a6ab9571 -->
> Japanese version: /ja/doc/security.html

# Security Guide

## TL;DR
- Minimum baseline: signing-key management, chain-id correctness, and receipt monitoring.
- Typical incidents come from low-fee settings, nonce mistakes, and prune-unaware assumptions.

## Safe Usage
- Pin chain id (`4801360`)
- Fetch nonce every time
- Judge success from receipt after `eth_sendRawTransaction`
- Do not over-relax gateway limits

## Dangerous Pitfalls
- Missing `status=0x0` and treating failed execution as success
- Re-sending tx signed with wrong chain id repeatedly
- Assuming pruned history remains permanently queryable

## Recommended Settings
- Keep `RPC_GATEWAY_MAX_BATCH_LEN` within default range
- Match `INDEXER_CHAIN_ID` to target network
- Match `INDEXER_MAX_SEGMENT` to canister specification

## Sources
- `tools/rpc-gateway/src/config.ts`
- `tools/indexer/src/config.ts`
- `tools/rpc-gateway/README.md`
- `crates/evm-core/tests/phase1_eth_decode.rs`
