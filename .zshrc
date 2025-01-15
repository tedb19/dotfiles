source_if_exists () {
    if test -r "$1"; then
        source "$1"
    fi
}

source_if_exists $HOME/.config/zsh/aliases.zsh
source_if_exists $HOME/.config/zsh/twc.zsh

# Starship
eval "$(starship init zsh)"

# Activate syntax highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Disable underlines
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# Activate autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# nvm
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# zoxide
eval "$(zoxide init zsh)"

# fzf
source <(fzf --zsh)

# JAVA_HOME
export JAVA_HOME="/Library/Java/JavaVirtualMachines/amazon-corretto-17.jdk/Contents/Home"

# asdf
. /opt/homebrew/opt/asdf/libexec/asdf.sh

# bun completions
[ -s "/Users/teddybrian/.bun/_bun" ] && source "/Users/teddybrian/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/teddybrian/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

#
# bindkey "\e\e[b" backward-word
# bindkey '\e\e[f' forward-word

# bindkey "\e\e;3D" backward-word
# bindkey "\e\e;3C" forward-word

bindkey -e

bindkey "^[[3~" delete-char                     # Key Del
bindkey "^[[5~" beginning-of-buffer-or-history  # Key Page Up
bindkey "^[[6~" end-of-buffer-or-history        # Key Page Down
bindkey "^[[H" beginning-of-line                # Key Home
bindkey "^[[F" end-of-line                      # Key End
bindkey "^[[1;3C" forward-word                  # Key Alt + Right
bindkey "^[[1;3D" backward-word                 # Key Alt + Left

# use up/down keys to traverse the history in iex shell
export ERL_AFLAGS="-kernel shell_history enabled"

# NAVIGATION
# ----------

# Navigate to directory by name without using cd
setopt AUTO_CD

# Automatically push directories to the stack when cd'ing
setopt AUTO_PUSHD

# Don't store duplicates on the stack
setopt PUSHD_IGNORE_DUPS

# Swap the meaning of cd +1 and cd -1
setopt PUSHD_MINUS

# Don't print the directory stack when pushing or popping
setopt PUSHD_SILENT

# sesh:
# ------
function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    # session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    session=$(sesh list -t -c | gum filter --limit 1 --no-sort --fuzzy --placeholder 'Pick a session' --height 50 --prompt='⚡')

    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}

# Alt-s to open fzf prompt to connect to session
zle     -N             sesh-sessions
bindkey -M emacs '\es' sesh-sessions
bindkey -M vicmd '\es' sesh-sessions
bindkey -M viins '\es' sesh-sessions

# use y for yazi, and change directory when you exit with "q". Press "Q" not to change directory
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
