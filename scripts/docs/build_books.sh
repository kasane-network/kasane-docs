#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT_DIR"

if ! command -v mdbook >/dev/null 2>&1; then
  echo "error: mdbook is not installed" >&2
  exit 1
fi

if [[ ! -f books/ja/book.toml || ! -f books/en/book.toml ]]; then
  echo "error: required config files are missing" >&2
  exit 1
fi

# Build each language from its own book root.
mdbook build books/ja --dest-dir build/ja
mdbook build books/en --dest-dir build/en

echo "ok: built ja/en books into build/ja and build/en"
