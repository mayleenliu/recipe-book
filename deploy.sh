#!/usr/bin/env bash

set -euo pipefail

# Set your exact Obsidian vault path
VAULT_PATH="/Users/mayleenliu/Library/Mobile Documents/iCloud~md~obsidian/Documents/Mayleen"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTENT_PATH="$SCRIPT_DIR/content"

cd "$SCRIPT_DIR"

# Update first so generated content is never present during a rebase.
git pull origin main --rebase --autostash

# 1. Force removal of accidental duplicate or nested folders
rm -rf "$CONTENT_PATH/content"
rm -rf "$CONTENT_PATH/Food 2"
rm -f "$CONTENT_PATH/Library.base"

# 2. Mirror recipes and the recipe book definition from Obsidian
rsync -avc --delete "$VAULT_PATH/food/" "$CONTENT_PATH/food/"
rsync -avc "$VAULT_PATH/Recipe Book.base" "$CONTENT_PATH/Recipe Book.base"

# 3. Ensure root index.md homepage exists
if [ ! -f "$CONTENT_PATH/index.md" ]; then
  echo "Creating default content/index.md..."
  cat << 'EOF' > "$CONTENT_PATH/index.md"
---
title: Recipe Book
---

![[Recipe Book.base]]
EOF
fi

# 4. Push updates to GitHub
if [ -n "$(git status --porcelain -- content)" ]; then
  echo "Changes detected, committing and pushing..."
  git add content
  git commit -m "Sync recipes"
else
  echo "No new content changes detected. Checking for pending commits..."
fi

git push origin main