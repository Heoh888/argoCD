#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="argocd-learning"
CTX="kind-${CLUSTER_NAME}"

PASSWORD="$(kubectl --context "${CTX}" -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' 2>/dev/null | base64 -d)"

echo "ArgoCD UI: https://localhost:8080 (игнорируй TLS warning)"
echo "Логин: admin"
echo "Пароль: ${PASSWORD:-<секрет ещё не создан, подожди 30 сек>}"
echo ""
echo "Запуск port-forward (Ctrl+C для остановки):"
kubectl --context "${CTX}" port-forward svc/argocd-server -n argocd 8080:443
