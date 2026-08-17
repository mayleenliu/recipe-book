#!/usr/bin/env bash

# Copy files from your vault to content
rsync -av --delete --exclude='.git*' '/Users/mayleenliu/Library/Mobile Documents/iCloud~md~obsidian/Documents/Mayleen/Food/' ./content/

# Push changes to GitHub
git add content/
git commit -m "Update recipe content"
git push origin main
