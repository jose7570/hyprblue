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

ANKI_DIR="${TMP_DIR}/anki-linux"

echo "==> Instalando em ${INSTALL_PREFIX}..."
install -d "${INSTALL_PREFIX}/anki"
cp -a "${ANKI_DIR}/." "${INSTALL_PREFIX}/anki/"
chmod 755 "${INSTALL_PREFIX}/anki/anki"
ln -sf "${INSTALL_PREFIX}/anki/anki" "${INSTALL_PREFIX}/bin/anki"

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
