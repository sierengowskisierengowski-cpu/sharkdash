# Sharkdash

A terminal resource monitor inspired by [btop++](https://github.com/aristocratos/btop). Sharkdash shows real-time CPU, memory, disk, network, and process stats in a polished TUI — with full theme support and a custom ocean-themed default palette.

## Features

- CPU, memory, disk, network, and process monitoring
- Game-inspired menu system with full mouse support
- Process filtering, sorting, tree view, and signal sending
- Auto-scaling network graphs and disk I/O meters
- **40+ themes** (bpytop/bashtop `.theme` format compatible)
- Custom **shark** theme with deep-ocean colors (default)
- Configurable layout via `~/.config/sharkdash/sharkdash.conf`

## Requirements

- Linux (primary platform)
- C++23 compiler (g++ 13+ or clang 16+)
- `make`, `pkg-config` (optional, for GPU support)

## Build

```bash
git clone https://github.com/sierengowskisierengowski-cpu/sharkdash.git
cd sharkdash
make -j$(nproc)
```

The binary is built to `bin/sharkdash`.

## Install

```bash
sudo make install
```

This installs:
- Binary: `/usr/local/bin/sharkdash`
- Themes: `/usr/local/share/sharkdash/themes/`
- Config directory: `~/.config/sharkdash/`

## Run

```bash
./bin/sharkdash
# or after install:
sharkdash
```

## Themes

Themes use the same `.theme` format as btop++/bpytop/bashtop. Place custom themes in:

```
~/.config/sharkdash/themes/
```

Change theme in the Options menu (`m` or `Esc`) or in `sharkdash.conf`:

```
color_theme = "shark"
```

Built-in themes: `Default`, `TTY`, plus all files in `themes/` (nord, dracula, gruvbox, shark, etc.).

## Keybindings

| Key | Action |
|-----|--------|
| `Esc` / `m` | Open menu |
| `↑` / `↓` | Select process |
| `f` | Filter processes |
| `k` | Kill selected process |
| `t` | Toggle tree view |
| `p` | Pause process list |
| `q` | Quit |

## Configuration

Config file: `~/.config/sharkdash/sharkdash.conf`

Created automatically on first run. All options are editable from the in-app Options menu.

## Credits

Based on [btop++](https://github.com/aristocratos/btop) by Aristocratos (Apache 2.0). Rebranded and maintained as **Sharkdash**.

## License

Apache License 2.0 — see [LICENSE](LICENSE).
