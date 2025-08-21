if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -g fish_key_bindings fish_vi_key_bindings

abbr -a k "kubectl"
abbr -a tf "terraform"
abbr -a pip "pip3"
abbr -a ll "eza -lah"
abbr -a kx "kubectx"
abbr -a bubu "brew update; and brew outdated; and brew upgrade"

fzf --fish | source

starship init fish | source
