> English version: /en/doc/_generated/repo-map.html

# Repo Map

このページは、Kasane リポジトリの「どこに何があるか」を一次情報だけで整理したものです。

## TL;DR
- EVM canister本体は Rust workspace の `ic-evm-gateway`。
- 実行ロジックは `evm-core`、永続化/定数は `evm-db`、RPC補助は `ic-evm-rpc`。
- 外部開発者向け入口は `tools/rpc-gateway`（HTTP JSON-RPC）と `crates/ic-evm-gateway/evm_canister.did`（Candid）。
- indexer は `tools/indexer`（Postgres を中心に利用）。

## 主要ディレクトリ
- `crates/ic-evm-gateway`
  - canisterエントリポイント（`#[ic_cdk::query]` / `#[ic_cdk::update]`）
  - Candid公開定義（`evm_canister.did`）
- `crates/evm-core`
  - tx decode / submit / produce / call / estimate 実装
  - EVM実行とfee計算（`revm_exec.rs`, `base_fee.rs`）
- `crates/evm-db`
  - stable state、chain constants、実行時既定値、receipt/block/tx 型
- `crates/ic-evm-rpc`
  - gateway canister から呼ばれる RPC 補助ロジック（eth 系の参照/変換）
- `tools/rpc-gateway`
  - canister Candid API を Ethereum JSON-RPC 2.0 へ変換
- `tools/indexer`
  - export API を取得して Postgres へ保存
- `scripts`
  - 動作確認 / 事前デプロイ / mainnet デプロイ補助
- `docs`
  - 運用 runbook・仕様メモ（一次情報として参照可能）

## エントリポイント
- canister の build/runtime
  - `dfx.json` の `canisters.evm_canister`
  - `crates/ic-evm-gateway/src/lib.rs`
- gateway の runtime
  - `tools/rpc-gateway/src/main.ts`
  - `tools/rpc-gateway/src/server.ts`
- indexer の runtime
  - `tools/indexer/src/main.ts`

## 依存関係の大枠
- Rust workspace の members
  - `Cargo.toml` `[workspace].members`
- JSON-RPC層の実装責務
  - Gateway: request/responseと制限
  - canister: state/実行/永続化

## 非対象（本GitBookで扱わない）
- ノード運営（validator/sequencer/full node運用手順）
- `vendor/` 配下の上流ライブラリ内部詳細

## 根拠
- `Cargo.toml`（workspace の members）
- `dfx.json`（canister package/candid）
- `icp.yaml`（deploy recipe）
- `crates/ic-evm-gateway/src/lib.rs`（canister entrypoint）
- `tools/rpc-gateway/src/main.ts`（gateway entrypoint）
- `tools/indexer/README.md`（indexer責務）
