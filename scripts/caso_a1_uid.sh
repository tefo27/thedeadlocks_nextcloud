#!/usr/bin/env bash

DIR_DATOS="$HOME/datos"
CONTENEDOR_UID="prueba_uid"
IMAGEN_NC="docker.io/library/nextcloud:latest"

echo "=== 1. Crear directorio y revisar UID / subuid / permisos ==="
mkdir -p "$DIR_DATOS"
id
cat /etc/subuid 2>/dev/null || true
ls -ld "$DIR_DATOS"

echo "=== 2. Probar escritura con UID 33 sin ajustar propiedad ni etiqueta :Z ==="
podman run --rm --replace --name "$CONTENEDOR_UID" -v "$DIR_DATOS:/var/www/html/datos" --user 33 "$IMAGEN_NC" touch /var/www/html/datos/prueba.txt || true
echo "Codigo de salida anterior: $?"
ls -la "$DIR_DATOS"
podman unshare ls -ln "$DIR_DATOS"

echo "=== 3. Aplicar solucion (chown 33:33 en namespace y etiqueta :Z) ==="
podman unshare chown -R 33:33 "$DIR_DATOS"
podman unshare ls -ln "$DIR_DATOS"
podman run --rm --replace --name "$CONTENEDOR_UID" -v "$DIR_DATOS:/var/www/html/datos:Z" --user 33 "$IMAGEN_NC" touch /var/www/html/datos/prueba.txt
ls -ln "$DIR_DATOS"
