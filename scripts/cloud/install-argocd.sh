#!/usr/bin/env bash
set -euo pipefail

ARGOCD_NS="argocd"
INSTALL_URL="https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"

echo "==> Установка ArgoCD в namespace ${ARGOCD_NS}"
kubectl create namespace "${ARGOCD_NS}" --dry-run=client -o yaml | kubectl apply -f -
kubectl apply --server-side -n "${ARGOCD_NS}" -f "${INSTALL_URL}"

echo "==> Ожидание готовности..."
kubectl -n "${ARGOCD_NS}" rollout status deployment/argocd-server --timeout=300s
kubectl -n "${ARGOCD_NS}" rollout status deployment/argocd-repo-server --timeout=300s

echo "ArgoCD установлен в namespace ${ARGOCD_NS}."
