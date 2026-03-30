#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}🏠 Dotfiles Setup${NC}"
echo -e "Setting up dotfiles from: ${DOTFILES_DIR}"
echo

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    local description="$3"

    # Create parent directory if it doesn't exist
    local target_dir=$(dirname "$target")
    if [[ ! -d "$target_dir" ]]; then
        echo -e "${YELLOW}📁 Creating directory: $target_dir${NC}"
        mkdir -p "$target_dir"
    fi

    # Backup existing file if it exists and isn't already a symlink to our file
    if [[ -e "$target" ]] && [[ ! -L "$target" || "$(readlink "$target")" != "$source" ]]; then
        local backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${YELLOW}💾 Backing up existing file: $target -> $backup${NC}"
        mv "$target" "$backup"
    fi

    # Create symlink
    if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
        echo -e "${GREEN}✅ Already linked: $description${NC}"
    else
        ln -sf "$source" "$target"
        echo -e "${GREEN}🔗 Linked: $description${NC}"
    fi
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo -e "${BLUE}📋 Setting up core dotfiles...${NC}"

# Core shell and git configuration
create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc" "Zsh configuration"
create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig" "Git configuration"

# Application configurations
echo
echo -e "${BLUE}⚙️  Setting up application configs...${NC}"

create_symlink "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml" "Starship prompt"
create_symlink "$DOTFILES_DIR/.wezterm.lua" "$HOME/.wezterm.lua" "WezTerm terminal"
create_symlink "$DOTFILES_DIR/git.plugin.zsh" "$HOME/.config/git.plugin.zsh" "Git plugin"

# Fish shell configuration and plugins
echo
echo -e "${BLUE}🐟 Setting up Fish shell...${NC}"

if command_exists fish; then
    create_symlink "$DOTFILES_DIR/config.fish" "$HOME/.config/fish/config.fish" "Fish configuration"

    # Ensure Fisher (Fish plugin manager) is installed
    echo -e "${BLUE}🎣 Checking Fisher plugin manager...${NC}"
    if fish -c 'type -q fisher'; then
        echo -e "${GREEN}✅ Fisher is available${NC}"
    else
        echo -e "${YELLOW}⚠️  Fisher not found. Attempting installation...${NC}"
        if command_exists brew; then
            if brew list fisher &>/dev/null; then
                echo -e "${GREEN}✅ Fisher installed via Homebrew${NC}"
            else
                if brew install fisher; then
                    echo -e "${GREEN}✅ Installed Fisher via Homebrew${NC}"
                else
                    echo -e "${YELLOW}⚠️  Failed to install Fisher via Homebrew${NC}"
                fi
            fi
        elif command_exists yay; then
            if yay -Qi fisher &>/dev/null; then
                echo -e "${GREEN}✅ Fisher already installed (yay)${NC}"
            else
                if yay -S --noconfirm fisher; then
                    echo -e "${GREEN}✅ Installed Fisher via yay${NC}"
                else
                    echo -e "${YELLOW}⚠️  Failed to install Fisher via yay${NC}"
                fi
            fi
        elif command_exists pacman; then
            if pacman -Qi fisher &>/dev/null; then
                echo -e "${GREEN}✅ Fisher already installed (pacman)${NC}"
            else
                echo -e "${YELLOW}⚠️  Fisher package not found via pacman. Falling back to online installer if available.${NC}"
            fi
        fi

        # Final fallback: attempt official install if curl is available
        if ! fish -c 'type -q fisher'; then
            if command_exists curl; then
                echo -e "${YELLOW}🌐 Installing Fisher using official script...${NC}"
                if fish -c 'curl -sL https://git.io/fisher | source; and fisher install jorgebucaran/fisher'; then
                    echo -e "${GREEN}✅ Fisher installed via official script${NC}"
                else
                    echo -e "${YELLOW}⚠️  Could not install Fisher automatically. Install it manually: https://github.com/jorgebucaran/fisher${NC}"
                fi
            else
                echo -e "${YELLOW}⚠️  curl not available. Please install Fisher manually: https://github.com/jorgebucaran/fisher${NC}"
            fi
        fi
    fi

    # Install jhillyerd/plugin-git via Fisher
    if fish -c 'type -q fisher'; then
        echo -e "${BLUE}🔌 Installing Fish plugin: jhillyerd/plugin-git...${NC}"
        if fish -c 'fisher list | command grep -q "^jhillyerd/plugin-git$"'; then
            echo -e "${GREEN}✅ plugin-git already installed${NC}"
        else
            if fish -c 'fisher install jhillyerd/plugin-git'; then
                echo -e "${GREEN}✅ Installed plugin-git${NC}"
            else
                echo -e "${YELLOW}⚠️  Failed to install plugin-git. Try manually: fish -c "fisher install jhillyerd/plugin-git"${NC}"
            fi
        fi
    fi
