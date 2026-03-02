#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT_DIR"

if ! command -v mdbook >/dev/null 2>&1; then
  echo "error: mdbook is not installed" >&2
  exit 1
fi

if [[ ! -f book.ja.toml || ! -f book.en.toml || ! -f book.toml ]]; then
  echo "error: required config files are missing" >&2
  exit 1
fi

orig="$(mktemp)"
cp book.toml "$orig"
cleanup() {
  cp "$orig" book.toml
  rm -f "$orig"
}
trap cleanup EXIT

# mdbook v0.5.x does not support selecting arbitrary config files on build.
# Build each language by temporarily swapping book.toml.
cp book.ja.toml book.toml
mdbook build

cp book.en.toml book.toml
mdbook build

echo "ok: built ja/en books into build/ja and build/en"
