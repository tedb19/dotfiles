# Set PATH, MANPATH, etc., for Homebrew (Apple Silicon)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Login shells: /etc/zprofile's path_helper and brew shellenv above push
# ~/.local/bin (set in .zshenv) behind Homebrew; move it back to the front.
typeset -U path
path=("$HOME/.local/bin" $path)
