# thedeadlocks_nextcloud

Despliegue de Nextcloud y MariaDB en Podman rootless sobre AlmaLinux, junto con scripts de diagnostico y analisis de fallas (B3, I1 y A1) para Sistemas Operativos.

## Estructura
- README.md
- compose.yaml
- .env.example
- .gitignore
- scripts/desplegar.sh
- scripts/diagnostico.sh

## Uso
1. Copiar .env.example a .env y ajustar credenciales o dominios.
2. Ejecutar ./scripts/desplegar.sh para levantar el stack con Podman.
3. Ejecutar ./scripts/diagnostico.sh para revisar disco, inodos, memoria y contenedores.

## Casos analizados
- B3: Disco e inodos.
- I1: Memoria y OOM Killer.
- A1: Permisos, UID, namespaces y SELinux.
