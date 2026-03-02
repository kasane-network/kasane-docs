> English version: /en/doc/compatibility/precompiles-system-contracts.html

# Precompiles & System Contracts

## TL;DR
- precompile 失敗は `exec.halt.precompile_error` として分類される。
- Kasane は `revm` の mainnet precompile set を利用し、独自のアドレス上書きはしていない。
- 現行実装は `SpecId::default = PRAGUE` のため、OSAKA追加の `0x0100 (P256VERIFY)` はデフォルトでは有効化されない。
- opcode差分の解説はこのページの責務外（`ethereum-differences.md` を参照）。

## 運用方針
- precompile失敗の分類は `exec.halt.precompile_error` を一次判定に使う。
- precompile依存機能は mainnet 投入前に対象パスをスモークして動作を固定化する。

## 対応precompile（現行デフォルト: PRAGUE）

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
| `0x0a` | `KZG_POINT_EVALUATION` | Cancun | 現行ビルドで有効（検証バックエンドは `c-kzg` / `blst` / `arkworks`） |
| `0x0b` | `BLS12_G1ADD` | Prague | EIP-2537 |
| `0x0c` | `BLS12_G1MSM` | Prague | EIP-2537 |
| `0x0d` | `BLS12_G2ADD` | Prague | EIP-2537 |
| `0x0e` | `BLS12_G2MSM` | Prague | EIP-2537 |
| `0x0f` | `BLS12_PAIRING_CHECK` | Prague | EIP-2537 |
| `0x10` | `BLS12_MAP_FP_TO_G1` | Prague | EIP-2537 |
| `0x11` | `BLS12_MAP_FP2_TO_G2` | Prague | EIP-2537 |

### OSAKAで追加されるが、現行デフォルトでは未有効
- `0x0100` (`P256VERIFY`, RIP-7212)

## 実装上の前提
- `evm-core` は `Context::mainnet().build_mainnet_with_inspector(...)` で `revm` の mainnet builder をそのまま使う。
- mainnet builder 側で `EthPrecompiles::new(spec)` を使って precompile set が決まる。
- `SpecId::default()` は `PRAGUE`。

## 観測可能な事実
- 実行系エラー分類に `PrecompileError` が存在
- wrapper側で `exec.halt.precompile_error` にマップされる

## 安全な使い方
- precompile依存機能では、`exec.halt.precompile_error` を監視/分類してリトライ判定を分離する
- precompile前提のdAppでは、mainnet投入前に当該pathをスモークする

## 落とし穴
- ingress検証とruntime precompile責務を混同する
- `0x0100 (P256VERIFY)` を常に有効と誤認する
- `0x0a (KZG)` の検証バックエンド差分（`c-kzg` / `blst` / `arkworks`）を考慮しない

## 関連ページ
- `ethereum-differences.md`（opcode/tx type/finality差分）

## 根拠
- `crates/ic-evm-wrapper/src/lib.rs`（`exec.halt.precompile_error`）
- `crates/evm-core/src/revm_exec.rs`
- `crates/evm-core/Cargo.toml`（`revm` feature）
- `vendor/revm/crates/handler/src/mainnet_builder.rs`
- `vendor/revm/crates/primitives/src/hardfork.rs`
- `vendor/revm/crates/precompile/src/lib.rs`
- `vendor/revm/crates/precompile/src/id.rs`
- `vendor/revm/crates/precompile/src/bls12_381_const.rs`
- `vendor/revm/crates/precompile/src/secp256r1.rs`
