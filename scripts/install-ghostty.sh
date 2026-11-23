#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
SRC_DIR="${REPO_DIR}/ghostty"
DEST_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/ghostty"

mkdir -p "${DEST_DIR}/assets" "${DEST_DIR}/shaders"

if [[ -f "${DEST_DIR}/config" ]]; then
  BACKUP_FILE="${DEST_DIR}/config.bak.$(date +%s)"
  echo "Backing up existing Ghostty config to ${BACKUP_FILE}..."
  cp "${DEST_DIR}/config" "${BACKUP_FILE}"
fi

echo "Installing Arasaka Corp Ghostty theme to ${DEST_DIR}..."
cp "${SRC_DIR}/config" "${DEST_DIR}/config"
cp "${SRC_DIR}/shaders/arasaka-hud.glsl" "${DEST_DIR}/shaders/arasaka-hud.glsl"
cp "${SRC_DIR}/assets/"* "${DEST_DIR}/assets/"
sed "s|__HOME__|${HOME}|g" "${SRC_DIR}/gtk-arasaka.css" > "${DEST_DIR}/gtk-arasaka.css"

if command -v ghostty >/dev/null 2>&1; then
  ghostty +validate-config
  echo "Ghostty config validated."
fi

echo "Done! Press Ctrl+Shift+, in Ghostty (or open a new window) to apply."
