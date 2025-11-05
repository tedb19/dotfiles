# Bat
alias cat="bat --paging=never"

# Eza
alias ls=eza
alias ll='eza -lah --group-directories-first'
alias l='eza --group-directories-first --icons'

# Aliases
alias c='clear'
alias o='open .'
alias cll='clear;ls -lash'
alias grep='grep --color=auto'
alias nr="npm run"
alias ys="yarn start"
alias yr="yarn run"
alias pn="pnpm"
alias f="find . | grep"
alias sz="source ~/.zshrc"
alias br="bun --bun run dev"

# For convenience
alias ..="cd .."
alias ...='cd ../..'
alias ....='cd ../../..'

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

# @help: Git Helpers | git_current_branch | Get the name of the current branch | git_current_branch | git pull origin $(git_current_branch)
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

# @help: Git Aliases | gl | Pretty git log with graph and colors | gl | gl
alias gl="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --branches"
# alias gl="git log --graph --pretty=format:'%C(yellow)%s%Creset%n%an %C(blue)%cr%Creset %h%C(red)%d%Creset ' --numstat"

# @help: Git Aliases | gcmsg | Commit with a message | gcmsg "message" | gcmsg "fix: update login flow"
alias gcmsg='git commit --message'

# @help: Git Aliases | gc! | Amend the last commit | gc! | gc!
alias gc!='git commit --verbose --amend'

# @help: Git Aliases | gcn | Commit with no-edit flag | gcn | gcn
alias gcn='git commit --verbose --no-edit'

# @help: Git Aliases | gcn! | Amend last commit without editing message | gcn! | gcn!
alias gcn!='git commit --verbose --no-edit --amend'

# @help: Git Aliases | gss | Short git status | gss | gss
alias gss='git status --short'

# @help: Git Aliases | gra | Add a git remote | gra <name> <url> | gra origin git@github.com:user/repo.git
alias gra='git remote add'

# @help: Git Aliases | ggpush | Push to current branch on origin | ggpush | ggpush
alias ggpush='git push origin "$(git_current_branch)"'

# @help: Git Aliases | ggpull | Pull from current branch on origin | ggpull | ggpull
alias ggpull='git pull origin "$(git_current_branch)"'

# @help: Git Aliases | ga | Stage files to git | ga <files> | ga src/
alias ga='git add'

# @help: Git Aliases | gco | Checkout a branch | gco <branch> | gco main
alias gco='git checkout'

# @help: Git Aliases | gsta | Stash changes | gsta | gsta
alias gsta='git stash push'

# @help: Git Aliases | gstl | List stashes | gstl | gstl
alias gstl='git stash list'

# @help: Git Aliases | gstp | Pop latest stash | gstp | gstp
alias gstp='git stash pop'
