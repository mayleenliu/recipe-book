#!/usr/bin/env bash

# Sync only files that have actually changed (using content checksums)
rsync -avc --delete \
  --include='*.base' \
  --include='*.md' \
  --include='*/' \
  --exclude='.git*' \
  '/Users/mayleenliu/Library/Mobile Documents/iCloud~md~obsidian/Documents/Mayleen/' ./content/

# Check if there are actual git changes before committing
if [ -n "$(git status --porcelain)" ]; then
  echo "Changes detected, committing and pushing..."
  git add .
  git commit -m "Update recipes and sync .base files"
  git pull origin main --rebase
  git push origin main
else
  echo "No content changes detected. Nothing to push!"
fi