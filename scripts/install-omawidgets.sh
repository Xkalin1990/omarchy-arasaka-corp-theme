#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
SRC_DIR="${REPO_DIR}/omawidgets"
PLUGINS_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/omarchy/plugins"
DEST_DIR="${PLUGINS_DIR}/io.github.fabandrade88.omawidgets"
UPSTREAM_REPO="https://github.com/fabandrade88/OmaWidgets.git"

if [[ ! -d "${DEST_DIR}" ]]; then
  echo "OmaWidgets plugin not found at ${DEST_DIR}."
  echo "Cloning upstream OmaWidgets (${UPSTREAM_REPO})..."
  mkdir -p "${PLUGINS_DIR}"
  git clone "${UPSTREAM_REPO}" "${DEST_DIR}"
fi

echo "Installing Arasaka Corp HUD styling for OmaWidgets (Performance, Battery, Power profile)..."
mkdir -p "${DEST_DIR}/assets" "${DEST_DIR}/cards" "${DEST_DIR}/ui"
cp "${SRC_DIR}/assets/"* "${DEST_DIR}/assets/"
cp "${SRC_DIR}/cards/"* "${DEST_DIR}/cards/"
cp "${SRC_DIR}/ui/"* "${DEST_DIR}/ui/"

if command -v omarchy >/dev/null 2>&1; then
  echo "Restarting Omarchy shell to load new QML singletons and assets..."
  omarchy restart shell || true
fi

echo "Done! Arasaka HUD styling is active whenever the 'arasaka-corp' theme is selected."
