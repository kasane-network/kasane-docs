<!-- ja-source-hash: 9d7574b30a859ac31ef1fbc5e5d683d7b29fb0b7 -->
> Japanese version: /ja/doc/rpc/state.html

# State Methods

## TL;DR
- Provides `eth_getBalance`, `eth_getTransactionCount`, `eth_getCode`, and `eth_getStorageAt`.
- blockTag accepts `latest/pending/safe/finalized/earliest/QUANTITY`, but historical support is limited for many methods.

## Methods
- `eth_getBalance` -> `rpc_eth_get_balance`
- `eth_getTransactionCount` -> `rpc_eth_get_transaction_count_at`
- `eth_getCode` -> `rpc_eth_get_code`
- `eth_getStorageAt` -> `rpc_eth_get_storage_at`

## Key Constraints
- balance/code/storage: historical reads other than head-equivalent can return `state unavailable` / out-of-window
- tx count: `pending` returns pending nonce; `earliest` and historical nonce are currently unavailable

See `../compatibility/json-rpc-deviations.md` and `./overview.md` for details.

## Sources
- `tools/rpc-gateway/src/handlers.ts`
- `crates/ic-evm-rpc/src/lib.rs`
- `tools/rpc-gateway/README.md`
