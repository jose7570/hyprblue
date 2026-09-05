#!/usr/bin/env bash
# =============================================================
# install-jetbrains-toolbox.sh
# Baixa o JetBrains Toolbox mais recente e instala em /opt.
# Cria .desktop e symlink /usr/local/bin/jetbrains-toolbox.
# Executado durante o build da imagem (como root).
# =============================================================
set -euo pipefail

INSTALL_DIR="/opt/jetbrains-toolbox"
TMP_DIR="$(mktemp -d)"
JETBRAINS_TOOLBOX_URL=""

echo "==> Obtendo URL de download do JetBrains Toolbox..."
# API pública do JetBrains para obter a última versão Linux x86_64
JETBRAINS_TOOLBOX_URL=$(
    curl -fsSL "https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release" \
    | python3 -c "
import sys, json
data = json.load(sys.stdin)
releases = data.get('TBA', [])
if not releases:
    raise SystemExit('Nenhuma release encontrada')
for dl in releases[0].get('downloads', {}).values():
    if dl.get('link', '').endswith('.tar.gz') and 'linux' in dl.get('link', '').lower():
        print(dl['link'])
        break
"
)

if [ -z "${JETBRAINS_TOOLBOX_URL}" ]; then
    echo "ERRO: Não foi possível obter a URL do JetBrains Toolbox." >&2
    exit 1
fi

echo "==> Baixando de: ${JETBRAINS_TOOLBOX_URL}"
curl -fsSL --retry 3 "${JETBRAINS_TOOLBOX_URL}" -o "${TMP_DIR}/jetbrains-toolbox.tar.gz"

echo "==> Extraindo..."
tar -xzf "${TMP_DIR}/jetbrains-toolbox.tar.gz" -C "${TMP_DIR}"

EXTRACTED_DIR=$(find "${TMP_DIR}" -maxdepth 1 -name "jetbrains-toolbox-*" -type d | head -1)

echo "==> Instalando em ${INSTALL_DIR}..."
mkdir -p "${INSTALL_DIR}"
cp -r "${EXTRACTED_DIR}/"* "${INSTALL_DIR}/"
chmod +x "${INSTALL_DIR}/jetbrains-toolbox"

# Symlink acessível globalmente
ln -sf "${INSTALL_DIR}/jetbrains-toolbox" /usr/local/bin/jetbrains-toolbox

# Ícone (embutido no executável, mas criamos referência)
# O Toolbox extrai seu próprio ícone na primeira execução do usuário.

# .desktop file
cat > /usr/share/applications/jetbrains-toolbox.desktop << 'DESKTOP'
[Desktop Entry]
Name=JetBrains Toolbox
Comment=Manage JetBrains IDEs (IntelliJ, PyCharm, GoLand, etc.)
Exec=jetbrains-toolbox %U
Icon=jetbrains-toolbox
Terminal=false
Type=Application
Categories=Development;IDE;
StartupNotify=true
StartupWMClass=jetbrains-toolbox
DESKTOP

chmod 644 /usr/share/applications/jetbrains-toolbox.desktop

echo "==> Limpando temporários..."
rm -rf "${TMP_DIR}"

echo "==> JetBrains Toolbox instalado em ${INSTALL_DIR}"
