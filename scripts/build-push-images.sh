#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REGISTRY="${REGISTRY:-ghcr.io/heoh888}"
TAG="${TAG:-latest}"

echo "==> Build и push frontend + backend → ${REGISTRY}"

docker build -t "${REGISTRY}/argocd-learning-frontend:${TAG}" "${ROOT}/services/frontend"
docker build -t "${REGISTRY}/argocd-learning-backend:${TAG}" "${ROOT}/services/backend"

docker push "${REGISTRY}/argocd-learning-frontend:${TAG}"
docker push "${REGISTRY}/argocd-learning-backend:${TAG}"

echo "Готово. Images:"
echo "  ${REGISTRY}/argocd-learning-frontend:${TAG}"
echo "  ${REGISTRY}/argocd-learning-backend:${TAG}"
