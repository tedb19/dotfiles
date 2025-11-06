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
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-symbols-only-nerd-font
brew install --cask wezterm
brew install --cask spotify
brew install --cask obsidian
brew install --cask visual-studio-code
brew install --cask fantastical
brew install --cask brave-browser
brew install --cask whatsapp
brew install --cask vlc
brew install --cask screen-studio

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
asdf plugin-add python
asdf install python latest
asdf global python latest

# asdf nodejs
echo "📗 Installing Node.js via asdf..."
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest
asdf global nodejs latest

# asdf Elixir (Erlang is a prerequisite)
echo "💧 Installing Erlang and Elixir via asdf..."
asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf install erlang latest
asdf global erlang latest

asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf install elixir latest
asdf global elixir latest

# asdf lua
echo "🌙 Installing Lua via asdf..."
asdf plugin-add lua https://github.com/Stratus3D/asdf-lua.git
asdf install lua latest
asdf global lua latest

# asdf golang
echo "🐹 Installing Go via asdf..."
asdf plugin-add golang https://github.com/asdf-community/asdf-golang.git
asdf install golang latest
asdf global golang latest

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
