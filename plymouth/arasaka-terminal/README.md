# Arasaka Terminal Plymouth Theme

Cyberpunk 2077 Arasaka Corporation security terminal Plymouth theme for boot, LUKS unlock, reboot, and shutdown screens.

## Features

- **Boot / LUKS Unlock**: `SECURITY LOGIN` prompt with `UID_` prefix, masked password bullets, and `ACCESS GRANTED // BOOTING` transition.
- **Reboot**: `SYSTEM REBOOT` with `REBOOTING SYSTEM...` status.
- **Shutdown**: `SYSTEM SHUTDOWN` with `SHUTTING DOWN...` status.
- **Glitch intro & animated corner/scan accents** in Arasaka red (`#e50000`) on charcoal (`#110d0e`).

## Prerequisites

- `plymouth`
- `JetBrainsMono Nerd Font` (included by default on Omarchy)

## Install

```bash
git clone https://github.com/Xkalin1990/arasaka-terminal-plymouth.git
cd arasaka-terminal-plymouth
./install.sh
```

`install.sh` copies the theme to `/usr/share/plymouth/themes/arasaka-terminal`, sets `arasaka-terminal` as the default Plymouth theme (`plymouth-set-default-theme -R arasaka-terminal`), and runs `limine-mkinitcpio` if present.

## Regenerating Assets (Optional)

If you want to tweak or regenerate the PNG assets from `arasaka_wordmark.svg` and the script's palette:

```bash
python3 generate_assets.py
```
