#!/usr/bin/env bash
# One command: clone fixed NEXUS configs and recover a broken Hyprland session.
set -euo pipefail

REPO="https://github.com/sierengowskisierengowski-cpu/sharkdash.git"
BRANCH="cursor/hyprland-logout-fix-5ffe"
WORKDIR="${TMPDIR:-/tmp}/sharkdash-recover-$$"

cleanup() { rm -rf "$WORKDIR" 2>/dev/null || true; }
trap cleanup EXIT

printf '\033[1;34m::\033[0m Downloading NEXUS recovery configs...\n'
git clone --depth 1 --branch "$BRANCH" "$REPO" "$WORKDIR"

printf '\033[1;34m::\033[0m Running recovery...\n'
chmod +x "$WORKDIR/nexus/scripts/recover.sh"
exec "$WORKDIR/nexus/scripts/recover.sh" --copy "$@"
