#!/usr/bin/env bash

# Set your exact Obsidian vault path (update YOUR_VAULT_NAME)
VAULT_PATH="/Users/mayleenliu/Library/Mobile Documents/iCloud~md~obsidian/Documents/YOUR_VAULT_NAME"

# 1. Force removal of accidental duplicate or nested folders
rm -rf ./content/content
rm -rf "./content/Food 2"
rm -f ./content/Library.base

# 2. Sync Food directory, base files, and images (EXCLUDING Library.base)
rsync -avc --delete \
  --exclude='Library.base' \
  --exclude='Library.base.md' \
  --include='Food/***' \
  --include='*.png' \
  --include='*.jpg' \
  --include='*.jpeg' \
  --include='*.gif' \
  --include='*.webp' \
  --include='*.base' \
  --include='index.md' \
  --exclude='*' \
  "$VAULT_PATH/" ./content/

# 3. Ensure root index.md homepage exists
if [ ! -f "./content/index.md" ]; then
  echo "Creating default content/index.md..."
  cat << 'EOF' > ./content/index.md
---
title: Recipe Book
---

![[Recipe Book.base]]
EOF
fi

# 4. Push updates to GitHub
if [ -n "$(git status --porcelain)" ]; then
  echo "Changes detected, committing and pushing..."
  git add .
  git commit -m "Sync recipes, exclude Library.base, and clean up folders"
  git pull origin main --rebase
  git push origin main
else
  echo "No changes detected. Nothing to push!"
fi