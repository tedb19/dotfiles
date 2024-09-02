# Bat
alias cat="bat --theme=Coldark-Dark --paging=never"

# Eza
alias ls=eza
alias ll='eza -lah'

# Aliases
alias c='clear'
alias o='open .'
alias cll='clear;ls -lash'
alias grep='grep --color=auto'
alias nr="npm run"
alias y="yarn"
alias ys="yarn start"
alias yr="yarn run"
alias pn="pnpm"
alias f="find . | grep"
alias sz="source ~/.zshrc"

# Git -> https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh

# The git prompt's git commands are read-only and should not interfere with
# other processes. This environment variable is equivalent to running with `git
# --no-optional-locks`, but falls back gracefully for older versions of git.
# See git(1) for and git-status(1) for a description of that flag.
#
# We wrap in a local function instead of exporting the variable directly in
# order to avoid interfering with manually-run git commands by the user.
function __git_prompt_git() {
  GIT_OPTIONAL_LOCKS=0 command git "$@"
}

# Outputs the name of the current branch
# Usage example: git pull origin $(git_current_branch)
# Using '--quiet' with 'symbolic-ref' will not cause a fatal error (128) if
# it's not a symbolic ref, but in a Git repo.
function git_current_branch() {
  local ref
  ref=$(__git_prompt_git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

alias gl="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --branches"
# alias gl="git log --graph --pretty=format:'%C(yellow)%s%Creset%n%an %C(blue)%cr%Creset %h%C(red)%d%Creset ' --numstat"
alias gcmsg='git commit --message'
alias gss='git status --short'
alias gra='git remote add'
alias ggpush='git push origin "$(git_current_branch)"'
alias ggpull='git pull origin "$(git_current_branch)"'
alias gcn!='git commit --verbose --no-edit --amend'
alias ga='git add'
