# RPC Overview

## TL;DR
- Gateway は canister Candid API を JSON-RPC 2.0 に変換する層です。
- 互換は制限付きで、未対応メソッドがあります。
- 入力不正は主に `-32602`、状態不整合は `-32000/-32001`。

## 対応範囲
- `web3_*`, `net_*`, `eth_*` の一部
- 実装メソッドは `handleRpc` の switch が正本

## できること / できないこと
- できること: 基本参照、call、estimate、raw tx投入
- できないこと: filter/ws/pending完全互換

## Pending/Mempoolポリシー
- Ethereum互換APIとしての pending/mempool（例: `eth_pendingTransactions`, `eth_subscribe`）は未対応。
- ただし canister Candid には `get_pending(tx_id)` があり、送信済み tx を個別追跡できる。
- 送信成功判定は submit戻り値ではなく receipt ベース（`status`）で行う。
- 詳細は以下を参照:
  - `../quickstart.md`
  - `../compatibility/json-rpc-deviations.md`
  - `../compatibility/ethereum-differences.md`
  - `../concepts/accounts-keys.md`
  - `../_generated/interfaces.md`

## 根拠
- `tools/rpc-gateway/src/handlers.ts`（`handleRpc`）
- `tools/rpc-gateway/README.md`
- `crates/ic-evm-wrapper/src/lib.rs`（`get_pending`）
