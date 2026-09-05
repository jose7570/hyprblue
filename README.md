# 🪁 Hyprland Atômico — Fedora Atomic Customizado

Uma distribuição Fedora Atomic 45 (ostree / bootc) imutável e moderna com **Hyprland**, suporte a **DisplayLink (EVDI)**, experiência estética e atalhos inspirados no **Omarchy / Omadora / minimaLinux**, idioma **pt-BR nativo (teclado ABNT2)** e suite completa de produtividade e desenvolvimento — construída via [BlueBuild](https://blue-build.org/) e empacotada em **ISO instalável**.

---

## 🚀 Como Gerar e Baixar a ISO Instalável

A geração da ISO é automatizada pelo **GitHub Actions** em duas etapas integradas:
1. Compilação da imagem OCI no GitHub Container Registry (`ghcr.io/jose7570/hyprblue-br:latest`).
2. Geração da ISO inicializável através do `jasonn3/build-container-installer`.

### 1. Configurar o segredo de assinatura no GitHub (Obrigatório)
1. Acesse o seu repositório no GitHub:
   ```text
   Settings → Secrets and variables → Actions → New repository secret
   ```
2. **Name**: `SIGNING_SECRET`
3. **Secret**: cole a sua chave privada do Cosign (o conteúdo de `keyjoseam` ou gerada via `cosign generate-key-pair`).
4. Em `Settings → Packages → Package visibility`, certifique-se de que o pacote gerado esteja como **Public**.

### 2. Disparar o Build
Faça o push dos commits para a branch `main`:
```bash
git add .
git commit -m "feat: configuracao completa hyprland, displaylink e apps"
git push origin main
```
Ou acione manualmente via interface web:
- Acesse a aba **Actions** no GitHub.
- Selecione o workflow **Build Image**.
- Clique no botão **Run workflow**.

### 3. Baixar a ISO
1. Quando o workflow finalizar (geralmente entre 15 e 25 minutos), clique na execução concluída.
2. No rodapé da página, na seção **Artifacts**, clique em `hyprblue-br-installer` para baixar o arquivo `.iso`.
3. Grave a ISO em um pendrive utilizando:
   - **Ventoy** (basta copiar o arquivo `.iso` para o pendrive)
   - **Fedora Media Writer**
   - **BalenaEtcher**
   - Ou via terminal Linux:
     ```bash
     sudo dd if=hyprblue-br-installer.iso of=/dev/sdX bs=4M status=progress oflag=sync
     ```

### 4. Instalação e DisplayLink com Secure Boot
O driver DisplayLink utiliza o módulo de kernel `evdi`. Se o seu computador estiver com o **Secure Boot ativado**:
1. Durante o primeiro boot, o sistema apresentará a tela azul do **MOK Manager** (*Perform MOK management*).
2. Selecione **Enroll MOK** → **Continue** → **Yes**.
3. Digite a senha de enrollment: `hyprblue` (definida no workflow).
4. Selecione **Reboot**. O módulo EVDI será carregado normalmente.

---

## ⚡ Alternativa: Fazer Rebase em um Fedora Atomic existente

Se você já usa Fedora Silverblue, Kinoite, Bazzite ou Bluefin, pode migrar diretamente para esta imagem sem reinstalar:

```bash
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/jose7570/hyprblue-br:latest
systemctl reboot
```

---

## ⌨️ Experiência Hyprland Estilo Omarchy

As configurações foram injetadas em `/etc/skel/.config/` para que todo novo usuário criado na instalação já inicie com a interface pronta.

### Principais Atalhos de Teclado (Keybindings)

| Atalho | Ação |
|---|---|
| `Super + Return` | Abre o terminal acelerado por GPU (**Ghostty**) |
| `Super + Espaço` ou `Super + D` | Menu de aplicativos (**Rofi**) |
| `Super + E` | Gerenciador de arquivos (**Dolphin**) |
| `Super + B` | Navegador **Brave** |
| `Super + Shift + B` | Navegador **Microsoft Edge** |
| `Super + Ctrl + B` | Navegador **Google Chrome** |
| `Super + C` | Editor de código (**VS Code**) |
| `Super + Shift + C` | Editor de texto KDE (**Kate**) |
| `Super + Q` | Fechar janela ativa |
| `Super + V` | Alternar janela flutuante |
| `Super + F` | Alternar tela cheia (*fullscreen*) |
| `Super + N` | Abrir central de notificações (**SwayNC**) |
| `Super + L` | Bloquear tela (**Hyprlock**) |
| `Print` ou `Super + Shift + S` | Captura de tela com anotação (**Satty** / **Flameshot**) |
| `Super + H/J/K/L` ou Setas | Navegação de foco entre janelas |
| `Super + Shift + H/J/K/L` | Mover posição de janelas |
| `Super + 1..9` | Alternar entre áreas de trabalho (Workspaces) |
| `Super + Shift + 1..9` | Mover janela para a área de trabalho especificada |

---

## 📦 Lista Completa de Softwares Integrados

### 1. Sistema Base & Multimídia (Camada RPM / DNF)
- **Navegadores**: Brave Browser (`brave-browser`), Microsoft Edge (`microsoft-edge-stable`).
- **Desenvolvimento**: VS Code (`code`), Neovim (`neovim`), Docker, Docker Compose, Git, Ghostty.
- **Ambiente KDE & Arquivos**: Dolphin, Kate, Okular, Ark, Filelight, KCalc, KFind, Spectacle, KDE Connect, KRDC.
- **Segurança & Senhas**: KeePassXC, Kleopatra, KGpg.
- **Utilitários**: Flameshot, Satty, BleachBit, Btrfs Assistant (`btrfs-assistant-launcher`), Firewall-config (`firewalld GUI`).
- **Multimídia & Torrent**: VLC Media Player (RPM Fusion), qBittorrent.
- **DisplayLink**: Módulo de kernel `evdi` (via `akmods`) + daemon de espaço de usuário `displaylink`.
- **OCR & Idioma**: Tesseract com modelo de idioma português (`tesseract-langpack-por`), dicionários `hunspell-pt-BR`, fontes `JetBrainsMono Nerd Font` e `Noto Sans`.

### 2. Softwares Instalados via Scripts no Build Time
- **Google Chrome**: Baixado e instalado diretamente do repositório oficial do Google via `install-chrome.sh`.
- **Anki 26.08.1**: Baixado do release oficial `anki-26.08.1-linux-x86_64.tar.zst`, extraído para `/usr/local` com atalho `.desktop` e ícone oficial.
- **XMind 26.05.01106**: Baixado dinamicamente do CDN oficial da XMind via `install-xmind.sh` (evitando limites de tamanho de arquivo no repositório Git).
- **JetBrains Toolbox**: Baixado da API oficial da JetBrains e configurado em `/opt/jetbrains-toolbox/` com symlink global.

### 3. Flatpaks Opcionais (Assistente Yafti no Primeiro Boot)
- **Bazaar**: A moderna e leve loja gráfica de Flatpaks (`io.github.kolunmi.Bazaar`).
- **NotepadNext / Notepadng**: Editor avançado compatível com Notepad++ (`com.github.dail8859.NotepadNext`).
- **GoldenDict-ng**: Dicionário avançado multilíngue (`io.github.xiaoyifang.goldendict_ng`).
- **Draw.io**: Ferramenta completa de diagramas e fluxogramas (`com.jgraph.drawio.desktop`).
- **Drawing (Drawy)**: Aplicativo de desenho e anotações rápidas (`com.github.maoschanz.drawing`).
- **LM Studio**: Execução de LLMs locais (`ai.lmstudio.LMStudio`).
- Outros: Spotify, Telegram, Discord, Slack, LibreOffice, DBeaver, Postman, Steam, Lutris, Kdenlive, GIMP.

---

## 📁 Estrutura do Repositório

```text
.
├── .github/
│   └── workflows/
│       └── build.yml               # CI/CD: Compilação OCI + Geração da ISO instalável
├── recipes/
│   └── recipe.yml                  # Definição dos pacotes, repositórios e módulos BlueBuild
├── files/
│   ├── scripts/
│   │   ├── install-anki.sh         # Instalação automatizada do Anki 26.08.1
│   │   ├── install-chrome.sh       # Instalação oficial do Google Chrome
│   │   ├── install-jetbrains-toolbox.sh # Instalação do JetBrains Toolbox
│   │   └── install-xmind.sh        # Instalação do XMind via CDN oficial
│   └── etc/
│       └── skel/                   # Configurações padrão estilo Omarchy para novos usuários
│           ├── .bashrc             # Shell com suporte a Wayland, Starship e Fastfetch
│           └── .config/
│               ├── hypr/
│               │   └── hyprland.conf # Hyprland: atalhos, teclado ABNT2 e tema Tokyo Night
│               ├── waybar/         # Barra superior flutuante estilo pill
│               ├── rofi/           # Menu de aplicativos moderno
│               ├── ghostty/        # Configuração do terminal Ghostty
│               ├── swaync/         # Central de notificações SwayNC
│               └── starship.toml   # Prompt minimalista
└── config/
    └── yafti.yml                   # Assistente gráfico de primeiro boot para Flatpaks
```

---

## 🔄 Manutenção e Atualizações

O sistema é atômico e imutável. Atualizações são baixadas em segundo plano e aplicadas no próximo reboot de forma segura:

```bash
# Verificar atualizações disponíveis
rpm-ostree upgrade --check

# Aplicar atualização da imagem
rpm-ostree upgrade
```

Em caso de qualquer incompatibilidade com novos drivers ou atualizações, reverta instantaneamente para o estado anterior com:
```bash
rpm-ostree rollback
```
