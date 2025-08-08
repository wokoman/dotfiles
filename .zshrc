# export CLOUDSDK_PYTHON="/opt/homebrew/bin/python3.12"

# Powerlevel10k stuff
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# export ZSH=$HOME/.oh-my-zsh
export GPG_TTY=$TTY
export LANG=en_US.UTF-8
export PATH=$PATH:$HOME/.local/bin:$HOME/.cargo/env:$HOME/.tfenv/bin:/usr/local/go/bin:$HOME/.rd/bin:${KREW_ROOT:-$HOME/.krew}/bin:$(go env GOPATH)/bin
export FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# ZSH_THEME="powerlevel10k/powerlevel10k"
# DISABLE_UPDATE_PROMPT="true"
# COMPLETION_WAITING_DOTS="true"
# HIST_STAMPS="dd.mm.yyyy"

# plugins=(
#   aws
#   brew
#   common-aliases
#   compleat
#   encode64
#   fzf
#   git
#   git-auto-fetch
#   golang
#   helm
#   kubectl
#   pip
#   rsync
#   rust
#   sudo
#   terraform
#   vscode
#   uv
#   zsh-autosuggestions
#   zsh-syntax-highlighting
#   )

# source $ZSH/oh-my-zsh.sh

alias docker=nerdctl
alias k=kubectl
alias kx=kubectx
alias ll='eza -lah'
alias oldvim='\vim'
alias pip=pip3
alias python=python3
alias tf=terraform
alias vim='nvim'
alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql
alias ..='cd ..'

source <(fzf --zsh)

eval "$(brew shellenv)"
autoload -Uz compinit
compinit

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/git.plugin.zsh

eval "$(starship init zsh)"
