#!/bin/bash
# Instala bambu2snap como servicio de usuario (Debian/Ubuntu/Crostini).
set -euo pipefail
APP_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$APP_DIR"
command -v python3 >/dev/null || { echo "Falta python3"; exit 1; }
python3 -m venv .venv 2>/dev/null || { echo "Instala python3-venv: sudo apt install python3-venv"; exit 1; }
.venv/bin/pip install -q --upgrade pip
.venv/bin/pip install -q -r requirements.txt
[ -f bambu2snap.env ] || cp bambu2snap.env.example bambu2snap.env
chmod +x start.sh
mkdir -p "$HOME/.config/systemd/user"
sed "s#%h/bambu2snap#$APP_DIR#" deploy/bambu2snap.service > "$HOME/.config/systemd/user/bambu2snap.service"
systemctl --user daemon-reload
systemctl --user enable --now bambu2snap
loginctl enable-linger "$USER" 2>/dev/null || true
echo "Listo. Revisa/edita $APP_DIR/bambu2snap.env y luego: systemctl --user restart bambu2snap"
