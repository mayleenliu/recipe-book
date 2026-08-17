#!/usr/bin/env bash

# 1. Copy markdown AND .base files from your Obsidian Vault into Quartz content
rsync -av --delete \
  --include='*.base' \
  --include='*.md' \
  --include='*/' \
  --exclude='.git*' \
  '/Users/mayleenliu/Library/Mobile Documents/iCloud~md~obsidian/Documents/Mayleen/' ./content/

# 2. Stage all changes (including .base files)
git add .

# 3. Commit
git commit -m "Update recipes and sync .base files"

# 4. Sync remote and push
git pull origin main --rebase
git push origin main