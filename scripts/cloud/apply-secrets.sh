#!/usr/bin/env bash
set -euo pipefail

ENV="${ENV:-prod}"
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
export KUBECONFIG="${KUBECONFIG:-${HOME}/.kube/k3s-argocd-${ENV}.yaml}"

ENV_FILE="${ENV_FILE:-${ROOT}/secrets/${ENV}/backend.secret.env}"
NS="${NS:-app}"
SECRET_NAME="${SECRET_NAME:-backend-secret}"
DEPLOYMENT="${DEPLOYMENT:-backend}"

if [[ ! -f "${ENV_FILE}" ]]; then
  echo "Нет файла: ${ENV_FILE}"
  echo "Создай: mkdir -p secrets/${ENV} && cp secrets/backend.secret.env.example secrets/${ENV}/backend.secret.env"
  exit 1
fi

kubectl create namespace "${NS}" --dry-run=client -o yaml | kubectl apply -f -

kubectl create secret generic "${SECRET_NAME}" \
  --namespace="${NS}" \
  --from-env-file="${ENV_FILE}" \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl rollout restart "deployment/${DEPLOYMENT}" -n "${NS}"
kubectl rollout status "deployment/${DEPLOYMENT}" -n "${NS}" --timeout=120s

echo "Secret ${SECRET_NAME} (${ENV}) обновлён."
