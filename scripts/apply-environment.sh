#!/usr/bin/env bash
set -euo pipefail

ENV="${ENV:-prod}"

if [[ "${ENV}" != "prod" && "${ENV}" != "dev" ]]; then
  echo "ENV должен быть prod или dev"
  exit 1
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export KUBECONFIG="${KUBECONFIG:-${HOME}/.kube/k3s-argocd-${ENV}.yaml}"

kubectl apply -f "${ROOT}/apps/environments/${ENV}/root.yaml"

echo "App of Apps (${ENV}) применён. ArgoCD подтянет ветку ${ENV}==$([[ "${ENV}" == prod ]] && echo main || echo dev)"
