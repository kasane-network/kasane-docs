> English version: /en/doc/integration/signing-nonce-retries.html

# Signing, Nonce, Retries

## TL;DR
- nonceは送信前に必ず取得する。
- chain idは `4801360` を一致させる。
- submit 成功後は receipt をポーリングして結果判定する。

## 推奨手順
1. sender address を確定
2. `eth_getTransactionCount` または `expected_nonce_by_address`
3. fee設定（base fee + priorityを考慮）
4. `eth_sendRawTransaction`
5. `eth_getTransactionReceipt` をポーリング

## 落とし穴
- nonce 固定値のハードコード
- receipt の timeout 時に再送して nonce 競合

## 根拠
- `README.md`
- `tools/rpc-gateway/README.md`
- `crates/ic-evm-gateway/src/lib.rs`
