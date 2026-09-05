#!/usr/bin/env bash
# =============================================================
# install-xmind.sh
# Instala o XMind a partir do RPM local em files/rpms/.
# O arquivo RPM deve estar presente no repositório antes do build.
# Executado durante o build da imagem (como root).
# =============================================================
set -euo pipefail

# O BlueBuild copia files/ para /tmp/files/ durante o build.
# Ajuste o caminho conforme necessário.
RPM_DIR="/tmp/files/rpms"
XMIND_RPM=$(find "${RPM_DIR}" -name "Xmind-*.rpm" | head -1)

if [ -z "${XMIND_RPM}" ]; then
    echo "AVISO: RPM do XMind não encontrado em ${RPM_DIR}." >&2
    echo "       Coloque o arquivo Xmind-for-Linux-x86_64bit-*.rpm na pasta files/rpms/" >&2
    echo "       O XMind NÃO será instalado neste build." >&2
    exit 0
fi

echo "==> Instalando XMind de: ${XMIND_RPM}"
dnf install -y "${XMIND_RPM}"

echo "==> XMind instalado com sucesso!"
