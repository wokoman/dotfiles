# Powerlevel10k stuff
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export ZSH="/home/michalkozak/.oh-my-zsh"
export LANG=en_US.UTF-8
export PATH=$PATH:/opt/gradle/gradle-6.7.1/bin:/home/michalkozak/.local/bin:$HOME/.cargo/env:$HOME/.tfenv/bin

ZSH_THEME="powerlevel10k/powerlevel10k"
DISABLE_UPDATE_PROMPT="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="dd.mm.yyyy"

plugins=(compleat git gradle kubectl sudo zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# kubectl autocompletion
source <(kubectl completion zsh) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
complete -F __start_kubectl k

# Terraform autocompletion
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform

alias k=kubectl
alias pip=pip3
alias ll='ls -lah'
alias tf=terraform
alias gw='./gradlew'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/michalkozak/.sdkman"
[[ -s "/home/michalkozak/.sdkman/bin/sdkman-init.sh" ]] && source "/home/michalkozak/.sdkman/bin/sdkman-init.sh"
