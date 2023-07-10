# Powerlevel10k stuff
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export ZSH="/Users/michalkozak/.oh-my-zsh"
export GPG_TTY=$TTY
export LANG=en_US.UTF-8
export PATH=$PATH:/Users/michalkozak/.local/bin:$HOME/.cargo/env:$HOME/.tfenv/bin:/usr/local/go/bin:$HOME/.rd/bin

ZSH_THEME="powerlevel10k/powerlevel10k"
DISABLE_UPDATE_PROMPT="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="dd.mm.yyyy"

plugins=(
  argocd
  aws
  brew
  common-aliases
  compleat
  encode64
  fzf
  git
  git-auto-fetch
  golang
  helm
  kubectl
  pip
  rsync
  rust
  sudo
  terraform
  vscode
  zsh-autosuggestions
  zsh-syntax-highlighting
  )

source $ZSH/oh-my-zsh.sh

alias docker=nerdctl
alias k=kubectl
alias ll='exa -lah'
alias oldvim='\vim'
alias pip=pip3
alias python=python3
alias tf=terraform
alias vim='nvim'
