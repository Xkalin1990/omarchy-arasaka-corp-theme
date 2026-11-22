#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${REPO_DIR}/scripts"

usage() {
  cat <<EOF
Arasaka Corp Theme Bundle Installer for Omarchy

Usage: $(basename "$0") [OPTIONS]

Without options, installs the complete Arasaka Corp bundle:
  1. Omarchy theme (colors.toml, Omarchroma-Icons, wallpapers)
  2. Plymouth bootsplash & reset/shutdown screen (arasaka-terminal)
  3. Omarchy terminal screensaver (screensaver.txt)

Options:
  --all          Install all components (default)
  --theme        Install only the Omarchy theme (colors, icons, wallpapers)
  --plymouth     Install only the Plymouth bootsplash & reset/shutdown screen
  --screensaver  Install only the Omarchy terminal screensaver
  -h, --help     Show this help message

Individual component scripts are also available in ./scripts/:
  ./scripts/install-theme.sh
  ./scripts/install-plymouth.sh
  ./scripts/install-screensaver.sh
EOF
}

DO_THEME=false
DO_PLYMOUTH=false
DO_SCREENSAVER=false

if [[ $# -eq 0 ]]; then
  DO_THEME=true
  DO_PLYMOUTH=true
  DO_SCREENSAVER=true
else
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --all)
        DO_THEME=true
        DO_PLYMOUTH=true
        DO_SCREENSAVER=true
        ;;
      --theme)
        DO_THEME=true
        ;;
      --plymouth)
        DO_PLYMOUTH=true
        ;;
      --screensaver)
        DO_SCREENSAVER=true
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        echo "Unknown option: $1" >&2
        usage >&2
        exit 1
        ;;
    esac
    shift
  done
fi

echo "=========================================="
echo "  ARASAKA CORP // OMARCHY THEME BUNDLE"
echo "=========================================="

if [[ "${DO_THEME}" == true ]]; then
  echo ""
  echo "[1/3] Theme (colors, icons, wallpaper)..."
  bash "${SCRIPTS_DIR}/install-theme.sh"
fi

if [[ "${DO_PLYMOUTH}" == true ]]; then
  echo ""
  echo "[2/3] Plymouth bootsplash & reset/shutdown screen..."
  bash "${SCRIPTS_DIR}/install-plymouth.sh"
fi

if [[ "${DO_SCREENSAVER}" == true ]]; then
  echo ""
  echo "[3/3] Terminal screensaver..."
  bash "${SCRIPTS_DIR}/install-screensaver.sh"
fi

echo ""
echo "=========================================="
echo "  ARASAKA CORP INSTALLATION COMPLETE"
echo "=========================================="
