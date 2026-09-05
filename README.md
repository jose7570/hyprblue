# 🪁 Hyprland Atômico — Fedora Atomic Customizado

Uma imagem Fedora Atomic 45 imutável com **Hyprland**, **DisplayLink**, apps de produtividade, desenvolvimento e idioma **pt-BR** — construída com [BlueBuild](https://blue-build.org/).

## 🚀 Como usar

### Fazer rebase para esta imagem

```bash
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/<SEU-USUARIO>/<NOME-DA-IMAGEM>:latest
```

> Substitua `<SEU-USUARIO>` e `<NOME-DA-IMAGEM>` pelos valores configurados no `recipes/recipe.yml`.

### Baixar a ISO instalável

A ISO é gerada automaticamente pelo GitHub Actions após cada build com sucesso.
Acesse a aba **Actions** do repositório → selecione o workflow mais recente → baixe o artefato `<NOME-DA-IMAGEM>-installer`.

---

## 📦 O que está incluído

### Sistema Base
- **Hyprland** (via `ghcr.io/cjuniorfox/hyprland-atomic-solopasha:45`)
- Waybar, Rofi, ambiente Wayland completo
- **RPMFusion** (codecs e drivers extras)
- Locale **pt-BR** configurado por padrão

### Aplicativos RPM (no sistema base)
| Categoria | Apps |
|---|---|
| Navegadores | Brave Browser, Microsoft Edge Stable |
| Desenvolvimento | VS Code, Neovim, Docker, Docker Compose, Ghostty |
| KDE Apps | Kate, Okular, Dolphin, Ark, Filelight, KCalc, KeePassXC, Kleopatra, KGPG, KFind, Plasma Emoji, Spectacle, KDE Connect, KRDC |
| Utilitários | Flameshot, BleachBit, btrfs-assistant, Firewall-config |
| OCR | Tesseract + tesseract-langpack-por (pt-BR) |
| Multimídia | VLC |
| Rede | qBittorrent |
| DisplayLink | Driver DisplayLink (evdi + DKMS) |

### Apps instalados via Script (build-time)
| App | Versão | Método |
|---|---|---|
| Anki | 26.08.1 | tar.zst oficial |
| XMind | 26.05.x | RPM local em `files/rpms/` |
| JetBrains Toolbox | latest | AppImage → `/opt/jetbrains-toolbox/` |

### Flatpaks opcionais (via yafti — primeiro boot)
- LM Studio, NotepadNext, GoldenDict-ng, Drawio, KClock, LibreOffice, Telegram, Discord, Kdenlive, GIMP, Inkscape, Steam, Lutris, Postman, DBeaver, e mais...

---

## 🛠️ Configuração do Repositório

### 1. Renomear a imagem

Edite [`recipes/recipe.yml`](recipes/recipe.yml) e substitua:
```yaml
name: <NOME-DA-IMAGEM>    # ex: hyprblue-br
```

### 2. Adicionar o RPM do XMind

Copie o arquivo RPM para a pasta antes de fazer push:
```bash
cp Xmind-for-Linux-x86_64bit-26.05.01106-202608091942.rpm files/rpms/
```

> ⚠️ O arquivo RPM não deve ser commitado se for grande. Considere usar Git LFS ou baixá-lo no script de CI.

### 3. Configurar a assinatura cosign

No seu repositório GitHub:
```
Settings → Secrets and variables → Actions → New repository secret
```
Nome: `SIGNING_SECRET`
Valor: gere com `cosign generate-key-pair` e cole o conteúdo de `cosign.key`

Ou use o comando BlueBuild CLI:
```bash
bluebuild generate-signing-keys
```

### 4. Habilitar GitHub Container Registry

```
Settings → Packages → Package visibility → Public
```

---

## 🔒 DisplayLink e Secure Boot

O driver DisplayLink usa o módulo kernel `evdi`. Se o Secure Boot estiver ativo:

1. Na primeira inicialização, o sistema pedirá para registrar um MOK
2. Senha de enrollment: `hyprblue` (configurável em `build.yml`)
3. Siga as instruções na tela do MOK Manager

---

## 🐋 Docker pós-instalação

Para usar Docker sem `sudo`:
```bash
sudo usermod -aG docker $USER
# Faça logout e login novamente
```

---

## 📋 Estrutura do Repositório

```
.
├── .github/workflows/build.yml     # CI/CD: build + ISO
├── recipes/recipe.yml              # Configuração principal BlueBuild
├── files/
│   ├── rpms/                       # RPMs locais (XMind, etc.)
│   │   └── Xmind-*.rpm             # ⚠️ Adicione manualmente
│   └── scripts/
│       ├── install-anki.sh         # Instala Anki 26.08.1
│       ├── install-jetbrains-toolbox.sh
│       └── install-xmind.sh
└── config/
    └── yafti.yml                   # Flatpaks do primeiro boot
```

---

## 🔄 Atualizar o sistema

```bash
# Ver atualizações disponíveis
rpm-ostree upgrade --check

# Aplicar atualizações (requer reboot)
rpm-ostree upgrade
```

O build automático acontece toda segunda-feira às 00h UTC (configurável em `.github/workflows/build.yml`).

---

## 🙏 Créditos

- [cjuniorfox/hyprland-atomic-solopasha](https://github.com/cjuniorfox/hyprland-atomic-solopasha) — Imagem base com Hyprland
- [solopasha/hyprland](https://copr.fedorainfracloud.org/coprs/solopasha/hyprland/) — COPR Hyprland para Fedora
- [BlueBuild](https://blue-build.org/) — Framework de build de imagens OCI
- [Universal Blue](https://universal-blue.org/) — Infraestrutura e inspiração
