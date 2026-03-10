<!-- ja-source-hash: 48390ecee4df0353c4ddd7acedf76f4929882ab6 -->
> Japanese version: /ja/doc/compatibility/precompiles-system-contracts.html

# Precompiles & System Contracts

## TL;DR
- Precompile failures are classified as `exec.halt.precompile_error`.
- Kasane uses `revm` mainnet precompile set without custom address overrides.
- Current runtime default is `SpecId::default = PRAGUE`, but `0x0a (KZG)`, `0x0b..0x11 (BLS12-381)`, and `0x0100 (P256VERIFY)` are disabled in the current public/default build.
- The current default build exposes the stable precompile set through `0x09`.
- Opcode-level discussion is out of scope for this page (see `ethereum-differences.md`).

## Operational Policy
- Use `exec.halt.precompile_error` as the primary classifier for precompile failures.
- Smoke-test precompile-dependent paths before mainnet rollout.
- Do not infer KZG/BLS/P256 availability from `PRAGUE` alone; verify the deployed build contract.

## Supported Precompiles (Current Default Build)

| Address | Name | Introduced In | Notes |
|---|---|---|---|
| `0x01` | `ECREC` | Homestead | secp256k1 ecrecover |
| `0x02` | `SHA256` | Homestead |  |
| `0x03` | `RIPEMD160` | Homestead |  |
| `0x04` | `ID` | Homestead | identity |
| `0x05` | `MODEXP` | Byzantium | Berlin gas formula applies under Prague |
| `0x06` | `BN254_ADD` | Byzantium | gas-updated since Istanbul |
| `0x07` | `BN254_MUL` | Byzantium | gas-updated since Istanbul |
| `0x08` | `BN254_PAIRING` | Byzantium | gas-updated since Istanbul |
| `0x09` | `BLAKE2F` | Istanbul |  |

## Spec-Defined but Disabled in the Current Default Build

| Address | Name | Spec | Current Default Build |
|---|---|---|---|
| `0x0a` | `KZG_POINT_EVALUATION` | Cancun | disabled |
| `0x0b` | `BLS12_G1ADD` | Prague | disabled |
| `0x0c` | `BLS12_G1MSM` | Prague | disabled |
| `0x0d` | `BLS12_G2ADD` | Prague | disabled |
| `0x0e` | `BLS12_G2MSM` | Prague | disabled |
| `0x0f` | `BLS12_PAIRING_CHECK` | Prague | disabled |
| `0x10` | `BLS12_MAP_FP_TO_G1` | Prague | disabled |
| `0x11` | `BLS12_MAP_FP2_TO_G2` | Prague | disabled |
| `0x0100` | `P256VERIFY` | Osaka | disabled |

## Implementation Assumptions
- `evm-core` uses `Context::mainnet().build_mainnet_with_inspector(...)` and directly relies on `revm` mainnet builder.
- Precompile set is selected via `EthPrecompiles::new(spec)` on the mainnet builder side, then constrained by the deployed build contract.
- `SpecId::default()` is `PRAGUE`.
- The current default build disables KZG/BLS/P256-related addresses.

## Observable Facts
- Execution error taxonomy includes `PrecompileError`.
- Wrapper maps it to `exec.halt.precompile_error`.

## Safe Usage
- For precompile-dependent features, monitor/classify `exec.halt.precompile_error` separately from retry logic.
- For precompile-critical dApps, smoke-test the exact path before mainnet rollout.

## Pitfalls
- Mixing ingress validation responsibility with runtime precompile responsibility
- Assuming `SpecId::default() == PRAGUE` means `0x0a..0x11` are deployed
- Assuming `0x0100 (P256VERIFY)` is always enabled
- Ignoring build-contract differences for KZG/BLS/P256 when validating a target deployment

## Related Page
- `ethereum-differences.md` (opcode/tx type/finality differences)

## Sources
- `crates/ic-evm-gateway/src/lib.rs` (`exec.halt.precompile_error`)
- `crates/evm-core/src/revm_exec.rs`
- `crates/evm-core/Cargo.toml` (`revm` feature)
- `vendor/revm/crates/handler/src/mainnet_builder.rs`
- `vendor/revm/crates/primitives/src/hardfork.rs`
- `vendor/revm/crates/precompile/Cargo.toml`
- `vendor/revm/crates/precompile/src/lib.rs`
- `vendor/revm/crates/precompile/src/id.rs`
- `vendor/revm/crates/precompile/src/bls12_381_const.rs`
- `vendor/revm/crates/precompile/src/secp256r1.rs`
