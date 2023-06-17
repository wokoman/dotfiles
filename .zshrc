# Powerlevel10k stuff
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export ZSH="/Users/michalkozak/.oh-my-zsh"
export GPG_TTY=$TTY
export LANG=en_US.UTF-8
export PATH=$PATH:/Users/michalkozak/.local/bin:$HOME/.cargo/env:$HOME/.tfenv/bin:/usr/local/go/bin

ZSH_THEME="powerlevel10k/powerlevel10k"
DISABLE_UPDATE_PROMPT="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="dd.mm.yyyy"

plugins=(compleat git gradle kubectl poetry sudo zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# kubectl autocompletion
source <(kubectl completion zsh) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
complete -F __start_kubectl k

# Terraform autocompletion
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform

alias docker=nerdctl
alias k=kubectl
alias ll='exa -lah'
alias oldvim='\vim'
alias pip=pip3
alias python=python3
alias tf=terraform
alias vim='nvim'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
