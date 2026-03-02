<!-- ja-source-hash: 8fbdee11d4641c3f934be758fb12b087958aeae3 -->
> Japanese version: /ja/doc/rpc/errors-and-limits.html

# Errors & Limits

## TL;DR
- Control is applied in two layers: HTTP constraints (body/batch/depth) and RPC constraints (blockTag/filter/range).
- Main error codes are `-32602/-32000/-32001/-32005`.

## Gateway HTTP Limits
- `RPC_GATEWAY_MAX_HTTP_BODY_SIZE`
- `RPC_GATEWAY_MAX_BATCH_LEN`
- `RPC_GATEWAY_MAX_JSON_DEPTH`

## RPC Errors
- `-32602 invalid params`
- `-32000 state unavailable / execution failed`
- `-32001 resource not found`
- `-32005 limit exceeded`

## Sources
- `tools/rpc-gateway/src/server.ts`
- `tools/rpc-gateway/src/handlers.ts`
- `tools/rpc-gateway/src/config.ts`