else
    echo -e "${YELLOW}⚠️  Fish shell not found. Skipping Fish-specific setup${NC}"
fi

# Optional configurations
echo
echo -e "${BLUE}📦 Setting up optional configs...${NC}"

if [[ -f "$DOTFILES_DIR/.alacritty.yml" ]]; then
    create_symlink "$DOTFILES_DIR/.alacritty.yml" "$HOME/.alacritty.yml" "Alacritty terminal"
fi

if [[ -d "$DOTFILES_DIR/nvim" ]]; then
    create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim" "Neovim configuration"
fi

# Linux-specific window managers
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo
    echo -e "${BLUE}🐧 Setting up Linux-specific configs...${NC}"

    if [[ -d "$DOTFILES_DIR/leftwm" ]]; then
        create_symlink "$DOTFILES_DIR/leftwm" "$HOME/.config/leftwm" "LeftWM window manager"
    fi

    if [[ -d "$DOTFILES_DIR/qtile" ]]; then
        create_symlink "$DOTFILES_DIR/qtile" "$HOME/.config/qtile" "Qtile window manager"
    fi
fi

# Git directory setup
echo
echo -e "${BLUE}📂 Setting up Git directories...${NC}"

for dir in github gitlab; do
    if [[ ! -d "$HOME/$dir" ]]; then
        echo -e "${YELLOW}📁 Creating directory: ~/$dir${NC}"
        mkdir -p "$HOME/$dir"
    else
        echo -e "${GREEN}✅ Directory exists: ~/$dir${NC}"
    fi
done

# Copy git config templates
if [[ -f "$DOTFILES_DIR/.gitconfig-github" ]] && [[ ! -f "$HOME/github/.gitconfig" ]]; then
    echo -e "${YELLOW}📋 Copying GitHub git config template${NC}"
    cp "$DOTFILES_DIR/.gitconfig-github" "$HOME/github/.gitconfig"
    echo -e "${YELLOW}⚠️  Please edit ~/github/.gitconfig with your details${NC}"
fi

if [[ -f "$DOTFILES_DIR/.gitconfig-gitlab" ]] && [[ ! -f "$HOME/gitlab/.gitconfig" ]]; then
    echo -e "${YELLOW}📋 Copying GitLab git config template${NC}"
    cp "$DOTFILES_DIR/.gitconfig-gitlab" "$HOME/gitlab/.gitconfig"
    echo -e "${YELLOW}⚠️  Please edit ~/gitlab/.gitconfig with your details${NC}"
fi

# Shell setup
echo
echo -e "${BLUE}🐚 Shell setup...${NC}"

if command_exists fish; then
    FISH_PATH="$(which fish)"
    if [[ "$SHELL" != *"fish" ]]; then
        echo -e "${YELLOW}⚠️  Current default shell is not fish ($SHELL)${NC}"
        # Ensure fish is in /etc/shells (required for chsh on macOS)
        if ! grep -q "$FISH_PATH" /etc/shells 2>/dev/null; then
            echo -e "${YELLOW}💡 First, add fish to allowed shells:${NC}"
            echo -e "   ${GREEN}echo $FISH_PATH | sudo tee -a /etc/shells${NC}"
        fi
        echo -e "${YELLOW}💡 Then make fish your default shell:${NC}"
        echo -e "   ${GREEN}chsh -s $FISH_PATH${NC}"
    else
        echo -e "${GREEN}✅ Fish is already your default shell${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Fish shell not installed. Install it first:${NC}"
    echo -e "   ${GREEN}brew install fish${NC}"
fi

# Prerequisites check
echo
echo -e "${BLUE}🔍 Checking prerequisites...${NC}"

prerequisites=(
    "git:Git version control"
    "starship:Starship prompt"
    "fzf:Fuzzy finder"
    "eza:Modern ls replacement"
    "diff-so-fancy:Git diff pager (used in .gitconfig)"
    "fish:Fish shell"
)

optional_tools=(
    "kubectx:Kubernetes context switcher"
)

for tool in "${prerequisites[@]}"; do
    cmd="${tool%%:*}"
    desc="${tool##*:}"
    if command_exists "$cmd"; then
        echo -e "${GREEN}✅ $desc${NC}"
    else
        echo -e "${RED}❌ $desc (missing: $cmd)${NC}"
    fi
