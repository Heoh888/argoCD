#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CLUSTER_NAME="argocd-learning"

if ! docker info &>/dev/null; then
  echo "Docker не запущен. Открой Docker Desktop и повтори команду."
  exit 1
fi

echo "==> Создание kind-кластера: ${CLUSTER_NAME}"
if kind get clusters 2>/dev/null | grep -qx "${CLUSTER_NAME}"; then
  echo "Кластер уже существует, пропускаем"
else
  kind create cluster --name "${CLUSTER_NAME}" --config "${ROOT}/clusters/kind-config.yaml"
fi

kubectl cluster-info --context "kind-${CLUSTER_NAME}"
echo "Кластер готов. Context: kind-${CLUSTER_NAME}"
