#!/usr/bin/env bash
# =============================================================
# install-anki.sh
# Instala Anki 26.08.1 a partir do arquivo tar.zst oficial.
# Executado durante o build da imagem (como root).
# =============================================================
set -euo pipefail

ANKI_VERSION="26.08.1"
ANKI_URL="https://github.com/ankitects/anki/releases/download/${ANKI_VERSION}/anki-${ANKI_VERSION}-linux-x86_64.tar.zst"
INSTALL_PREFIX="/usr/local"
TMP_DIR="$(mktemp -d)"

echo "==> Baixando Anki ${ANKI_VERSION}..."
curl -fsSL --retry 3 "${ANKI_URL}" -o "${TMP_DIR}/anki.tar.zst"

echo "==> Extraindo..."
tar --use-compress-program=unzstd -xf "${TMP_DIR}/anki.tar.zst" -C "${TMP_DIR}"

ANKI_DIR="${TMP_DIR}/anki-${ANKI_VERSION}-linux-x86_64"

echo "==> Instalando em ${INSTALL_PREFIX}..."
# O instalador oficial do Anki usa install.sh
if [ -f "${ANKI_DIR}/install.sh" ]; then
    # Forçar o prefixo de instalação via variável
    PREFIX="${INSTALL_PREFIX}" bash "${ANKI_DIR}/install.sh"
else
    # Fallback manual caso o layout mude
    install -Dm755 "${ANKI_DIR}/anki" "${INSTALL_PREFIX}/bin/anki"

    # Ícone
    if [ -f "${ANKI_DIR}/lib/anki/anki.png" ]; then
        install -Dm644 "${ANKI_DIR}/lib/anki/anki.png" \
            /usr/share/pixmaps/anki.png
    fi

    # Arquivos de dados
    mkdir -p "${INSTALL_PREFIX}/share/anki"
    cp -r "${ANKI_DIR}"/lib/anki/* "${INSTALL_PREFIX}/share/anki/" 2>/dev/null || true
fi

# .desktop file
cat > /usr/share/applications/anki.desktop << 'DESKTOP'
[Desktop Entry]
Name=Anki
Comment=Powerful, intelligent flashcards
Exec=anki %f
Icon=anki
Terminal=false
Type=Application
Categories=Education;
MimeType=application/x-anki;application/x-apkg;application/x-colpkg;
StartupNotify=true
DESKTOP

chmod 644 /usr/share/applications/anki.desktop

echo "==> Limpando temporários..."
rm -rf "${TMP_DIR}"

echo "==> Anki ${ANKI_VERSION} instalado com sucesso!"
