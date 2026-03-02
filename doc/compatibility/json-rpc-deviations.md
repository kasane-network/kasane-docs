# JSON-RPC Deviations

## TL;DR
- 実装済みメソッドは限定される。
- `eth_getLogs` は制約が強いが、`blockHash` は条件付き対応、`topics[0]` の OR配列は対応済み。
- blockTagはメソッドごとに制約があり、`latest` 系に加えて `earliest/QUANTITY` を受理するが historical は多くが非対応。
- `eth_sendRawTransaction` は submit API委譲で、実行成功は receipt で確認する。
- `eth_feeHistory` は対応済み（`blockCount` は number/QUANTITY/10進文字列を受理）。
- `eth_gasPrice` は `base_fee` 単体ではなく、受理条件に寄せた推定値を返す。

## メソッド別差分（要点）
- `eth_getBalance`
  - `latest/pending/safe/finalized/earliest/QUANTITY` を受理
  - 実質 historical は `exec.state.unavailable` または `invalid.block_range.out_of_window`
- `eth_getTransactionCount`
  - `latest/pending/safe/finalized/earliest/QUANTITY` を受理
  - `pending` は pending nonce
  - `earliest` や過去block nonceは非対応（historical nonce未提供）
- `eth_getCode`
  - `latest/pending/safe/finalized/earliest/QUANTITY` を受理
  - 実質 historical は `exec.state.unavailable` または `invalid.block_range.out_of_window`
- `eth_getStorageAt`
  - `latest/pending/safe/finalized/earliest/QUANTITY` を受理
  - slotは QUANTITY/DATA(32 bytes) 受理
  - 実質 historical は `exec.state.unavailable` または `invalid.block_range.out_of_window`
- `eth_call`, `eth_estimateGas`
  - `latest/pending/safe/finalized/earliest/QUANTITY` を受理
  - historical execution は非対応（`exec.state.unavailable` / `invalid.block_range.out_of_window`）
  - 未対応フィールドは `-32602`
- `eth_getLogs`
  - `blockHash` は条件付き対応（`fromBlock/toBlock` 併用不可、直近Nブロック走査で解決）
  - `address` 単一のみ
  - `topics[0]` OR配列は対応（最大16件）
  - `topics[1+]` 条件は非対応
  - 範囲超過は `-32005`
- `eth_feeHistory`
  - `blockCount` は `number` / `QUANTITY` / 10進文字列を受理
  - `blockCount <= 256`
  - `pending` は現状 `latest` 同義
- `eth_maxPriorityFeePerGas`
  - 観測データ不足時は `-32000`（`state unavailable`）
- `eth_gasPrice`
  - `max(base_fee + max(推定priority,min_priority), min_gas_price)` を返す

## 未対応メソッド
- `eth_getBlockByHash`
- `eth_newFilter` / `eth_getFilterChanges` / `eth_uninstallFilter`
- `eth_subscribe` / `eth_unsubscribe`
- `eth_pendingTransactions`

## エラー設計
- `-32602`: invalid params
- `-32000`: state unavailable / execution failed
- `-32001`: resource not found（pruned含む）
- `-32005`: limit exceeded（logs）
- （補足）submit内部エラーは `-32603` が返る経路あり

## 落とし穴
- 標準ノード前提の `eth_getLogs` filter（`address[]` や `topics[1+]`）をそのまま投げる
- `eth_sendRawTransaction` だけで成功確定扱いにする
- `eth_getLogs` の `blockHash` が常に解決できる前提で使う（走査上限あり）

## 根拠
- `tools/rpc-gateway/src/handlers.ts`
- `tools/rpc-gateway/README.md`
- `crates/ic-evm-rpc/src/lib.rs`
