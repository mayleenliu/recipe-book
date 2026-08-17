#!/usr/bin/env bash

# Set your Obsidian vault path (update YOUR_VAULT_NAME)
VAULT_PATH="/Users/mayleenliu/Library/Mobile Documents/iCloud~md~obsidian/Documents/Mayleen"

# 1. Clean up accidental nested folders if they exist
rm -rf ./content/content

# 2. Sync Food folder, .base files, and index.md from vault
rsync -avc --delete \
  --include='Food/***' \
  --include='*.base' \
  --include='index.md' \
  --exclude='*' \
  "$VAULT_PATH/" ./content/

# 3. Fallback: If no index.md was synced from vault, create one automatically
if [ ! -f "./content/index.md" ]; then
  echo "No index.md found in vault root. Creating default content/index.md..."
  cat << 'EOF' > ./content/index.md
---
title: Recipe Book
---

Welcome to my recipe collection!

![[Recipe Book.base]]
EOF
fi

# 4. Commit and Push changes
if [ -n "$(git status --porcelain)" ]; then
  echo "Changes detected, committing and pushing..."
  git add .
  git commit -m "Ensure index.md exists and sync recipes"
  git pull origin main --rebase
  git push origin main
else
  echo "No changes detected. Nothing to push!"
fi