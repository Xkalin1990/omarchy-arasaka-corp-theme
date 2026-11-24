# arasaka-ghostty

Custom Ghostty terminal theme & graphics setup tailored for Omarchy's `arasaka-corp` theme:

- Centered low-opacity Cyberpunk 2077 Samurai oni-mask watermark (`assets/samurai-logo.png`)
- Full-window subtle CRT + crimson HUD corner shader (`shaders/arasaka-hud.glsl`)
- Custom GTK CSS styling window/tab chrome + bottom-right netrunner status (`gtk-arasaka.css`)

## Prerequisites

- `ghostty`
- `Liberation Mono` font
- `python3` (used by `install.sh` to template config paths)
- Omarchy dynamic theme file (`~/.local/state/omarchy/current/theme/ghostty.conf`, optional)

## Install

From the repository root:

```bash
./install.sh --ghostty
```

Or from this directory:

```bash
./install.sh
```

`install.sh` backs up any existing `~/.config/ghostty/config`, installs the config, shader, assets, and CSS, and validates the config with `ghostty +validate-config`. Press `Ctrl+Shift+,` in Ghostty (or open a new window) to apply.

> **Battery tip:** `config` sets `custom-shader-animation = true`. Set it to `false` in `~/.config/ghostty/config` if you prefer lower idle GPU usage.
