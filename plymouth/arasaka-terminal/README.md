# Arasaka Terminal Plymouth Theme

Cyberpunk 2077 Arasaka Corporation security terminal Plymouth theme for boot, LUKS unlock, reboot, and shutdown screens.

## Features

- **Boot / LUKS Unlock**: `SECURITY LOGIN` prompt with `UID_` prefix, masked password bullets, and `ACCESS GRANTED // BOOTING` transition.
- **Reboot**: `SYSTEM REBOOT` with `REBOOTING SYSTEM...` status.
- **Shutdown**: `SYSTEM SHUTDOWN` with `SHUTTING DOWN...` status.
- **Glitch intro & animated corner/scan accents** in Arasaka red (`#e50000`) on charcoal (`#110d0e`).

## Prerequisites

- `plymouth`
- `sudo` access (to install to `/usr/share/plymouth/themes/arasaka-terminal` and rebuild initramfs)
- `JetBrainsMono Nerd Font` (included by default on Omarchy)

## Install

From the repository root:

```bash
./install.sh --plymouth
```

Or from this directory:

```bash
./install.sh
```

`install.sh` saves your previous Plymouth theme, copies the theme to `/usr/share/plymouth/themes/arasaka-terminal`, sets `arasaka-terminal` as the default Plymouth theme (`sudo plymouth-set-default-theme -R arasaka-terminal`), and runs `sudo limine-mkinitcpio` if present.

## Regenerating Assets (Optional)

If you want to tweak or regenerate the PNG assets (requires `python3`, `Pillow`, `librsvg`/`rsvg-convert`, `fontconfig`, and `noto-fonts-cjk`):

```bash
python3 generate_assets.py
```
