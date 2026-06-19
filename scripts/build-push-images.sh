#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REGISTRY="${REGISTRY:-ghcr.io/heoh888}"
TAG="${TAG:-latest}"
GH_USER="${GH_USER:-Heoh888}"

login_ghcr() {
  if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    echo "${GITHUB_TOKEN}" | docker login ghcr.io -u "${GH_USER}" --password-stdin
    return
  fi

  if command -v gh &>/dev/null; then
    if ! gh auth status &>/dev/null; then
      echo "Войди в gh: gh auth login"
      exit 1
    fi
    # нужен scope write:packages
    if ! gh auth status 2>&1 | grep -q write:packages; then
      echo "Добавляем scope write:packages к gh token..."
      gh auth refresh -s write:packages,read:packages
    fi
    gh auth token | docker login ghcr.io -u "${GH_USER}" --password-stdin
    return
  fi

  echo "Задай GITHUB_TOKEN или установи gh и выполни: gh auth refresh -s write:packages"
  exit 1
}

echo "==> Login ghcr.io"
login_ghcr

echo "==> Build и push (linux/amd64 для VPS) → ${REGISTRY}"

docker buildx build --platform linux/amd64 \
  -t "${REGISTRY}/argocd-frontend:${TAG}" \
  --push "${ROOT}/services/frontend"

docker buildx build --platform linux/amd64 \
  -t "${REGISTRY}/argocd-backend:${TAG}" \
  --push "${ROOT}/services/backend"

echo "Готово. Images:"
echo "  ${REGISTRY}/argocd-frontend:${TAG}"
echo "  ${REGISTRY}/argocd-backend:${TAG}"
echo ""
echo "Сделай packages публичными: GitHub → Packages → каждый image → Package settings → Public"