done

echo
echo -e "${BLUE}📦 Optional tools:${NC}"
for tool in "${optional_tools[@]}"; do
    cmd="${tool%%:*}"
    desc="${tool##*:}"
    if command_exists "$cmd"; then
        echo -e "${GREEN}✅ $desc${NC}"
    else
        echo -e "${YELLOW}⚠️  $desc (install: $cmd)${NC}"
    fi
done

# Platform-specific plugin check
echo
echo -e "${BLUE}🔌 Checking zsh plugins...${NC}"

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if [[ -f "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
        echo -e "${GREEN}✅ zsh-autosuggestions (Homebrew)${NC}"
    else
        echo -e "${YELLOW}⚠️  zsh-autosuggestions (install: brew install zsh-autosuggestions)${NC}"
    fi

    if [[ -f "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
        echo -e "${GREEN}✅ zsh-syntax-highlighting (Homebrew)${NC}"
    else
        echo -e "${YELLOW}⚠️  zsh-syntax-highlighting (install: brew install zsh-syntax-highlighting)${NC}"
    fi
else
    # Linux
    if [[ -f "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
        echo -e "${GREEN}✅ zsh-autosuggestions (system)${NC}"
    elif [[ -f "$HOME/.local/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
        echo -e "${GREEN}✅ zsh-autosuggestions (local)${NC}"
    else
        echo -e "${YELLOW}⚠️  zsh-autosuggestions (install via package manager or manually)${NC}"
    fi

    if [[ -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
        echo -e "${GREEN}✅ zsh-syntax-highlighting (system)${NC}"
    elif [[ -f "$HOME/.local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
        echo -e "${GREEN}✅ zsh-syntax-highlighting (local)${NC}"
    else
        echo -e "${YELLOW}⚠️  zsh-syntax-highlighting (install via package manager or manually)${NC}"
    fi

    if [[ -f "/usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh" ]]; then
        echo -e "${GREEN}✅ zsh-history-substring-search (system)${NC}"
    elif [[ -f "$HOME/.local/share/zsh-history-substring-search/zsh-history-substring-search.zsh" ]]; then
        echo -e "${GREEN}✅ zsh-history-substring-search (local)${NC}"
    else
        echo -e "${YELLOW}⚠️  zsh-history-substring-search (install via package manager or manually)${NC}"
    fi
fi

# Completion
echo
echo -e "${GREEN}🎉 Setup complete!${NC}"
echo
echo -e "${BLUE}📝 Next steps:${NC}"
echo -e "1. ${YELLOW}Restart your terminal or run: exec fish${NC}"
echo -e "2. ${YELLOW}Edit ~/github/.gitconfig with your Git details${NC}"
echo -e "3. ${YELLOW}Install any missing prerequisites shown above${NC}"
echo -e "4. ${YELLOW}Install a Nerd Font for proper icon display${NC}"

# Font installation
echo
echo -e "${BLUE}🔤 Installing 0xProto Nerd Font...${NC}"

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if brew list --cask font-0xproto-nerd-font &>/dev/null; then
        echo -e "${GREEN}✅ 0xProto Nerd Font already installed${NC}"
    else
        echo -e "${YELLOW}📦 Installing 0xProto Nerd Font via Homebrew...${NC}"
        if brew install --cask font-0xproto-nerd-font; then
            echo -e "${GREEN}✅ 0xProto Nerd Font installed${NC}"
        else
            echo -e "${RED}❌ Failed to install font${NC}"
        fi
    fi
else
    # Linux
    if fc-list | grep -i "0xproto" &>/dev/null; then
        echo -e "${GREEN}✅ 0xProto Nerd Font already installed${NC}"
    elif command_exists yay; then
        echo -e "${YELLOW}📦 Installing 0xProto Nerd Font via yay...${NC}"
        if yay -S --noconfirm ttf-0xproto-nerd; then
            echo -e "${GREEN}✅ 0xProto Nerd Font installed${NC}"
        else
            echo -e "${RED}❌ Failed to install font${NC}"
        fi
    elif command_exists pacman; then
        echo -e "${YELLOW}⚠️  0xProto Nerd Font not found. Install manually:${NC}"
        echo -e "   ${GREEN}yay -S ttf-0xproto-nerd${NC}"
    else
        echo -e "${YELLOW}⚠️  Please install 0xProto Nerd Font manually${NC}"
    fi
fi

echo
echo -e "${GREEN}Happy coding! 🚀${NC}"
