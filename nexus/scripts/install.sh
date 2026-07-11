#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════╗
# ║              NEXUS · Hyprland desktop installer                ║
# ╚══════════════════════════════════════════════════════════════╝
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

PACKAGES=(
    hyprland hyprpaper hypridle hyprlock
    waybar rofi dunst kitty
    grim slurp wl-clipboard cliphist
    brightnessctl playerctl
    polkit-gnome network-manager-applet pavucontrol
    thunar ttf-jetbrains-mono-nerd papirus-icon-theme
    qt6ct
)

info()  { printf '\033[1;34m::\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m!!\033[0m %s\n' "$*"; }

install_packages() {
    if command -v pacman >/dev/null 2>&1; then
        info "Installing packages via pacman…"
        sudo pacman -S --needed --noconfirm "${PACKAGES[@]}" || \
            warn "Some packages failed (AUR ones may need yay/paru)."
    else
        warn "Non-Arch system detected. Install these manually: ${PACKAGES[*]}"
    fi
}

link_config() {
    local src="$1" dest="$2"
    if [[ -e "$dest" && ! -L "$dest" ]]; then
        info "Backing up existing $dest -> $dest.bak"
        mv "$dest" "$dest.bak"
    fi
    mkdir -p "$(dirname "$dest")"
    ln -sfn "$src" "$dest"
    info "Linked $dest"
}

main() {
    info "NEXUS install starting (repo: $REPO_DIR)"

    if [[ "${1:-}" != "--no-packages" ]]; then
        install_packages
    fi

    link_config "$REPO_DIR/hypr/hyprland.conf"  "$CONFIG_HOME/hypr/hyprland.conf"
    link_config "$REPO_DIR/hypr/hypridle.conf"  "$CONFIG_HOME/hypr/hypridle.conf"
    link_config "$REPO_DIR/hypr/hyprlock.conf"  "$CONFIG_HOME/hypr/hyprlock.conf"
    link_config "$REPO_DIR/hypr/hyprpaper.conf" "$CONFIG_HOME/hypr/hyprpaper.conf"
    link_config "$REPO_DIR/waybar/config.jsonc" "$CONFIG_HOME/waybar/config.jsonc"
    link_config "$REPO_DIR/waybar/style.css"    "$CONFIG_HOME/waybar/style.css"
    link_config "$REPO_DIR/rofi/config.rasi"    "$CONFIG_HOME/rofi/config.rasi"
    link_config "$REPO_DIR/rofi/nexus.rasi"     "$CONFIG_HOME/rofi/nexus.rasi"
    link_config "$REPO_DIR/dunst/dunstrc"       "$CONFIG_HOME/dunst/dunstrc"
    link_config "$REPO_DIR/kitty/kitty.conf"    "$CONFIG_HOME/kitty/kitty.conf"

    mkdir -p "$CONFIG_HOME/hypr/wallpapers"
    if [[ -d "$REPO_DIR/wallpapers" ]]; then
        cp -n "$REPO_DIR"/wallpapers/* "$CONFIG_HOME/hypr/wallpapers/" 2>/dev/null || true
    fi

    info "Done! Log into a Hyprland session to start NEXUS."
    warn "Add a wallpaper at $CONFIG_HOME/hypr/wallpapers/nexus.jpg"
}

main "$@"
