#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="argocd-learning"
CTX="kind-${CLUSTER_NAME}"

echo "==> Установка ArgoCD"
kubectl --context "${CTX}" create namespace argocd --dry-run=client -o yaml | kubectl --context "${CTX}" apply -f -
# server-side apply: на K8s 1.32+ client-side apply ломает CRD applicationsets (annotation > 256KB)
kubectl --context "${CTX}" apply --server-side -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "==> Ожидание готовности ArgoCD..."
kubectl --context "${CTX}" -n argocd rollout status deployment/argocd-server --timeout=300s
kubectl --context "${CTX}" -n argocd rollout status deployment/argocd-repo-server --timeout=300s
kubectl --context "${CTX}" -n argocd rollout status deployment/argocd-applicationset-controller --timeout=300s 2>/dev/null || true

echo "ArgoCD установлен."
