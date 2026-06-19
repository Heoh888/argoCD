#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="argocd-learning"
CTX="kind-${CLUSTER_NAME}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> Шаг 3: деплой hello-world через kubectl"
kubectl --context "${CTX}" apply -k "${ROOT}/manifests/hello-world/"

echo "Проверка:"
kubectl --context "${CTX}" -n hello-world get all
echo "Открой http://localhost:30081"
