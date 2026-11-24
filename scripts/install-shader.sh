#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
SHADER_SRC="${REPO_DIR}/shaders/crt-scanlines.glsl"
CONFIG_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}"
SHADER_DIR="${CONFIG_DIR}/hypr/shaders"
SHADER_DEST="${SHADER_DIR}/crt-scanlines.glsl"
LOOKNFEEL="${CONFIG_DIR}/hypr/looknfeel.lua"

echo "Installing global CRT phosphor glow shader to ${SHADER_DEST}..."
mkdir -p "${SHADER_DIR}"
if [[ -f "${SHADER_DEST}" ]] && ! cmp -s "${SHADER_SRC}" "${SHADER_DEST}"; then
  cp "${SHADER_DEST}" "${SHADER_DEST}.bak.$(date +%s)"
fi
cp "${SHADER_SRC}" "${SHADER_DEST}"

if [[ -f "${LOOKNFEEL}" ]]; then
  if grep -qE '^[[:space:]]*screen_shader[[:space:]]*=' "${LOOKNFEEL}"; then
    if ! grep -qF "${SHADER_DEST}" "${LOOKNFEEL}"; then
      cp "${LOOKNFEEL}" "${LOOKNFEEL}.bak.$(date +%s)"
      python3 - "${LOOKNFEEL}" "${SHADER_DEST}" <<'PY'
import re, sys
path, shader = sys.argv[1:3]
with open(path, "r", encoding="utf-8") as f:
    content = f.read()
updated = re.sub(
    r'^([ \t]*)screen_shader[ \t]*=.*$',
    rf'\1screen_shader = "{shader}",',
    content,
    flags=re.MULTILINE,
)
with open(path, "w", encoding="utf-8") as f:
    f.write(updated)
PY
    fi
  else
    cp "${LOOKNFEEL}" "${LOOKNFEEL}.bak.$(date +%s)"
    cat >> "${LOOKNFEEL}" <<EOF

hl.config({
  decoration = {
    screen_shader = "${SHADER_DEST}",
  },
})
EOF
  fi
else
  cat > "${LOOKNFEEL}" <<EOF
hl.config({
  decoration = {
    screen_shader = "${SHADER_DEST}",
  },
})
EOF
fi

if command -v hyprctl >/dev/null 2>&1; then
  echo "Reloading Hyprland..."
  hyprctl reload >/dev/null || true
fi

echo "Done! Global CRT phosphor glow shader applied."
