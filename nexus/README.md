# NEXUS · Hyprland Desktop

A clean, keyboard-driven [Hyprland](https://hyprland.org/) desktop configuration
with a Tokyo Night aesthetic. Batteries included: bar, launcher, lockscreen,
notifications, idle management, and a themed terminal.

## Components

| Area          | Tool        | Config                        |
| ------------- | ----------- | ----------------------------- |
| Compositor    | Hyprland    | `hypr/hyprland.conf`          |
| Wallpaper     | hyprpaper   | `hypr/hyprpaper.conf`         |
| Idle / DPMS   | hypridle    | `hypr/hypridle.conf`          |
| Lockscreen    | hyprlock    | `hypr/hyprlock.conf`          |
| Status bar    | Waybar      | `waybar/config.jsonc`, `style.css` |
| Launcher      | Rofi        | `rofi/config.rasi`, `nexus.rasi` |
| Notifications | dunst       | `dunst/dunstrc`               |
| Terminal      | kitty       | `kitty/kitty.conf`            |

## Install

```bash
git clone <this-repo> && cd sharkdash/nexus
./scripts/install.sh          # installs packages (Arch) + symlinks configs
./scripts/install.sh --no-packages   # only symlink configs
```

The installer symlinks each config into `~/.config` (backing up any existing
files as `*.bak`) and copies wallpapers into `~/.config/hypr/wallpapers/`.

## Keybindings (highlights)

`SUPER` is the main modifier.

| Keys                | Action                    |
| ------------------- | ------------------------- |
| `SUPER + Return`    | Terminal (kitty)          |
| `SUPER + Space`     | App launcher (rofi)       |
| `SUPER + Q`         | Close window              |
| `SUPER + E`         | File manager              |
| `SUPER + B`         | Browser                   |
| `SUPER + F`         | Fullscreen                |
| `SUPER + V`         | Toggle floating           |
| `SUPER + L`         | Lock screen               |
| `SUPER + C`         | Clipboard history         |
| `SUPER + [1-0]`     | Switch workspace          |
| `SUPER + SHIFT + [1-0]` | Move window to workspace |
| `Print`             | Screenshot region → clipboard |

## Customization

- **Colors**: the Tokyo Night palette lives inline in each config; search for
  hex values like `#7aa2f7` (accent) to retheme.
- **Wallpaper**: place `nexus.jpg` in `wallpapers/` before installing.
- **Monitors**: edit the `monitor =` line in `hypr/hyprland.conf`.
