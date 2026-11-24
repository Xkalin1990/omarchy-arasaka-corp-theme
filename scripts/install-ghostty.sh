#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
SRC_DIR="${REPO_DIR}/ghostty"
DEST_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/ghostty"

mkdir -p "${DEST_DIR}/assets" "${DEST_DIR}/shaders"

TMP_CONFIG="$(mktemp)"
TMP_CSS="$(mktemp)"
trap 'rm -f "${TMP_CONFIG}" "${TMP_CSS}"' EXIT

python3 - "${SRC_DIR}/config" "${TMP_CONFIG}" "${DEST_DIR}" <<'PY'
import sys
src, dst, cfg_dir = sys.argv[1:4]
with open(src, "r", encoding="utf-8") as f:
    text = f.read()
with open(dst, "w", encoding="utf-8") as f:
    f.write(text.replace("__CONFIG_DIR__", cfg_dir))
PY

python3 - "${SRC_DIR}/gtk-arasaka.css" "${TMP_CSS}" "${DEST_DIR}" <<'PY'
import sys
src, dst, cfg_dir = sys.argv[1:4]
with open(src, "r", encoding="utf-8") as f:
    text = f.read()
with open(dst, "w", encoding="utf-8") as f:
    f.write(text.replace("__CONFIG_DIR__", cfg_dir))
PY

if [[ -f "${DEST_DIR}/config" ]] && ! cmp -s "${TMP_CONFIG}" "${DEST_DIR}/config"; then
  BACKUP_FILE="${DEST_DIR}/config.bak.$(date +%s)"
  echo "Backing up existing Ghostty config to ${BACKUP_FILE}..."
  cp "${DEST_DIR}/config" "${BACKUP_FILE}"
fi

echo "Installing Arasaka Corp Ghostty theme to ${DEST_DIR}..."
cp "${TMP_CONFIG}" "${DEST_DIR}/config"
cp "${SRC_DIR}/shaders/arasaka-hud.glsl" "${DEST_DIR}/shaders/arasaka-hud.glsl"
cp "${SRC_DIR}/assets/"* "${DEST_DIR}/assets/"
cp "${TMP_CSS}" "${DEST_DIR}/gtk-arasaka.css"

if command -v ghostty >/dev/null 2>&1; then
  ghostty +validate-config
  echo "Ghostty config validated."
fi

echo "Done! Press Ctrl+Shift+, in Ghostty (or open a new window) to apply."
