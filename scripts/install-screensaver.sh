#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
SRC_FILE="${REPO_DIR}/screensaver/screensaver.txt"
CONFIG_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}"
DEST_DIR="${CONFIG_DIR}/omarchy/branding"
DEST_FILE="${DEST_DIR}/screensaver.txt"

mkdir -p "${DEST_DIR}"

if [[ -f "${DEST_FILE}" ]] && ! cmp -s "${SRC_FILE}" "${DEST_FILE}"; then
  BACKUP_FILE="${DEST_FILE}.bak.$(date +%s)"
  echo "Backing up existing screensaver to ${BACKUP_FILE}..."
  cp "${DEST_FILE}" "${BACKUP_FILE}"
fi

echo "Installing Arasaka Corp screensaver to ${DEST_FILE}..."
cp "${SRC_FILE}" "${DEST_FILE}"

echo "Done! Test it with: omarchy launch screensaver force"
