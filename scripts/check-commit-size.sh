#!/bin/bash

# Check commit size and warn if too large
# This script is run as part of the pre-commit hook

MAX_LINES=1000

STAGED_FILES=$(git diff --cached --shortstat)
INSERTIONS=$(echo "$STAGED_FILES" | grep -oP '\d+(?= insertion)' || echo "0")
DELETIONS=$(echo "$STAGED_FILES" | grep -oP '\d+(?= deletion)' || echo "0")

TOTAL=$((INSERTIONS + DELETIONS))

if [ "$TOTAL" -gt "$MAX_LINES" ]; then
  echo ""
  echo "⚠️  Warning: Large commit detected ($TOTAL lines changed)"
  echo ""
  echo "Consider splitting this commit into smaller changes:"
  echo "  1. Implementation changes"
  echo "  2. Test updates"
  echo "  3. Documentation"
  echo ""
  echo "Use 'git reset HEAD^' to unstage and split the commit."
  echo ""
  read -p "Continue with large commit? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Commit cancelled."
    exit 1
  fi
fi
