# Read by every zsh, including non-interactive `zsh -c` (Claude Code, herdr
# agents), which never source .zshrc. Keep this file to PATH only.

# ~/.local/bin ahead of Homebrew so wrappers there (e.g. vercel, #21) win.
# Only touch PATH when it is missing or behind /opt/homebrew/bin, so nested
# shells keep whatever .zshrc or direnv put in front. typeset -U keeps the
# first occurrence, so prepending moves the entry instead of duplicating it.
typeset -U path
() {
  local lb=${path[(Ie)$HOME/.local/bin]} hb=${path[(Ie)/opt/homebrew/bin]}
  if (( ! lb || (hb && lb > hb) )); then
    path=("$HOME/.local/bin" $path)
  fi
}
