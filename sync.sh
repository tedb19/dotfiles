#!/bin/bash
set -e  # Exit on error

echo "🔄 Syncing dotfiles..."

# Change to the script's directory
cd "$(dirname "$0")"

# Run stow to update symlinks
stow -t ~ .

echo "✅ Dotfiles synced successfully!"
