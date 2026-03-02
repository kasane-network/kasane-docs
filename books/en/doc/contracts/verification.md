<!-- ja-source-hash: 4ae2448a2b099d24146b7aa6ca9b01492008d162 -->
> Japanese version: /ja/doc/contracts/verification.html

# Verification

## TL;DR
- Verify feature is provided on the Explorer side.
- For preflight checks, key rotation, and monitoring operation, use `docs/ops/verify_runbook.md` as the source of truth.

## Operational Steps (Overview)
1. Set `EXPLORER_VERIFY_ENABLED=1` and allow-listed compiler version environment variables.
2. Run `npm run verify:preflight` in `tools/explorer` to verify allowed `solc` availability.
3. Submit verification via `POST /api/verify/submit` and track status via `GET /api/verify/status`.

## Sources
- `tools/explorer/README.md`
- `docs/ops/verify_runbook.md`
