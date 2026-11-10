#!/bin/bash
APP_DIR="$(cd "$(dirname "$0")" && pwd)"
VENV="$APP_DIR/.venv/bin/uvicorn"

# Per-machine settings (printer IP, preset, port) live in bambu2snap.env,
# which is not committed. See bambu2snap.env.example.
[ -f "$APP_DIR/bambu2snap.env" ] && set -a && . "$APP_DIR/bambu2snap.env" && set +a

export U13MF_APP_ROOT="$APP_DIR"
export U13MF_PROFILES="$APP_DIR/profiles"
export U13MF_USER_PROFILES="$APP_DIR/user_profiles"
export U13MF_BAMBU_PROFILES="$APP_DIR/bambu_profiles"
export U13MF_RULES="$APP_DIR/rules"
export U13MF_TMP="$APP_DIR/tmp"
export U13MF_FAILED_TMP="$APP_DIR/tmp_failed"
export U13MF_FEEDBACK="$APP_DIR/feedback"
export U13MF_FRONTEND_DIST="$APP_DIR/frontend"
# Networked U1 preset written into every converted file (must exist in OrcaSlicer).
export U13MF_PRINTER_PRESET="${U13MF_PRINTER_PRESET:-Snapmaker U1 (0.4 nozzle) - 192.168.1.244}"
export U13MF_PRINT_HOST="${U13MF_PRINT_HOST:-192.168.1.244}"
PORT="${BAMBU2SNAP_PORT:-8080}"

mkdir -p "$U13MF_TMP" "$U13MF_FAILED_TMP" "$U13MF_FEEDBACK" "$U13MF_USER_PROFILES"
echo "Iniciando bambu2snap en http://localhost:$PORT"
echo "Presiona Ctrl+C para detener."
echo ""
cd "$APP_DIR/backend"
exec "$VENV" main:app --host 0.0.0.0 --port "$PORT"
