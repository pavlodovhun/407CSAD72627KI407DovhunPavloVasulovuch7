#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

mkdir -p build dist

cmake -S "$ROOT_DIR" -B "$ROOT_DIR/build" -DCMAKE_BUILD_TYPE=Release
cmake --build "$ROOT_DIR/build" --config Release
ctest --test-dir "$ROOT_DIR/build" -C Release --output-on-failure

if [ -f "$ROOT_DIR/build/hello" ]; then
  cp "$ROOT_DIR/build/hello" "$ROOT_DIR/dist/hello"
else
  echo "Missing built hello executable at $ROOT_DIR/build/hello" >&2
  exit 1
fi
