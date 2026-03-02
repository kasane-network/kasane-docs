<!-- ja-source-hash: 1453935c3ab64d0178544db96bc5226ab97627de -->
> Japanese version: /ja/doc/rpc/overview.html

# RPC Overview

## TL;DR
- Gateway is the layer that translates canister Candid API into JSON-RPC 2.0.
- Compatibility is restricted, and some methods are not implemented.
- Invalid input mainly returns `-32602`; state inconsistency mainly returns `-32000/-32001`.

## Scope
- A subset of `web3_*`, `net_*`, and `eth_*`
- Implemented methods are canonically defined by the `handleRpc` switch

## Main Use Cases and Constraints
- Supports basic reads, `call`, `estimate`, and raw transaction submission
- filter/ws/pending have compatibility differences (see dedicated pages)

## Pending/Mempool Policy
- Ethereum-compatible pending/mempool APIs (for example `eth_pendingTransactions`, `eth_subscribe`) are currently not implemented.
- However, Candid provides `get_pending(tx_id)` for per-transaction tracking after submit.
- Determine execution success from receipt (`status`), not submit return value.
- See:
  - `../quickstart.md`
  - `../compatibility/json-rpc-deviations.md`
  - `../compatibility/ethereum-differences.md`
  - `../concepts/accounts-keys.md`
  - `../_generated/interfaces.md`

## Sources
- `tools/rpc-gateway/src/handlers.ts` (`handleRpc`)
- `tools/rpc-gateway/README.md`
- `crates/ic-evm-wrapper/src/lib.rs` (`get_pending`)
