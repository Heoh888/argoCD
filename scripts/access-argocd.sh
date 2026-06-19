#!/usr/bin/env bash
set -euo pipefail

export KUBECONFIG="${KUBECONFIG:-${HOME}/.kube/k3s-argocd-learning.yaml}"

PASSWORD="$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' 2>/dev/null | base64 -d)"

echo "KUBECONFIG: ${KUBECONFIG}"
echo "ArgoCD UI: https://localhost:8080 (игнорируй TLS warning)"
echo "Логин: admin"
echo "Пароль: ${PASSWORD:-<секрет ещё не создан, подожди 30 сек>}"
echo ""
echo "Запуск port-forward (Ctrl+C для остановки):"
kubectl port-forward svc/argocd-server -n argocd 8080:443
