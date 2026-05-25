#!/bin/bash
# ============================================================
# sync_aios_queue.sh
# Pulls Gemini MD files from Google Drive AIOS_Queue into
# the aios GitHub repo
# ============================================================
# Cron: */5 * * * * /Users/grrrwrath/Botclave/apps/home-server-utilities/scripts/sync_aios_queue.sh
# ============================================================

set -euo pipefail

AIOS_REPO="/Users/grrrwrath/Botclave/apps/aios"
QUEUE="$AIOS_REPO/📥 workspace/planning/queue"
LOG="/Users/grrrwrath/Botclave/apps/home-server-utilities/logs/sync_aios_queue.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

mkdir -p "$(dirname "$LOG")"

echo "[$TIMESTAMP] Starting sync..." >> "$LOG"

# ── Step 1: Pull from Google Drive ──
rclone move "GoogleDrive:/AIOS_Queue" "$QUEUE/" \
  --atomic \
  --log-file="$LOG" \
  --log-level INFO

# ── Step 2: Check for new files ──
cd "$AIOS_REPO"
STATUS=$(git status --porcelain)

if [ -z "$STATUS" ]; then
  echo "[$TIMESTAMP] No new files. Exiting." >> "$LOG"
  exit 0
fi

# ── Step 3: Commit and push ──
echo "[$TIMESTAMP] New files detected — committing..." >> "$LOG"
git add .
git commit -m "aios: auto-sync queue [$TIMESTAMP]"
git push origin main

echo "[$TIMESTAMP] ✓ Done." >> "$LOG"
