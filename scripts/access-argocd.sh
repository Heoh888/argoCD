#!/usr/bin/env bash
set -euo pipefail

ENV="${ENV:-prod}"
export KUBECONFIG="${KUBECONFIG:-${HOME}/.kube/k3s-argocd-${ENV}.yaml}"

PASSWORD="$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' 2>/dev/null | base64 -d)"

echo "ENV: ${ENV}"
echo "KUBECONFIG: ${KUBECONFIG}"
echo "ArgoCD UI: https://localhost:8080"
echo "Логин: admin"
echo "Пароль: ${PASSWORD:-<секрет ещё не создан>}"
echo ""
kubectl port-forward svc/argocd-server -n argocd 8080:443
