> English version: /en/doc/integration/sdks.html

# SDKs

## TL;DR
- 専用SDKより、JSON-RPCクライアント（ethers/viem/foundry）利用が主。
- canister直呼びは Candid 経由で可能。

## 根拠
- `tools/rpc-gateway/package.json`
- `crates/ic-evm-gateway/evm_canister.did`
