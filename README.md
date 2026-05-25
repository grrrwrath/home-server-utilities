# home-server-utilities

Automation scripts for the Mac Mini home server.

## Scripts

### scripts/sync_aios_queue.sh
Pulls markdown files from Google Drive (Agent/AIOS_Queue) into the
local aios repo, commits and pushes to GitHub.

Cron: */5 * * * * /Users/grrrwrath/Botclave/apps/home-server-utilities/scripts/sync_aios_queue.sh

## Structure
scripts/   — automation scripts
logs/      — runtime logs (gitignored)
