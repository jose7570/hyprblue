#!/usr/bin/env bash
# =============================================================
# install-xmind.sh
# Instala o XMind a partir do RPM local em files/rpms/.
# O arquivo RPM deve estar presente no repositório antes do build.
# Executado durante o build da imagem (como root).
# =============================================================
set -euo pipefail

# URL oficial do XMind especificada pelo usuário
XMIND_URL="https://dl3.xmind.net/Xmind-for-Linux-x86_64bit-26.05.01106-202608091942.rpm"

# O BlueBuild copia files/ para /tmp/files/ durante o build se existirem
RPM_DIR="/tmp/files/rpms"
XMIND_RPM=""

if [ -d "${RPM_DIR}" ]; then
    XMIND_RPM=$(find "${RPM_DIR}" -name "Xmind-*.rpm" 2>/dev/null | head -1 || true)
fi

if [ -n "${XMIND_RPM}" ] && [ -f "${XMIND_RPM}" ]; then
    echo "==> Instalando XMind a partir do arquivo local: ${XMIND_RPM}"
    dnf install -y "${XMIND_RPM}"
else
    echo "==> RPM local do XMind não encontrado. Baixando do CDN oficial..."
    TMP_RPM="$(mktemp --suffix=.rpm)"
    curl -fsSL --retry 3 "${XMIND_URL}" -o "${TMP_RPM}"
    echo "==> Instalando XMind..."
    dnf install -y "${TMP_RPM}"
    rm -f "${TMP_RPM}"
fi

echo "==> XMind instalado com sucesso!"

