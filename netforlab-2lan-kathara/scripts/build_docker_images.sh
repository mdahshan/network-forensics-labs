#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$LAB_DIR"

echo "Building Docker images for netforlab-2lan-kathara..."

docker build -t netfor-alpine-netsec dockerfiles/alpine-netsec

docker build -t netfor-alpine-pc dockerfiles/alpine-pc

docker build -t netfor-alpine-pc-fluxbox dockerfiles/alpine-pc-fluxbox

docker build -t netfor-dnsmasq dockerfiles/dnsmasq

docker build -t netfor-vsftpd dockerfiles/vsftpd

docker build -t netfor-webnginx dockerfiles/webnginx

echo "Docker images built successfully."
