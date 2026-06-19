#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

trim() { tr -d '[:space:]' < "$1"; }

for overlay in prod dev; do
  trim "$ROOT/services/backend/VERSION" > "$ROOT/manifests/backend/overlays/${overlay}/image-tag.txt"
  trim "$ROOT/services/frontend/VERSION" > "$ROOT/manifests/frontend/overlays/${overlay}/image-tag.txt"
done

echo "Synced image-tag.txt from services/*/VERSION"
