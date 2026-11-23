#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"

mkdir -p "$TARGET_DIR/assets" "$TARGET_DIR/shaders"

# Backup existing config if present
if [[ -f "$TARGET_DIR/config" ]]; then
  cp "$TARGET_DIR/config" "$TARGET_DIR/config.bak.$(date +%s)"
fi

cp "$REPO_DIR/config" "$TARGET_DIR/config"
cp "$REPO_DIR/shaders/arasaka-hud.glsl" "$TARGET_DIR/shaders/arasaka-hud.glsl"
cp "$REPO_DIR/assets/"* "$TARGET_DIR/assets/"
sed "s|__HOME__|$HOME|g" "$REPO_DIR/gtk-arasaka.css" > "$TARGET_DIR/gtk-arasaka.css"

if command -v ghostty >/dev/null 2>&1; then
  ghostty +validate-config
  echo "Ghostty config validated."
fi

echo "Installed to $TARGET_DIR. Press Ctrl+Shift+, in Ghostty (or open a new window) to apply."
