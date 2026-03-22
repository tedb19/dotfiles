#!/bin/bash
set -e  # Exit on error

echo "🚀 Starting dotfiles setup for Apple Silicon Mac..."

# Check and install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "✓ Homebrew already installed"
fi

echo "📦 Installing packages from brew-packages.txt..."
xargs brew install < brew-packages.txt

echo "📦 Installing cask applications..."
brew install --cask --adopt font-jetbrains-mono-nerd-font || true
brew install --cask --adopt font-symbols-only-nerd-font || true
brew install --cask --adopt wezterm || true
brew install --cask --adopt spotify || true
brew install --cask --adopt obsidian || true
brew install --cask --adopt visual-studio-code || true
brew install --cask --adopt fantastical || true
brew install --cask --adopt brave-browser || true
brew install --cask --adopt whatsapp || true
brew install --cask --adopt vlc || true
brew install --cask --adopt screen-studio || true
brew install --cask --adopt claude-code || true

echo "🍺 Setting up brew autoupdate..."
brew tap homebrew/autoupdate
brew autoupdate start --upgrade --cleanup --greedy

echo "🔗 Creating symlinks with stow..."
cd "$(dirname "$0")"
stow -t ~ .

echo "🦇 Building bat cache..."
bat cache --build

# Source asdf so we can use it in this script
echo "🔧 Setting up asdf..."
. /opt/homebrew/opt/asdf/libexec/asdf.sh

# asdf python
echo "🐍 Installing Python via asdf..."
asdf plugin add python || true
asdf install python latest
asdf set -u python latest

# asdf nodejs
echo "📗 Installing Node.js via asdf..."
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git || true
asdf install nodejs latest
asdf set -u nodejs latest

# asdf Elixir (Erlang is a prerequisite)
echo "💧 Installing Erlang and Elixir via asdf..."
asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git || true
asdf install erlang latest
asdf set -u erlang latest

asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git || true
asdf install elixir latest
asdf set -u elixir latest

# asdf lua
echo "🌙 Installing Lua via asdf..."
asdf plugin add lua https://github.com/Stratus3D/asdf-lua.git || true
asdf install lua latest
asdf set -u lua latest

# asdf golang
echo "🐹 Installing Go via asdf..."
asdf plugin add golang https://github.com/asdf-community/asdf-golang.git || true
asdf install golang latest
asdf set -u golang latest

# Install bun
echo "🥟 Installing bun..."
curl -fsSL https://bun.sh/install | bash

echo ""
echo "✅ Setup complete!"
echo ""
echo "⚠️  Manual steps required:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Open VS Code and run: 'Shell Command: Install code command in PATH'"
echo ""
