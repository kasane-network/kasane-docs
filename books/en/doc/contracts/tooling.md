<!-- ja-source-hash: 76c7afdf9d058a3da734e5967b73b285a4e61f93 -->
> Japanese version: /ja/doc/contracts/tooling.html

# Tooling (Hardhat/Foundry/ethers/viem)

## TL;DR
- Smoke tests for ethers/viem/foundry are available in the repository.
- Start with a minimal set: reads + call/estimate + receipt monitoring.

## Minimal Flow
- viem: `tools/rpc-gateway/smoke/viem_smoke.ts`
- ethers: `tools/rpc-gateway/smoke/ethers_smoke.ts`
- foundry: `tools/rpc-gateway/smoke/foundry_smoke.sh`

## Pitfalls
- Dropping revert data and losing root-cause visibility
- Not storing tx hash and losing observability

## Sources
- `tools/rpc-gateway/smoke/viem_smoke.ts`
- `tools/rpc-gateway/smoke/ethers_smoke.ts`
- `tools/rpc-gateway/smoke/foundry_smoke.sh`
