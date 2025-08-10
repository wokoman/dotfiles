# 🏠 Dotfiles

Personal dotfiles for macOS and Linux (Manjaro/Arch).

## What's included

- **Shell**: Zsh with intelligent completions
- **Terminal**: WezTerm
- **Editor**: Zed
- **Prompt**: Starship
- **Git**: Cross-platform configuration with SSH signing
- **Extras**: Neovim, Alacritty, window managers (LeftWM, Qtile)

## Dependencies

#### macOS

```bash
brew install starship git fzf eza kubectx
brew install --cask wezterm zed
brew install zsh-autosuggestions zsh-syntax-highlighting
```

#### Manjaro/Arch

```bash
sudo pacman -S starship git fzf eza kubectx zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search
yay -S wezterm-git zed
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

# Core
ln -sf ~/dotfiles/.zshrc ~/.zshrc
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
- **Starship**: Git status, language versions, Kubernetes context, command duration
- **WezTerm**: Custom colors, 0xProto font, key bindings
- **Git**: Directory-specific configs, 1Password SSH signing

## Troubleshooting

### Completions not working

```bash
rm -f ~/.zcompdump*
exec zsh
```

### Homebrew completions missing

```bash
brew completions link
```

### Permissions (macOS)

```bash
chmod -R go-w "$(brew --prefix)/share"
```
