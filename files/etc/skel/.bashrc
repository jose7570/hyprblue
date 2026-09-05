# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Variáveis de ambiente para Wayland
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM="wayland;xcb"
export GDK_BACKEND="wayland,x11"
export SDL_VIDEODRIVER=wayland
export CLUTTER_BACKEND=wayland
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=Hyprland

# Editor padrão
export EDITOR=nvim
export VISUAL=code

# Aliases úteis
alias ll='ls -la --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias grep='grep --color=auto'

# Inicializar Starship Prompt se disponível
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
fi

# Exibir Fastfetch no terminal interativo
if [[ $- == *i* ]] && command -v fastfetch &>/dev/null; then
    fastfetch
fi
