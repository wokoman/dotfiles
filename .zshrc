###############################################################################
# ZSH STARTUP CONFIGURATION
###############################################################################

# Fast exit for non-interactive shells
[[ -o interactive ]] || return

###############################################################################
# 1. Core Environment
###############################################################################
export LANG=en_US.UTF-8
export GPG_TTY=$TTY

typeset -U path PATH
path=(
  $HOME/.local/bin
  $HOME/.tfenv/bin
  /usr/local/go/bin
  $HOME/.rd/bin
  ${KREW_ROOT:-$HOME/.krew}/bin
  $(go env GOPATH 2>/dev/null)/bin
  $path
)

if [[ -f "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi

###############################################################################
# 2. Homebrew (macOS & Linux) and FPATH setup
###############################################################################
# Try existing brew first, then common fallback locations.
if command -v brew &>/dev/null; then
  eval "$(/usr/bin/env brew shellenv)"
else
  for hb in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    if [[ -x $hb ]]; then
      eval "$("$hb" shellenv)"
      break
    fi
  done
fi

# Deduplicate FPATH (brew shellenv already adds completion paths)
if command -v brew &>/dev/null; then
  typeset -U fpath FPATH
fi

###############################################################################
# 3. History Configuration
###############################################################################
HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
# setopt SHARE_HISTORY
setopt HIST_FCNTL_LOCK

# Ensure history file exists and has safe permissions
[[ -e $HISTFILE ]] || : >| "$HISTFILE"
chmod 600 "$HISTFILE" 2>/dev/null

###############################################################################
# 4. Completion System
###############################################################################
autoload -Uz compinit
compinit

# Configure intelligent completion matching (like Oh My Zsh)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''

# Link Homebrew completions for external commands
if command -v brew &>/dev/null; then
  brew completions link &>/dev/null || true
fi

###############################################################################
# 5. Aliases
###############################################################################
if command -v nerdctl &>/dev/null; then
  alias docker=nerdctl
fi
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

###############################################################################
# 6. FZF Integration
###############################################################################
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
fi

###############################################################################
# 7. Shell Options & Colors
###############################################################################
autoload -Uz colors && colors
setopt PROMPT_SUBST

###############################################################################
# 8. Zsh Plugins
###############################################################################
case "$OSTYPE" in
  darwin*)
    _zsh_autosuggest="/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    _zsh_syntax="/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    ;;
  linux*)
    _zsh_autosuggest="/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
    _zsh_syntax="/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    _zsh_history_substring="/usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"
    ;;
  *)
    _zsh_autosuggest=""
    _zsh_syntax=""
    ;;
esac

[[ -f "$_zsh_autosuggest" ]] && source "$_zsh_autosuggest"
[[ -f "$_zsh_syntax" ]] && source "$_zsh_syntax"
[[ -f "$_zsh_history_substring" ]] && source "$_zsh_history_substring"

# Configure history-substring-search key bindings if present
if typeset -f history-substring-search-up &>/dev/null; then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
fi

unset _zsh_autosuggest _zsh_syntax _zsh_history_substring

###############################################################################
# 9. Custom Scripts
###############################################################################
if [[ -f ~/.config/git.plugin.zsh ]]; then
  source ~/.config/git.plugin.zsh
fi

###############################################################################
# 10. Prompt (keep last)
###############################################################################
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi
