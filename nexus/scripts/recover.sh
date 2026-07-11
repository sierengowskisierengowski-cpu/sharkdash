#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════╗
# ║         NEXUS · Hyprland crash-loop recovery script          ║
# ╚══════════════════════════════════════════════════════════════╝
# Run this on the broken Hyprland machine (TTY: Ctrl+Alt+F3 works).
# You can copy this repo from your COSMIC PC via USB, SSH, or git clone.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
HYPR_DIR="$CONFIG_HOME/hypr"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$CONFIG_HOME/hypr.recovery-backup-$STAMP"
COPY_MODE=false
SKIP_PACKAGES=true

info()  { printf '\033[1;34m::\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m!!\033[0m %s\n' "$*"; }
die()   { printf '\033[1;31mxx\033[0m %s\n' "$*" >&2; exit 1; }

usage() {
    cat <<'EOF'
Usage: recover.sh [options]

Fixes Hyprland safe-mode / logout loops by installing known-good NEXUS configs.

Options:
  --copy            Copy configs instead of symlinking (best for USB transfers)
  --with-packages   Also install Arch packages via pacman
  -h, --help        Show this help

Typical flow from your COSMIC machine:
  1. Download this repo (git clone or copy to USB)
  2. Move it to the Hyprland PC
  3. On the Hyprland PC (Ctrl+Alt+F3), run:
       cd /path/to/sharkdash/nexus
       ./scripts/recover.sh --copy
  4. Ctrl+Alt+F1 and log in again
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --copy) COPY_MODE=true; shift ;;
        --with-packages) SKIP_PACKAGES=false; shift ;;
        -h|--help) usage; exit 0 ;;
        *) die "Unknown option: $1 (try --help)" ;;
    esac
done

backup_existing() {
    if [[ -d "$HYPR_DIR" ]]; then
        info "Backing up $HYPR_DIR -> $BACKUP_DIR"
        cp -a "$HYPR_DIR" "$BACKUP_DIR"
    else
        warn "No existing $HYPR_DIR found; starting fresh."
    fi
}

remove_crash_triggers() {
    mkdir -p "$HYPR_DIR"

    # Hyprland 0.55+ prefers .lua; a broken lua file causes safe-mode loops.
    if [[ -f "$HYPR_DIR/hyprland.lua" ]]; then
        info "Moving broken hyprland.lua aside"
        mv "$HYPR_DIR/hyprland.lua" "$HYPR_DIR/hyprland.lua.broken-$STAMP"
    fi

    # Stop idle lock fighting the session while recovering.
    pkill hypridle 2>/dev/null || true
}

install_file() {
    local src="$1" dest="$2"
    mkdir -p "$(dirname "$dest")"

    if [[ -e "$dest" && ! -L "$dest" ]]; then
        mv "$dest" "$dest.bak-$STAMP"
    elif [[ -L "$dest" ]]; then
        rm -f "$dest"
    fi

    if $COPY_MODE; then
        cp "$src" "$dest"
        info "Copied $dest"
    else
        ln -sfn "$src" "$dest"
        info "Linked $dest"
    fi
}

install_configs() {
    install_file "$REPO_DIR/hypr/hyprland.conf"  "$HYPR_DIR/hyprland.conf"
    install_file "$REPO_DIR/hypr/hypridle.conf"  "$HYPR_DIR/hypridle.conf"
    install_file "$REPO_DIR/hypr/hyprlock.conf"  "$HYPR_DIR/hyprlock.conf"
    install_file "$REPO_DIR/hypr/hyprpaper.conf" "$HYPR_DIR/hyprpaper.conf"
    install_file "$REPO_DIR/waybar/config.jsonc" "$CONFIG_HOME/waybar/config.jsonc"
    install_file "$REPO_DIR/waybar/style.css"    "$CONFIG_HOME/waybar/style.css"
    install_file "$REPO_DIR/rofi/config.rasi"    "$CONFIG_HOME/rofi/config.rasi"
    install_file "$REPO_DIR/rofi/nexus.rasi"     "$CONFIG_HOME/rofi/nexus.rasi"
    install_file "$REPO_DIR/dunst/dunstrc"       "$CONFIG_HOME/dunst/dunstrc"
    install_file "$REPO_DIR/kitty/kitty.conf"    "$CONFIG_HOME/kitty/kitty.conf"

    mkdir -p "$HYPR_DIR/wallpapers"
}

maybe_install_packages() {
    if $SKIP_PACKAGES; then
        info "Skipping package install (pass --with-packages to enable)"
        return 0
    fi
    "$REPO_DIR/scripts/install.sh"
}

print_next_steps() {
    cat <<EOF

$(info "Recovery files installed.")

Next steps:
  1. Press Ctrl+Alt+F1 (or F2) and log into Hyprland
  2. If it works, your old config is at: $BACKUP_DIR
  3. If it still crashes, from TTY run:
       ls -lt ~/.cache/hyprland/
       cat ~/.cache/hyprland/hyprlandCrashReport*.txt | tail -30

To downgrade Hyprland (if gesture crash persists):
  ls -lt /var/cache/pacman/pkg/hyprland*
  sudo pacman -U /var/cache/pacman/pkg/<older-hyprland.pkg.tar.zst>
EOF
}

main() {
    info "NEXUS recovery starting (repo: $REPO_DIR)"
    backup_existing
    remove_crash_triggers
    install_configs
    maybe_install_packages
    print_next_steps
}

main "$@"
