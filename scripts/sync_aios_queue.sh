#!/bin/bash
set -euo pipefail
export PATH="/opt/homebrew/bin:$PATH"

AIOS_REPO="/Users/grrrwrath/Botclave/apps/aios"
INCOMING="$AIOS_REPO/inbox/incoming"
RCLONE_REMOTE="GoogleDrive:/"
LOG_PREFIX="[aios-transporter]"

mkdir -p "$INCOMING"
cd "$AIOS_REPO"
git pull --rebase --quiet origin main 2>/dev/null || true

rclone move "$RCLONE_REMOTE" "$INCOMING/" \
  --include "inbox_*" \
  --verbose \
  2>&1 | while read -r line; do echo "$(date '+%Y-%m-%d %H:%M:%S') $LOG_PREFIX $line"; done

cd "$AIOS_REPO"
if [ -n "$(git status --porcelain inbox/incoming/)" ]; then
  git pull --rebase --quiet origin main 2>/dev/null || true
  git add inbox/incoming/
  git commit -m "inbox: transport $(git status --porcelain inbox/incoming/ | wc -l | tr -d ' ') file(s) from Drive"
  git push origin main || {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $LOG_PREFIX Push failed, will retry next tick."
  }
  echo "$(date '+%Y-%m-%d %H:%M:%S') $LOG_PREFIX Committed and pushed new files."
else
  echo "$(date '+%Y-%m-%d %H:%M:%S') $LOG_PREFIX No new files."
fi
