#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "${ROOT}"

if [[ ! -d .git ]]; then
  git init -b main
fi

git add -A

if git diff --cached --quiet; then
  echo "Нет изменений для коммита"
else
  git commit -m "init: hello-world manifests and argocd apps"
fi

if ! git remote get-url origin &>/dev/null; then
  echo "Создаю публичный репозиторий на GitHub..."
  gh repo create argoCD --public --source=. --remote=origin --push
else
  git push -u origin main
fi

echo ""
echo "REPO_URL для шага 5:"
gh repo view --json url -q .url 2>/dev/null || git remote get-url origin
