<!-- ja-source-hash: e820471279ba4cecda12ed7b189e27ffb07baf0f -->
> Japanese version: /ja/doc/compatibility/json-rpc-deviations.html

# JSON-RPC Deviations

## TL;DR
- Implemented methods are intentionally limited.
- `eth_getLogs` is constrained; `blockHash` is conditionally supported, and `topics[0]` OR arrays are supported.
- blockTag support depends on method. `latest` family plus `earliest/QUANTITY` are accepted, but historical support is limited.
- `eth_sendRawTransaction` delegates to submit API; execution success must be confirmed from receipt.
- `eth_feeHistory` is supported (`blockCount` accepts number/QUANTITY/decimal string).
- `eth_gasPrice` returns an acceptance-oriented estimate, not raw `base_fee`.

Scope: this page documents JSON-RPC-level differences. Canonical overall policy is `../rpc/overview.md`.

## Method-Level Differences (Highlights)
- `eth_getBalance`
  - Accepts `latest/pending/safe/finalized/earliest/QUANTITY`
  - Historical queries often return `exec.state.unavailable` or `invalid.block_range.out_of_window`
- `eth_getTransactionCount`
  - Accepts `latest/pending/safe/finalized/earliest/QUANTITY`
  - `pending` returns pending nonce
  - `earliest` and historical nonce are currently unavailable
- `eth_getCode`
  - Accepts `latest/pending/safe/finalized/earliest/QUANTITY`
  - Historical queries are generally unavailable
- `eth_getStorageAt`
  - Accepts `latest/pending/safe/finalized/earliest/QUANTITY`
  - slot accepts QUANTITY or 32-byte DATA
  - Historical queries are generally unavailable
- `eth_call`, `eth_estimateGas`
  - Accepts `latest/pending/safe/finalized/earliest/QUANTITY`
  - Historical execution is unavailable (`exec.state.unavailable` / `invalid.block_range.out_of_window`)
  - Unsupported fields return `-32602`
- `eth_getLogs`
  - `blockHash` is conditionally supported (cannot combine with `fromBlock/toBlock`; resolved by scanning recent N blocks)
  - single `address` only
  - `topics[0]` OR array supported (max 16)
  - `topics[1+]` conditions unsupported
  - oversized range returns `-32005`
- `eth_feeHistory`
  - `blockCount` accepts `number` / `QUANTITY` / decimal string
  - `blockCount <= 256`
  - `pending` is currently treated as `latest`
- `eth_maxPriorityFeePerGas`
  - returns `-32000` (`state unavailable`) when observed data is insufficient
- `eth_gasPrice`
  - returns `max(base_fee + max(estimated_priority, min_priority), min_gas_price)`

## Unsupported Methods
- `eth_getBlockByHash`
- `eth_newFilter` / `eth_getFilterChanges` / `eth_uninstallFilter`
- `eth_subscribe` / `eth_unsubscribe`
- `eth_pendingTransactions`

## Error Design
- `-32602`: invalid params
- `-32000`: state unavailable / execution failed
- `-32001`: resource not found (including pruned cases)
- `-32005`: limit exceeded (logs)
- Note: internal submit failures can surface as `-32603` on specific paths

## Pitfalls
- Reusing standard node `eth_getLogs` filters as-is (`address[]` or `topics[1+]`)
- Treating `eth_sendRawTransaction` success as final execution success
- Assuming `blockHash` in `eth_getLogs` is always resolvable (scan window is bounded)

## Sources
- `tools/rpc-gateway/src/handlers.ts`
- `tools/rpc-gateway/README.md`
- `crates/ic-evm-rpc/src/lib.rs`
