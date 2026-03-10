> English version: /en/doc/compatibility/precompiles-system-contracts.html

# Precompiles & System Contracts

## TL;DR
- precompile 失敗は `exec.halt.precompile_error` として分類される。
- Kasane は `revm` の mainnet precompile set を利用し、独自のアドレス上書きはしていない。
- 実行時の既定仕様は `SpecId::default = PRAGUE` だが、`0x0a (KZG)`、`0x0b..0x11 (BLS12-381)`、`0x0100 (P256VERIFY)` は現行の公開ビルドでは無効。
- 現行の標準ビルドが公開する安定 precompile は `0x09` まで。
- opcode差分の解説はこのページの責務外（`ethereum-differences.md` を参照）。

## 運用方針
- precompile失敗の分類は `exec.halt.precompile_error` を一次判定に使う。
- precompile依存機能は mainnet 投入前に対象パスをスモークして動作を固定化する。
- `PRAGUE` だから KZG/BLS/P256 が使える、と推定しない。実際に配備されたビルド構成を確認する。

## 対応precompile（現行の標準ビルド）

| Address | Name | 導入段階 | 備考 |
|---|---|---|---|
| `0x01` | `ECREC` | Homestead | secp256k1 ecrecover |
| `0x02` | `SHA256` | Homestead |  |
| `0x03` | `RIPEMD160` | Homestead |  |
| `0x04` | `ID` | Homestead | identity |
| `0x05` | `MODEXP` | Byzantium | Prague では Berlin gas式が適用 |
| `0x06` | `BN254_ADD` | Byzantium | Istanbul 以降はガス更新版 |
| `0x07` | `BN254_MUL` | Byzantium | Istanbul 以降はガス更新版 |
| `0x08` | `BN254_PAIRING` | Byzantium | Istanbul 以降はガス更新版 |
| `0x09` | `BLAKE2F` | Istanbul |  |

## 仕様上は定義されるが、現行の標準ビルドでは無効

| Address | Name | 仕様 | 現行の標準ビルド |
|---|---|---|---|
| `0x0a` | `KZG_POINT_EVALUATION` | Cancun | 無効 |
| `0x0b` | `BLS12_G1ADD` | Prague | 無効 |
| `0x0c` | `BLS12_G1MSM` | Prague | 無効 |
| `0x0d` | `BLS12_G2ADD` | Prague | 無効 |
| `0x0e` | `BLS12_G2MSM` | Prague | 無効 |
| `0x0f` | `BLS12_PAIRING_CHECK` | Prague | 無効 |
| `0x10` | `BLS12_MAP_FP_TO_G1` | Prague | 無効 |
| `0x11` | `BLS12_MAP_FP2_TO_G2` | Prague | 無効 |
| `0x0100` | `P256VERIFY` | Osaka | 無効 |

## 実装上の前提
- `evm-core` は `Context::mainnet().build_mainnet_with_inspector(...)` で `revm` の mainnet builder をそのまま使う。
- mainnet builder 側で `EthPrecompiles::new(spec)` を使って precompile set が決まり、その後に実際のビルド構成で絞られる。
- `SpecId::default()` は `PRAGUE`。
- 現行の標準ビルドでは KZG/BLS/P256 関連アドレスを無効化する。

## 観測可能な事実
- 実行系エラー分類に `PrecompileError` が存在
- gateway canister 側で `exec.halt.precompile_error` にマップされる

## 安全な使い方
- precompile依存機能では、`exec.halt.precompile_error` を監視/分類してリトライ判定を分離する
- precompile前提のdAppでは、mainnet投入前に当該pathをスモークする

## 落とし穴
- ingress検証とruntime precompile責務を混同する
- `SpecId::default() == PRAGUE` なら `0x0a..0x11` も有効化済みだと誤認する
- `0x0100 (P256VERIFY)` を常に有効と誤認する
- KZG/BLS/P256 の有無を実際のビルド構成ではなく spec 名だけで判断する

## 関連ページ
- `ethereum-differences.md`（opcode/tx type/finality差分）

## 根拠
- `crates/ic-evm-gateway/src/lib.rs`（`exec.halt.precompile_error`）
- `crates/evm-core/src/revm_exec.rs`
- `crates/evm-core/Cargo.toml`（`revm` feature）
- `vendor/revm/crates/handler/src/mainnet_builder.rs`
- `vendor/revm/crates/primitives/src/hardfork.rs`
- `vendor/revm/crates/precompile/Cargo.toml`
- `vendor/revm/crates/precompile/src/lib.rs`
- `vendor/revm/crates/precompile/src/id.rs`
- `vendor/revm/crates/precompile/src/bls12_381_const.rs`
- `vendor/revm/crates/precompile/src/secp256r1.rs`
