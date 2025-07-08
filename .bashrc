#!/bin/bash

# ╔══════════════════════════════════════════════════════════════════════════╗
# ║                         BASH CONFIGURATION FILE                           ║
# ╚══════════════════════════════════════════════════════════════════════════╝

# ┌──────────────────────────────────────────┐
# │           ENVIRONMENT SETUP              │
# └──────────────────────────────────────────┘

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# ┌──────────────────────────────────────────┐
# │           HISTORY CONFIGURATION          │
# └──────────────────────────────────────────┘

# Avoid duplicates and commands starting with space
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend

# ┌──────────────────────────────────────────┐
# │           SHELL BEHAVIOR                 │
# └──────────────────────────────────────────┘

# Update window size after each command
shopt -s checkwinsize

# Make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# ┌──────────────────────────────────────────┐
# │           PROMPT STYLING                 │
# └──────────────────────────────────────────┘

# Set up fancy prompt with colors
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# Configure prompt
if [ "$color_prompt" = yes ]; then
    PS1='\[\033[38;5;39m\]┌──(\[\033[38;5;39m\]\u\[\033[38;5;39m\]@\[\033[38;5;39m\]\h\[\033[38;5;39m\])-[\[\033[38;5;208m\]\w\[\033[38;5;39m\]]\n\[\033[38;5;39m\]└─\[\033[38;5;39m\]$ \[\033[00m\]'
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# Set terminal title
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# ┌──────────────────────────────────────────┐
# │           ALIASES & COLORS               │
# └──────────────────────────────────────────┘

# Enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Useful aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias cls='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias mkdir='mkdir -pv'
alias diff='diff --color=auto'
alias alert='notify-send -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# ┌──────────────────────────────────────────┐
# │           DEVELOPMENT TOOLS              │
# └──────────────────────────────────────────┘

# Oh-My-Posh Theme
eval "$(oh-my-posh init bash --config /home/sukuna/.poshthemes/catppuccin_mocha.omp.json)"

# Cargo (Rust)
. "$HOME/.cargo/env"

# Node Version Manager (NVM)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# PNPM
export PNPM_HOME="/home/sukuna/.local/share/pnpm"
case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Python
alias python3='/usr/local/bin/python3.11'

# Additional PATH configurations
export PATH=$PATH:/home/sukuna/.spicetify

# ┌──────────────────────────────────────────┐
# │           BASH COMPLETION                │
# └──────────────────────────────────────────┘

# Enable programmable completion features
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Load custom aliases if they exist
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


vscd() {
  local dir
  dir=$(fd --type d --hidden --exclude .git . "${1:-.}" | fzf --preview 'tree -C {} | head -100' --preview-window=right:60%) || return
  code "$dir"
}

export ANDROID_HOME=$HOME/Android
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH
export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/.local/bin
