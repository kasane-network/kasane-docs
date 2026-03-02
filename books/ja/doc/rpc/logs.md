> English version: /en/doc/rpc/logs.html

# Logs

## TL;DR
- `eth_getLogs` は `rpc_eth_get_logs_paged` ベースの制限付き実装。
- 範囲・filter制約を超えると `-32005`。

## 対応パターン
- 単一address + `topic0`中心のログ取得
- `topics[0]` の OR配列（最大16件）
- `blockHash` 指定（`fromBlock/toBlock` 併用なし、走査上限内）

## 制約
- `topics[1+]` 条件は現状未対応
- 複数address同時指定は未対応

## 代表エラー
- `logs.range_too_large`
- `logs.too_many_results`
- `UnsupportedFilter`

## 根拠
- `crates/ic-evm-rpc/src/lib.rs`（`rpc_eth_get_logs_paged`）
- `tools/rpc-gateway/src/handlers.ts`
