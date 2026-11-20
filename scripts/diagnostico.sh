#!/usr/bin/env bash

echo "=== DISCO Y INODOS ==="
df -h
df -i

echo "=== MEMORIA Y SWAP ==="
free -h
swapon --show || true

echo "=== CONTENEDORES Y CONSUMO ==="
podman ps -a
podman stats --no-stream || true
