#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
THEME_SLUG="arasaka-corp"
DEST_DIR="${HOME}/.config/omarchy/themes/${THEME_SLUG}"

echo "Installing Arasaka Corp Omarchy theme to ${DEST_DIR}..."
mkdir -p "${DEST_DIR}/backgrounds"

cp "${REPO_DIR}/colors.toml" "${DEST_DIR}/colors.toml"
cp "${REPO_DIR}/icons.theme" "${DEST_DIR}/icons.theme"
cp "${REPO_DIR}/LICENSE" "${DEST_DIR}/LICENSE"
cp "${REPO_DIR}/backgrounds/"* "${DEST_DIR}/backgrounds/"

if command -v omarchy >/dev/null 2>&1; then
  echo "Applying ${THEME_SLUG} theme..."
  omarchy theme set "${THEME_SLUG}"
else
  echo "Note: 'omarchy' command not found. Theme files copied to ${DEST_DIR}."
fi

echo "Done! Arasaka Corp theme installed."
