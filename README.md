# 🏠 Dotfiles

Personal dotfiles for macOS and Linux (Manjaro/Arch).

## What's included

- **Shell**: Zsh and Fish (shortcuts, completions, vi keybindings)
- **Terminal**: WezTerm
- **Editor**: Zed
- **Prompt**: Starship
- **Git**: Cross-platform configuration with SSH signing
- **Extras**: Neovim, Alacritty, window managers (LeftWM, Qtile)

## Dependencies

#### macOS

```bash
brew install fish starship git fzf eza kubectx fisher
brew install --cask wezterm zed
# Zsh-only (optional)
brew install zsh-autosuggestions zsh-syntax-highlighting
```

#### Manjaro/Arch

```bash
sudo pacman -S fish starship git fzf eza kubectx
# Zsh-only (optional)
sudo pacman -S zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search
yay -S wezterm-git zed
yay -S fisher   # if not available via pacman
```

### Font

Install 0xProto Nerd Font:

#### macOS

```bash
brew tap homebrew/cask-fonts
brew install font-0xproto-nerd-font
```

#### Linux

```bash
yay -S ttf-0xproto-nerd  # Arch/Manjaro
```

## Installation

```bash
git clone https://github.com/michalkozak/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x setup.sh
./setup.sh
```

### Manual setup

```bash
mkdir -p ~/.config
mkdir -p ~/.config/fish

# Core
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/config.fish ~/.config/fish/config.fish
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig

# Apps
ln -sf ~/dotfiles/starship.toml ~/.config/starship.toml
ln -sf ~/dotfiles/.wezterm.lua ~/.wezterm.lua
ln -sf ~/dotfiles/zed.json ~/.config/zed/settings.json
ln -sf ~/dotfiles/git.plugin.zsh ~/.config/git.plugin.zsh

# Optional
ln -sf ~/dotfiles/.alacritty.yml ~/.alacritty.yml
ln -sf ~/dotfiles/nvim ~/.config/nvim
ln -sf ~/dotfiles/leftwm ~/.config/leftwm      # Linux
ln -sf ~/dotfiles/qtile ~/.config/qtile        # Linux
```

### Shell setup

Choose your default shell (both are supported):

```bash
# Zsh (current default in setup.sh)
chsh -s "$(which zsh)"

# Fish (if you prefer fish)
chsh -s "$(which fish)"
```

### Fish plugins

This repo uses the excellent Fish Git plugin by jhillyerd. It adds helpful abbreviations and functions for Git workflows.

Install via Fisher (the setup script attempts this automatically if Fish is present):

```bash
# Ensure Fisher is installed
brew install fisher                             # macOS
# or: yay -S fisher                              # Arch/Manjaro
# or (official script):
# fish -c 'curl -sL https://git.io/fisher | source; and fisher install jorgebucaran/fisher'

# Install the Git plugin
fish -c 'fisher install jhillyerd/plugin-git'
```

### Git setup

```bash
# Create work directories
mkdir -p ~/github ~/gitlab ~/keboola

# Copy GitHub config template
cp ~/dotfiles/.gitconfig-github ~/github/.gitconfig
# Edit ~/github/.gitconfig with your details
```

## Features

- **Zsh**: Fuzzy completions, history management, auto-suggestions, syntax highlighting
- **Fish**: Abbreviations (`k`, `tf`, `ll`, `kx`, `bubu`), vi key bindings, fzf integration
- **Starship**: Git status, language versions, Kubernetes context, command duration
- **WezTerm**: Custom colors, 0xProto font, key bindings
- **Git**: Directory-specific configs, 1Password SSH signing

## Troubleshooting

### Completions not working

```bash
rm -f ~/.zcompdump*
exec zsh
```

### Fish: fzf integration missing

Ensure `fzf` is installed. The fish config sources `fzf --fish | source` to enable completions and keybindings.

### Homebrew completions missing

```bash
brew completions link
```

### Permissions (macOS)

```bash
chmod -R go-w "$(brew --prefix)/share"
```
