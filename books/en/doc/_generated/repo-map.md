<!-- ja-source-hash: f3bf158b808f3f7d6e91bbe598d48a32bf42b75b -->
> Japanese version: /ja/doc/_generated/repo-map.html

# Repo Map

This page organizes "what lives where" in the Kasane repository using primary sources only.

## TL;DR
- Main EVM canister implementation is `ic-evm-wrapper` in the Rust workspace.
- Execution logic is in `evm-core`, persistence/constants in `evm-db`, and RPC helpers in `ic-evm-rpc`.
- Main developer-facing entry points are `tools/rpc-gateway` (HTTP JSON-RPC) and `crates/ic-evm-wrapper/evm_canister.did` (Candid).
- Indexer is `tools/indexer` (Postgres-first).

## Key Directories
- `crates/ic-evm-wrapper`
  - canister entrypoints (`#[ic_cdk::query]` / `#[ic_cdk::update]`)
  - public Candid definition (`evm_canister.did`)
- `crates/evm-core`
  - tx decode / submit / produce / call / estimate implementation
  - EVM execution and fee calculation (`revm_exec.rs`, `base_fee.rs`)
- `crates/evm-db`
  - stable state, chain constants, runtime defaults, receipt/block/tx types
- `crates/ic-evm-rpc`
  - RPC helper logic called by wrapper (eth reads/transforms)
- `tools/rpc-gateway`
  - translates canister Candid API to Ethereum JSON-RPC 2.0
- `tools/indexer`
  - pulls export API and stores into Postgres
- `scripts`
  - smoke, predeploy, and mainnet deploy helpers
- `docs`
  - operational runbooks and spec notes (usable as primary references)

## Entrypoints
- canister build/runtime
  - `dfx.json` `canisters.evm_canister`
  - `crates/ic-evm-wrapper/src/lib.rs`
- gateway runtime
  - `tools/rpc-gateway/src/main.ts`
  - `tools/rpc-gateway/src/server.ts`
- indexer runtime
  - `tools/indexer/src/main.ts`

## Dependency Outline
- Rust workspace members
  - `Cargo.toml` `[workspace].members`
- JSON-RPC layer responsibilities
  - Gateway: request/response and limits
  - canister: state/execution/persistence

## Out of Scope (for this GitBook)
- node operations (validator/sequencer/full-node operations)
- internal details of upstream libraries under `vendor/`

## Sources
- `Cargo.toml` (workspace members)
- `dfx.json` (canister package/candid)
- `icp.yaml` (deploy recipe)
- `crates/ic-evm-wrapper/src/lib.rs` (canister entrypoint)
- `tools/rpc-gateway/src/main.ts` (gateway entrypoint)
- `tools/indexer/README.md` (indexer responsibilities)
