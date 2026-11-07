# Read by every zsh, including non-interactive `zsh -c` (Claude Code, herdr
# agents), which never source .zshrc. Keep this file to PATH only.

# ~/.local/bin first so wrappers there (e.g. vercel, #21) win over Homebrew.
# typeset -U keeps the first occurrence, so re-prepending moves the entry to
# the front instead of duplicating it (idempotent across nested shells).
typeset -U path
path=("$HOME/.local/bin" $path)
