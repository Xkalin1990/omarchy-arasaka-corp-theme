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
  4. Ghostty terminal theme & CRT HUD shader (config, assets, shaders, gtk-arasaka.css)
  5. OmaWidgets Arasaka HUD cards (Performance, Battery, Power profile)
  6. Global Hyprland CRT phosphor glow shader (shaders/crt-scanlines.glsl)

Options:
  --all          Install all components (default)
  --theme        Install only the Omarchy theme (colors, icons, wallpapers)
  --plymouth     Install only the Plymouth bootsplash & reset/shutdown screen
  --screensaver  Install only the Omarchy terminal screensaver
  --ghostty      Install only the Ghostty terminal theme & shader
  --omawidgets   Install only the OmaWidgets Arasaka HUD card styling
  --shader       Install only the global Hyprland CRT phosphor glow shader
  -h, --help     Show this help message

Individual component scripts are also available in ./scripts/:
  ./scripts/install-theme.sh
  ./scripts/install-plymouth.sh
  ./scripts/install-screensaver.sh
  ./scripts/install-ghostty.sh
  ./scripts/install-omawidgets.sh
  ./scripts/install-shader.sh
EOF
}

DO_THEME=false
DO_PLYMOUTH=false
DO_SCREENSAVER=false
DO_GHOSTTY=false
DO_OMAWIDGETS=false
DO_SHADER=false

if [[ $# -eq 0 ]]; then
  DO_THEME=true
  DO_PLYMOUTH=true
  DO_SCREENSAVER=true
  DO_GHOSTTY=true
  DO_OMAWIDGETS=true
  DO_SHADER=true
else
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --all)
        DO_THEME=true
        DO_PLYMOUTH=true
        DO_SCREENSAVER=true
        DO_GHOSTTY=true
        DO_OMAWIDGETS=true
        DO_SHADER=true
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
      --ghostty)
        DO_GHOSTTY=true
        ;;
      --omawidgets)
        DO_OMAWIDGETS=true
        ;;
      --shader)
        DO_SHADER=true
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

TOTAL_STEPS=0
for flag in "${DO_THEME}" "${DO_PLYMOUTH}" "${DO_SCREENSAVER}" "${DO_GHOSTTY}" "${DO_OMAWIDGETS}" "${DO_SHADER}"; do
  [[ "${flag}" == true ]] && TOTAL_STEPS=$((TOTAL_STEPS + 1))
done
STEP=0

echo "=========================================="
echo "  ARASAKA CORP // OMARCHY THEME BUNDLE"
echo "=========================================="

if [[ "${DO_THEME}" == true ]]; then
  STEP=$((STEP + 1))
  echo ""
  echo "[${STEP}/${TOTAL_STEPS}] Theme (colors, icons, wallpaper)..."
  bash "${SCRIPTS_DIR}/install-theme.sh"
fi

if [[ "${DO_PLYMOUTH}" == true ]]; then
  STEP=$((STEP + 1))
  echo ""
  echo "[${STEP}/${TOTAL_STEPS}] Plymouth bootsplash & reset/shutdown screen..."
  bash "${SCRIPTS_DIR}/install-plymouth.sh"
fi

if [[ "${DO_SCREENSAVER}" == true ]]; then
  STEP=$((STEP + 1))
  echo ""
  echo "[${STEP}/${TOTAL_STEPS}] Terminal screensaver..."
  bash "${SCRIPTS_DIR}/install-screensaver.sh"
fi

if [[ "${DO_GHOSTTY}" == true ]]; then
  STEP=$((STEP + 1))
  echo ""
  echo "[${STEP}/${TOTAL_STEPS}] Ghostty terminal theme & shader..."
  bash "${SCRIPTS_DIR}/install-ghostty.sh"
fi

if [[ "${DO_OMAWIDGETS}" == true ]]; then
  STEP=$((STEP + 1))
  echo ""
  echo "[${STEP}/${TOTAL_STEPS}] OmaWidgets Arasaka HUD cards..."
  bash "${SCRIPTS_DIR}/install-omawidgets.sh"
fi

if [[ "${DO_SHADER}" == true ]]; then
  STEP=$((STEP + 1))
  echo ""
  echo "[${STEP}/${TOTAL_STEPS}] Global Hyprland CRT phosphor glow shader..."
  bash "${SCRIPTS_DIR}/install-shader.sh"
fi

echo ""
echo "=========================================="
echo "  ARASAKA CORP INSTALLATION COMPLETE"
echo "=========================================="
