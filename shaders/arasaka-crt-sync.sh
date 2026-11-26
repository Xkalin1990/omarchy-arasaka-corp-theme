#!/usr/bin/env bash
# Trigger arasaka-crt-watch to re-evaluate CRT shader on Omarchy theme switch.
set -uo pipefail

if systemctl --user is-active --quiet arasaka-crt-watch.service 2>/dev/null; then
  systemctl --user kill --kill-who=main -s SIGUSR1 arasaka-crt-watch.service 2>/dev/null || true
else
  systemctl --user start arasaka-crt-watch.service 2>/dev/null || true
fi
