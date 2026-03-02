# Ethereum Differences

## TL;DR
- 互換対象は Ethereum JSON-RPC + EVM実行意味論（完全互換ではない）。
- tx type は Legacy/EIP-2930/EIP-1559 を受理、EIP-4844/EIP-7702 は現状未受理。
- opcode は Kasane 独自の追加/改変を行わず、採用中 spec（現状PRAGUE）の範囲に従う。
- pending/mempool 系APIは一部未実装（`eth_pendingTransactions` など）。
- canister Candid では `get_pending(tx_id)` による個別追跡を提供する。
- 単一ブロックプロデューサ（sequencer）前提で、reorgを前提とする運用モデルは想定しない。

注: pending/mempoolの運用ポリシーの正本は `../rpc/overview.md`。

## 対応範囲

### できること
- Eth signed tx の投入・実行・receipt参照
- `eth_call` / `eth_estimateGas`（制限付き）
- ブロック/tx/receipt/log の参照

### 制約がある領域
- 4844 blob tx / 7702 authorization tx は現状未受理
- mempoolやfilter/WebSocket購読は制限付き（互換差分あり）

## トランザクション互換
- Supported
  - Legacy (RLP)
  - EIP-2930 (`tx_type=1`)
  - EIP-1559 (`tx_type=2`)
- 現在未受理
  - EIP-4844 (`type=0x03`)
  - EIP-7702 (`type=0x04`)

## opcode差分
- Kasane 独自の opcode 追加/挙動改変は行わない。
- 実際の有効範囲は `revm` の採用specに依存し、現行デフォルトは `PRAGUE`。

## feeモデル差分
- `base_fee` は保持され、`compute_next_base_fee` で更新される。
- `effective_gas_price` は `max_fee`, `max_priority_fee`, `base_fee` から計算。
- `eth_gasPrice` は `max(base_fee + max(推定priority,min_priority), min_gas_price)` を返す。

## finality/reorg差分
- 単一ブロックプロデューサ（sequencer）前提
- `auto-production` 後ブロックは final 扱い（reorg前提では扱わない）
- `latest/pending/safe/finalized` の一部は head扱いの制約あり

## 代表エラー
- `DecodeError::UnsupportedType`（4844/7702）
- `DecodeError::WrongChainId`
- `DecodeError::LegacyChainIdMissing`

## 落とし穴
- Ethereum L1と同じ pending/finalityモデルを前提にする
- 4844/7702 tx を送って互換がある前提で実装する

## 根拠
- `crates/evm-core/src/tx_decode.rs`
- `crates/evm-core/tests/phase1_eth_decode.rs`
- `crates/evm-core/src/base_fee.rs`
- `crates/evm-core/src/revm_exec.rs`
- `vendor/revm/crates/handler/src/mainnet_builder.rs`
- `vendor/revm/crates/primitives/src/hardfork.rs`
- `tools/rpc-gateway/README.md`
- `README.md`
