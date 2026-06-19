#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="argocd-learning"
CTX="kind-${CLUSTER_NAME}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

REPO_URL="${REPO_URL:-}"

if [[ -z "${REPO_URL}" ]]; then
  echo "Укажи URL: REPO_URL=https://github.com/USER/argoCD ./scripts/05-deploy-hello-world-argocd.sh"
  exit 1
fi

TMP="$(mktemp)"
sed "s|REPO_URL|${REPO_URL}|g" "${ROOT}/apps/hello-world.yaml" > "${TMP}"

echo "==> Шаг 5: деплой hello-world через ArgoCD (repo: ${REPO_URL})"
kubectl --context "${CTX}" apply -f "${TMP}"
rm -f "${TMP}"

sleep 5
kubectl --context "${CTX}" -n argocd get application hello-world
