#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
SRC_DIR="${REPO_DIR}/plymouth/arasaka-terminal"
DEST_DIR="/usr/share/plymouth/themes/arasaka-terminal"
STATE_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/omarchy"
PREV_FILE="${STATE_DIR}/arasaka-prev-plymouth"

if ! command -v plymouth-set-default-theme >/dev/null 2>&1; then
  echo "Warning: 'plymouth-set-default-theme' not found; skipping Plymouth theme install." >&2
  exit 0
fi

if [[ ! -f "${PREV_FILE}" ]]; then
  mkdir -p "${STATE_DIR}"
  plymouth-set-default-theme 2>/dev/null > "${PREV_FILE}" || true
fi

echo "Installing Arasaka Terminal Plymouth bootsplash & reset/shutdown theme to ${DEST_DIR}..."
sudo mkdir -p "${DEST_DIR}"
sudo cp "${SRC_DIR}"/*.png "${SRC_DIR}/arasaka-terminal.plymouth" "${SRC_DIR}/arasaka-terminal.script" "${DEST_DIR}/"

echo "Setting arasaka-terminal as default Plymouth theme and rebuilding initramfs..."
sudo plymouth-set-default-theme -R arasaka-terminal

if command -v limine-mkinitcpio >/dev/null 2>&1; then
  echo "Updating Limine initramfs..."
  sudo limine-mkinitcpio
fi

echo "Installing /usr/local/bin/omarchy-boot-theme-sync helper..."
sudo tee /usr/local/bin/omarchy-boot-theme-sync >/dev/null <<'HELPER'
#!/usr/bin/env bash
set -euo pipefail

THEME_SLUG="${1,,}"
SDDM_ORION_CONF="/etc/sddm.conf.d/orion-n5-theme.conf"

set_plymouth() {
  local target="$1"
  command -v plymouth-set-default-theme >/dev/null 2>&1 || return 0
  [[ -d "/usr/share/plymouth/themes/${target}" ]] || return 0
  local current
  current="$(plymouth-set-default-theme 2>/dev/null || true)"
  if [[ "${current}" != "${target}" ]]; then
    plymouth-set-default-theme -R "${target}"
    if command -v limine-mkinitcpio >/dev/null 2>&1; then
      limine-mkinitcpio >/dev/null 2>&1 || true
    fi
  fi
}

case "${THEME_SLUG}" in
  orion-n5)
    if [[ -d /usr/share/sddm/themes/orion-n5 ]]; then
      mkdir -p /etc/sddm.conf.d
      cat > "${SDDM_ORION_CONF}" <<'CONF'
[Theme]
Current=orion-n5
CONF
    fi
    set_plymouth "orion-n5"
    ;;
  arasaka-corp)
    rm -f "${SDDM_ORION_CONF}"
    set_plymouth "arasaka-terminal"
    ;;
  *)
    rm -f "${SDDM_ORION_CONF}"
    current="$(plymouth-set-default-theme 2>/dev/null || true)"
    if [[ "${current}" == "orion-n5" || "${current}" == "arasaka-terminal" ]]; then
      set_plymouth "omarchy"
    fi
    ;;
esac
HELPER
sudo chmod 755 /usr/local/bin/omarchy-boot-theme-sync

echo "Done! Current Plymouth theme: $(plymouth-set-default-theme)"
