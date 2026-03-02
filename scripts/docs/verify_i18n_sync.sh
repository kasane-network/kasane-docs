#!/usr/bin/env bash
set -euo pipefail

JA_ROOT="books/ja/doc"
EN_ROOT="books/en/doc"

if [[ ! -d "$JA_ROOT" || ! -d "$EN_ROOT" ]]; then
  echo "error: books/ja/doc or books/en/doc is missing" >&2
  exit 1
fi

ja_list="$(mktemp)"
en_list="$(mktemp)"
trap 'rm -f "$ja_list" "$en_list"' EXIT

find "$JA_ROOT" -type f -name '*.md' | sed "s#^$JA_ROOT/##" | sort > "$ja_list"
find "$EN_ROOT" -type f -name '*.md' | sed "s#^$EN_ROOT/##" | sort > "$en_list"

if ! diff -u "$ja_list" "$en_list"; then
  echo "error: ja/en markdown path sets do not match" >&2
  exit 1
fi

while IFS= read -r rel; do
  ja_file="$JA_ROOT/$rel"
  en_file="$EN_ROOT/$rel"

  expected_hash="$(git hash-object "$ja_file")"
  first_line="$(head -n 1 "$en_file")"

  if [[ ! "$first_line" =~ ^\<\!--\ ja-source-hash:\ ([0-9a-f]{40})\ --\>$ ]]; then
    echo "error: missing or invalid ja-source-hash header: $en_file" >&2
    exit 1
  fi

  actual_hash="${BASH_REMATCH[1]}"
  if [[ "$actual_hash" != "$expected_hash" ]]; then
    echo "error: hash mismatch for $en_file" >&2
    echo "  expected: $expected_hash" >&2
    echo "  actual:   $actual_hash" >&2
    exit 1
  fi

done < "$ja_list"

echo "ok: ja/en docs paths and source hashes are in sync"
