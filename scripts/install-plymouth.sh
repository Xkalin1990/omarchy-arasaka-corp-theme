#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
SRC_DIR="${REPO_DIR}/plymouth/arasaka-terminal"
DEST_DIR="/usr/share/plymouth/themes/arasaka-terminal"

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
