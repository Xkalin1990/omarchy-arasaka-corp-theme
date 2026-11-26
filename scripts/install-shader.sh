#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
SHADER_SRC="${REPO_DIR}/shaders/crt-scanlines.glsl"
WATCHER_SRC="${REPO_DIR}/shaders/arasaka-crt-watch"
SERVICE_SRC="${REPO_DIR}/shaders/arasaka-crt-watch.service"
HOOK_SRC="${REPO_DIR}/shaders/arasaka-crt-sync.sh"

CONFIG_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}"
SHADER_DIR="${CONFIG_DIR}/hypr/shaders"
SHADER_DEST="${SHADER_DIR}/crt-scanlines.glsl"
LOOKNFEEL="${CONFIG_DIR}/hypr/looknfeel.lua"
BIN_DIR="${HOME}/.local/bin"
WATCHER_DEST="${BIN_DIR}/arasaka-crt-watch"
SYSTEMD_USER_DIR="${CONFIG_DIR}/systemd/user"
SERVICE_DEST="${SYSTEMD_USER_DIR}/arasaka-crt-watch.service"
HOOK_DIR="${CONFIG_DIR}/omarchy/hooks/theme-set.d"
HOOK_DEST="${HOOK_DIR}/arasaka-crt-sync.sh"

echo "Installing theme-scoped & app-aware CRT phosphor glow shader to ${SHADER_DEST}..."
mkdir -p "${SHADER_DIR}" "${BIN_DIR}" "${SYSTEMD_USER_DIR}" "${HOOK_DIR}"

if [[ -f "${SHADER_DEST}" ]] && ! cmp -s "${SHADER_SRC}" "${SHADER_DEST}"; then
  cp "${SHADER_DEST}" "${SHADER_DEST}.bak.$(date +%s)"
fi
cp "${SHADER_SRC}" "${SHADER_DEST}"

# Remove any legacy global screen_shader entry pointing to crt-scanlines.glsl in looknfeel.lua
if [[ -f "${LOOKNFEEL}" ]] && grep -qF "${SHADER_DEST}" "${LOOKNFEEL}"; then
  cp "${LOOKNFEEL}" "${LOOKNFEEL}.bak.$(date +%s)"
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

# Install watcher script, systemd user service, and Omarchy theme-set hook
cp "${WATCHER_SRC}" "${WATCHER_DEST}"
chmod +x "${WATCHER_DEST}"

cp "${SERVICE_SRC}" "${SERVICE_DEST}"

cp "${HOOK_SRC}" "${HOOK_DEST}"
chmod +x "${HOOK_DEST}"

if command -v systemctl >/dev/null 2>&1; then
  systemctl --user daemon-reload >/dev/null 2>&1 || true
  systemctl --user enable --now arasaka-crt-watch.service >/dev/null 2>&1 || true
  systemctl --user restart arasaka-crt-watch.service >/dev/null 2>&1 || true
fi

echo "Done! Theme-scoped & app-aware CRT phosphor glow shader installed."
