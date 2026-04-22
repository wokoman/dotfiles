if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -g fish_key_bindings fish_vi_key_bindings
set -gx HOMEBREW_NO_ENV_HINTS 1
set -gx HOMEBREW_NO_INSTALL_CLEANUP 1

abbr -a k "kubectl"
abbr -a tf "terraform"
abbr -a pip "pip3"
abbr -a ll "eza -lah"
abbr -a kx "kubectx"
abbr -a bubu "brew update; and brew outdated; and brew upgrade"
abbr -a docker "nerdctl"
abbr -a python "python3"
abbr -a grep "rg"

command -q pyenv && pyenv init - | source

command -q fzf && fzf --fish | source

command -q starship && starship init fish | source
