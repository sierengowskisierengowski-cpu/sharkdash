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

## Troubleshooting login / logout loops

If you log in and get kicked back to the greeter as soon as you open an app,
the most common cause is a **Hyprland config syntax mismatch** after a system
update (Hyprland 0.53+ changed window rules and some dispatch commands).

### Quick recovery (from a TTY: `Ctrl+Alt+F3`)

1. Check Hyprland version and config errors:

   ```bash
   hyprctl version
   hyprctl reload 2>&1 | head -20
   journalctl --user -u hyprland -b --no-pager | tail -50
   ```

2. Temporarily disable idle locking while debugging:

   ```bash
   pkill hypridle
   ```

3. Re-run the installer to pull fixed configs:

   ```bash
   cd /path/to/sharkdash/nexus
   ./scripts/install.sh --no-packages
   hyprctl reload
   ```

4. If you still get bounced to login, start Hyprland manually from the TTY to
   see errors on screen:

   ```bash
   Hyprland
   ```

### What usually causes this

| Symptom | Likely cause |
| ------- | ------------ |
| Kicked out when opening any app | Old `windowrule = float, class:...` syntax (fixed in this repo) |
| Black screen or "exit session" only lock | `loginctl lock-session` + Hyprland 0.54 internal lock conflict |
| Session ends immediately at login | Broken autostart binary (check `~/.config/hypr/hyprland.conf` `exec-once` lines) |
| Accidental logout | `SUPER+M` is bound to `exit` (quit Hyprland) |

This config uses **Hyprland 0.53+ window rules** (`match:class ...`) and calls
`hyprlock` directly instead of relying on `loginctl lock-session` for idle
timeouts.
