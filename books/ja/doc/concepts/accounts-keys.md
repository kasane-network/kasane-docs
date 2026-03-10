> English version: /en/doc/concepts/accounts-keys.html

# Accounts & Keys

## TL;DR
- senderは `EthSigned` と `IcSynthetic` で導出経路が異なる。
- `expected_nonce_by_address` は 20 bytes address 前提。
- `IcSynthetic` は `from` を payload で受け取らず、caller 情報から決定される。

## できること
- Eth signed tx の署名 sender を使う
- Principal 由来 sender（IcSynthetic）を使う

## 制約
- bytes32 風の値を 20 bytes address として扱う

## `EthSigned` と `IcSynthetic` の違い
- `EthSigned`
  - 署名済み raw tx から sender を復元
  - chain id 検証を伴う
- `IcSynthetic`
  - gateway canister が `msg_caller()` と `canister_self()` を付与して `TxIn::IcSynthetic` として投入
  - payloadに `from` を持たない
  - sender 導出失敗は `AddressDerivationFailed` 系エラーになる

## `IcSynthetic` で必ず押さえる点
- `submit_ic_tx` の入力は Candid `record`（`to/value/gas_limit/nonce/max_fee_per_gas/max_priority_fee_per_gas/data`）
- 内部保存時の canonical bytes は `to_flag(0/1)` 形式
- nonce参照は `expected_nonce_by_address` を使う
- 戻り値は `eth_tx_hash` ではなく `tx_id`
- 実行確定は submit 時点ではなく、後続 block で receipt を参照して判断する

## 安全な使い方
1. caller に対応する 20 bytes アドレスを確定する
2. `expected_nonce_by_address` で nonce を取る
3. `submit_ic_tx` を送る
4. `get_pending(tx_id)` / `get_receipt(tx_id)` で追跡する

pending/mempool運用ポリシーの正本は `../rpc/overview.md` を参照。

## 落とし穴
- Principal エンコード値をそのまま address として投入する
- `expected_nonce_by_address` に 20 bytes 以外を渡す
- `tx_id` を `eth_tx_hash` と同一視する
- submit成功を実行成功と誤認する

## 根拠
- `crates/ic-evm-gateway/src/lib.rs`（`expected_nonce_by_address`）
- `crates/evm-core/src/tx_decode.rs`（`IcSynthetic` / `EthSigned`）
- `crates/evm-core/src/chain.rs`（`TxIn::IcSynthetic`）
- `README.md`
