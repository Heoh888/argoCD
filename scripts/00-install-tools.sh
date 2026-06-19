#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> Установка kind (если не установлен)"
if ! command -v kind &>/dev/null; then
  brew install kind
fi

echo "==> kind: $(kind version)"
