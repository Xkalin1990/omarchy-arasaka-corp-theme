#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}"
THEME_SLUG="arasaka-corp"

echo "Uninstalling Arasaka Corp theme bundle..."

# 1. Disable global Hyprland CRT shader
LOOKNFEEL="${CONFIG_DIR}/hypr/looknfeel.lua"
SHADER_DEST="${CONFIG_DIR}/hypr/shaders/crt-scanlines.glsl"
if [[ -f "${LOOKNFEEL}" ]] && grep -qF "${SHADER_DEST}" "${LOOKNFEEL}"; then
  python3 - "${LOOKNFEEL}" "${SHADER_DEST}" <<'PY'
import re, sys
path, shader = sys.argv[1:3]
with open(path, "r", encoding="utf-8") as f:
    content = f.read()
updated = re.sub(
    r'^([ \t]*)screen_shader[ \t]*=.*' + re.escape(shader) + r'.*$',
    r'\1screen_shader = "[[EMPTY]]",',
    content,
    flags=re.MULTILINE,
)
with open(path, "w", encoding="utf-8") as f:
    f.write(updated)
PY
fi
rm -f "${SHADER_DEST}"
if command -v hyprctl >/dev/null 2>&1 && [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
  hyprctl reload >/dev/null || true
fi

# 2. Remove OmaWidgets plugin & shell.json entry
PLUGINS_DIR="${CONFIG_DIR}/omarchy/plugins"
SHELL_JSON="${CONFIG_DIR}/omarchy/shell.json"
rm -rf "${PLUGINS_DIR}/io.github.fabandrade88.omawidgets"
if [[ -f "${SHELL_JSON}" ]] && command -v python3 >/dev/null 2>&1; then
  python3 - "${SHELL_JSON}" <<'PY'
import json, sys
path = sys.argv[1]
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)
left = data.get("bar", {}).get("layout", {}).get("left")
if isinstance(left, list):
    data["bar"]["layout"]["left"] = [
        item for item in left
        if not (isinstance(item, dict) and item.get("id") == "io.github.fabandrade88.omawidgets")
    ]
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)
        f.write("\n")
PY
fi

# 3. Remove Ghostty Arasaka assets/shader/css & restore latest config backup if available
GHOSTTY_DIR="${CONFIG_DIR}/ghostty"
rm -f "${GHOSTTY_DIR}/shaders/arasaka-hud.glsl" "${GHOSTTY_DIR}/gtk-arasaka.css"
rm -rf "${GHOSTTY_DIR}/assets"
LATEST_GHOSTTY_BAK="$(ls -1t "${GHOSTTY_DIR}/config.bak."* 2>/dev/null | head -n 1 || true)"
if [[ -n "${LATEST_GHOSTTY_BAK}" ]]; then
  mv -f "${LATEST_GHOSTTY_BAK}" "${GHOSTTY_DIR}/config"
fi

# 4. Restore screensaver backup if available
BRANDING_DIR="${CONFIG_DIR}/omarchy/branding"
LATEST_SS_BAK="$(ls -1t "${BRANDING_DIR}/screensaver.txt.bak."* 2>/dev/null | head -n 1 || true)"
if [[ -n "${LATEST_SS_BAK}" ]]; then
  mv -f "${LATEST_SS_BAK}" "${BRANDING_DIR}/screensaver.txt"
fi

# 5. Remove Omarchy theme directory
rm -rf "${CONFIG_DIR}/omarchy/themes/${THEME_SLUG}"

# 6. Restore Plymouth theme if previously recorded
PREV_PLYMOUTH="${CONFIG_DIR}/omarchy/arasaka-prev-plymouth"
if [[ -f "${PREV_PLYMOUTH}" ]] && command -v plymouth-set-default-theme >/dev/null 2>&1; then
  prev="$(cat "${PREV_PLYMOUTH}" || true)"
  if [[ -n "${prev}" ]]; then
    echo "Restoring previous Plymouth theme '${prev}' (requires sudo)..."
    sudo plymouth-set-default-theme -R "${prev}" || true
    command -v limine-mkinitcpio >/dev/null 2>&1 && sudo limine-mkinitcpio || true
  fi
  rm -f "${PREV_PLYMOUTH}"
fi

if command -v omarchy >/dev/null 2>&1; then
  omarchy restart shell || true
fi

echo "Arasaka Corp theme uninstalled. Switch to another theme with 'omarchy theme set <name>'."
