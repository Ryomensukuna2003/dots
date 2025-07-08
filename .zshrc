# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path Configuration
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Oh My Zsh Configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# History Configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS HIST_REDUCE_BLANKS INC_APPEND_HISTORY_TIME

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Completion Configuration - Optimized with caching
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true

# Aliases
alias cat='bat'
alias ls='exa --icons --group-directories-first'
alias reload='source ~/.zshrc'
alias zshconfig='${EDITOR:-nano} ~/.zshrc'
alias update='sudo apt update && sudo apt upgrade -y'
alias gpush='git add . && echo -n "Commit message: " && read msg && git commit -m "$msg" && git push -u origin main'

alias restartBluetooth='sudo hciconfig hci0 down
 sudo rmmod btusb
 sudo modprobe btusb
 sudo hciconfig hci0 up'

# Global fd exclude patterns for node_modules
export FD_DEFAULT_OPTS="--exclude node_modules"

# Source Powerlevel10k configuration
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
export PATH=$PATH:/home/sukuna/.spicetify

vscd() {
  local dir
  dir=$(fd -t d -E .git -E node_modules -E '.*' . "${1:-.}" | fzf --preview 'tree -C {} | head -100') || return
  cd "$dir" && code . --reuse-window
}




# Enhanced cd that lists directory after changing
cd() {
  builtin cd "$@" && ls
}

# Comprehensive system maintenance function
maintain() {
  echo "Updating system packages..."
  sudo apt update && sudo apt upgrade -y
  
  echo "Updating Snap packages..."
  sudo snap refresh
  
  echo "Updating Flatpak packages..."
  flatpak update -y
  
  echo "Cleaning up..."
  sudo apt autoremove -y
  sudo apt clean
  
  echo "System fully updated and cleaned!"
}

fhistory() {
  local cmd
  cmd=$(history | cut -c8- | fzf --preview 'echo {}' \
                                           --preview-window=down:3:wrap \
                                           --height=100% \
                                           --layout=reverse \
                                           --border=rounded \
                                           --prompt="History > ")
  print -z "$cmd"
}

# pnpm
export PNPM_HOME="/home/sukuna/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Lazy-load NVM - Only loads when actually needed
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}
node() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  node "$@"
}
npm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  npm "$@"
}
npx() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  npx "$@"
}

# Add global fd exclusion for node_modules to search functions
if type fd &>/dev/null; then
  # Add a wrapper for fd to always exclude node_modules
  fd() {
    command fd --exclude node_modules "$@"
  }
fi

export PATH="/home/sukuna/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/home/sukuna/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"
export ANDROID_HOME=$HOME/Android

export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH

alias run_emulator="~/run_emulator.sh"
