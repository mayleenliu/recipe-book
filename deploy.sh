#!/usr/bin/env bash

VAULT_PATH="/Users/mayleenliu/Library/Mobile Documents/iCloud~md~obsidian/Documents/Mayleen"

# Copy ONLY the Food directory, Recipe Book.base, and index.base
rsync -avc --delete \
  --include='Food/***' \
  --include='Recipe Book.base' \
  --include='index.base' \
  --exclude='*' \
  "$VAULT_PATH/" ./content/

# Check if there are actual git changes before committing
if [ -n "$(git status --porcelain)" ]; then
  echo "Changes detected, committing and pushing..."
  git add .
  git commit -m "Sync recipes and base files only"
  git pull origin main --rebase
  git push origin main
else
  echo "No changes detected. Nothing to push!"
fi