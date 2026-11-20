#!/usr/bin/env bash

CONTENEDOR_OOM="prueba_oom"
IMAGEN_STRESS="localhost/nextcloud-stress:prueba"

echo "=== 1. Estado inicial de memoria, swap y contenedores ==="
free -h
swapon --show || true
podman ps -a
podman stats --no-stream || true
podman images

echo "=== 2. Levantar contenedor temporal con limite de 256m y stress-ng ==="
podman rm -f "$CONTENEDOR_OOM" 2>/dev/null || true
podman run -d --name "$CONTENEDOR_OOM" --memory 256m --memory-swap 256m "$IMAGEN_STRESS" stress-ng --vm 1 --vm-bytes 512M --vm-keep
podman inspect "$CONTENEDOR_OOM" --format '{{.HostConfig.Memory}} {{.HostConfig.MemorySwap}}'

sleep 3
podman stats --no-stream "$CONTENEDOR_OOM" || true
podman exec "$CONTENEDOR_OOM" cat /sys/fs/cgroup/memory.events 2>/dev/null || true

echo "=== 3. Detener prueba e inspeccionar OOMKilled y ExitCode ==="
podman stop "$CONTENEDOR_OOM" || true
podman ps -a --filter "name=$CONTENEDOR_OOM"
podman inspect "$CONTENEDOR_OOM" --format 'Estado: {{.State.Status}} | OOMKilled: {{.State.OOMKilled}} | ExitCode: {{.State.ExitCode}}'
podman inspect "$CONTENEDOR_OOM" --format '{{.HostConfig.Memory}} {{.HostConfig.MemorySwap}}'

echo "=== 4. Limpieza y restauracion de contenedores originales ==="
podman rm -f "$CONTENEDOR_OOM" 2>/dev/null || true
podman start nextcloud-db nextcloud-app 2>/dev/null || true
podman ps
