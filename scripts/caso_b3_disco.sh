#!/usr/bin/env bash
set -e

PROYECTO_DIR="${PROYECTO_DIR:-$HOME/thedeadlocks_nextcloud}"
RESPALDO_DIR="$HOME/respaldo_proyecto"
ARCHIVO_RELLENO="$HOME/monzonPC4.txt"

echo "=== 1. Respaldo y estado inicial de disco e inodos ==="
mkdir -p "$RESPALDO_DIR"
if [ -d "$PROYECTO_DIR" ]; then
  cp -r "$PROYECTO_DIR"/* "$RESPALDO_DIR/" 2>/dev/null || true
fi
df -h
df -i

echo "=== 2. Simular llenado de bloques en / (21.5G) ==="
fallocate -l 21.5G "$ARCHIVO_RELLENO"
df -h
df -i

echo "=== 3. Limpieza y recuperacion del servicio ==="
rm -f "$ARCHIVO_RELLENO"
if [ -f "$PROYECTO_DIR/compose.yaml" ]; then
  podman-compose -f "$PROYECTO_DIR/compose.yaml" restart || true
elif [ -d "$HOME/proyecto-final" ]; then
  cd "$HOME/proyecto-final" && podman-compose restart || true
fi
df -h
df -i
