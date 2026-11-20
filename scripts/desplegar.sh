#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/.."

echo "=== Usuario y mapeo subuid ==="
id
cat /etc/subuid 2>/dev/null || true

echo "=== Levantando servicios Nextcloud + MariaDB ==="
podman-compose up -d

echo "=== Estado de contenedores ==="
podman ps -a
