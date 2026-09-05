#!/usr/bin/env bash
# =============================================================
# install-chrome.sh
# Instala o Google Chrome a partir do RPM oficial do Google.
# Se o RPM local existir em files/rpms/, usa o arquivo local;
# caso contrário, baixa diretamente de dl.google.com.
# Executado durante o build da imagem (como root).
# =============================================================
set -euo pipefail

CHROME_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm"
RPM_DIR="/tmp/files/rpms"
CHROME_RPM=""

if [ -d "${RPM_DIR}" ]; then
    CHROME_RPM=$(find "${RPM_DIR}" -name "google-chrome-*.rpm" 2>/dev/null | head -1 || true)
fi

if [ -n "${CHROME_RPM}" ] && [ -f "${CHROME_RPM}" ]; then
    echo "==> Instalando Google Chrome a partir do arquivo local: ${CHROME_RPM}"
    dnf install -y "${CHROME_RPM}"
else
    echo "==> Baixando e instalando Google Chrome do repositório oficial..."
    TMP_RPM="$(mktemp --suffix=.rpm)"
    curl -fsSL --retry 3 "${CHROME_URL}" -o "${TMP_RPM}"
    dnf install -y "${TMP_RPM}"
    rm -f "${TMP_RPM}"
fi

echo "==> Google Chrome instalado com sucesso!"
