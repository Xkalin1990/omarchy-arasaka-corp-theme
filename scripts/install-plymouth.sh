#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
SRC_DIR="${REPO_DIR}/plymouth/arasaka-terminal"
DEST_DIR="/usr/share/plymouth/themes/arasaka-terminal"
STATE_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/omarchy"
PREV_FILE="${STATE_DIR}/arasaka-prev-plymouth"

if ! command -v plymouth-set-default-theme >/dev/null 2>&1; then
  echo "Warning: 'plymouth-set-default-theme' not found; skipping Plymouth theme install." >&2
  exit 0
fi

if [[ ! -f "${PREV_FILE}" ]]; then
  mkdir -p "${STATE_DIR}"
  plymouth-set-default-theme 2>/dev/null > "${PREV_FILE}" || true
fi

echo "Installing Arasaka Terminal Plymouth bootsplash & reset/shutdown theme to ${DEST_DIR}..."
sudo mkdir -p "${DEST_DIR}"
sudo cp "${SRC_DIR}"/*.png "${SRC_DIR}/arasaka-terminal.plymouth" "${SRC_DIR}/arasaka-terminal.script" "${DEST_DIR}/"

echo "Setting arasaka-terminal as default Plymouth theme and rebuilding initramfs..."
sudo plymouth-set-default-theme -R arasaka-terminal

if command -v limine-mkinitcpio >/dev/null 2>&1; then
  echo "Updating Limine initramfs..."
  sudo limine-mkinitcpio
fi

echo "Done! Current Plymouth theme: $(plymouth-set-default-theme)"
