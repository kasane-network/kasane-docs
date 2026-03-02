# State Methods

## TL;DR
- `eth_getBalance`, `eth_getTransactionCount`, `eth_getCode`, `eth_getStorageAt` を提供。
- blockTag は `latest/pending/safe/finalized/earliest/QUANTITY` を受理するが、historical は多くが制約付き。

## メソッド
- `eth_getBalance` -> `rpc_eth_get_balance`
- `eth_getTransactionCount` -> `rpc_eth_get_transaction_count_at`
- `eth_getCode` -> `rpc_eth_get_code`
- `eth_getStorageAt` -> `rpc_eth_get_storage_at`

## 主な制約
- balance/code/storage: `QUANTITY==head` 以外の historical は `state unavailable` / out-of-window になり得る
- tx count: `pending` は pending nonce を返す。`earliest` / 過去nonce は現状未提供

詳細は `../compatibility/json-rpc-deviations.md` と `./overview.md` を参照。

## 根拠
- `tools/rpc-gateway/src/handlers.ts`
- `crates/ic-evm-rpc/src/lib.rs`
- `tools/rpc-gateway/README.md`
