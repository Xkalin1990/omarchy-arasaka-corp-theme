#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
SHADER_SRC="${REPO_DIR}/shaders/crt-scanlines.glsl"
SHADER_DIR="${HOME}/.config/hypr/shaders"
SHADER_DEST="${SHADER_DIR}/crt-scanlines.glsl"
LOOKNFEEL="${HOME}/.config/hypr/looknfeel.lua"

echo "Installing global CRT phosphor glow shader to ${SHADER_DEST}..."
mkdir -p "${SHADER_DIR}"
cp "${SHADER_SRC}" "${SHADER_DEST}"

if [[ -f "${LOOKNFEEL}" ]]; then
  cp "${LOOKNFEEL}" "${LOOKNFEEL}.bak.$(date +%s)"
  if grep -q "screen_shader" "${LOOKNFEEL}"; then
    sed -i "s|screen_shader = .*|screen_shader = \"${SHADER_DEST}\",|" "${LOOKNFEEL}"
  else
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
