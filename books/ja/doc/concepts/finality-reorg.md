> English version: /en/doc/concepts/finality-reorg.html

# Finality & Reorg

## TL;DR
- 本実装は単一ブロックプロデューサ（sequencer）前提で、reorgを前提とする運用モデルは想定しない。
- submitとexecuteは分離されるため、receipt監視が必要。

## 見え方
- `eth_sendRawTransaction` は投入
- 実行確定は後続blockで反映

## 注意点
- submit成功時点で状態確定したとみなす
- Ethereum L1のfork前提ロジックをそのまま持ち込む

## 根拠
- `README.md`
- `tools/rpc-gateway/README.md`
- `crates/ic-evm-gateway/src/lib.rs`
