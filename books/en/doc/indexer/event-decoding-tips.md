<!-- ja-source-hash: fbe15427d01ef36c0fd39a8c79b2c8923051eeb8 -->
> Japanese version: /ja/doc/indexer/event-decoding-tips.html

# Event Decoding Tips

## TL;DR
- For ERC-20 Transfer extraction, strictly validate topic/data lengths.
- Malformed logs should be skipped per row to avoid stopping the full pipeline.

## Sources
- `tools/indexer/README.md`
- `tools/indexer/src/decode_receipt.ts`
