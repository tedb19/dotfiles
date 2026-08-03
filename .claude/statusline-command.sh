#!/usr/bin/env bash
# Claude Code status line — mirrors Starship/Catppuccin Macchiato style
# Catppuccin Macchiato palette (ANSI approximations)
LAVENDER='\033[38;2;183;189;248m'   # #b7bdf8 — directory
MAUVE='\033[38;2;198;160;246m'      # #c6a0f6 — git branch
RED='\033[38;2;237;135;150m'        # #ed8796 — git status / dirty
PEACH='\033[38;2;245;169;127m'      # #f5a97f — separators / accents
GRAY='\033[38;2;128;135;162m'       # #8087a2 — overlay1 / dim info
WHITE='\033[38;2;202;211;245m'      # #cad3f5 — text
RESET='\033[0m'

input=$(cat)

cwd=$(echo "$input"       | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input"     | jq -r '.model.display_name // ""')
used=$(echo "$input"      | jq -r '.context_window.used_percentage // empty')
tokens=$(echo "$input"    | jq -r '.context_window.total_input_tokens // empty')
branch=""
git_status_str=""

# Git branch (skip lock to avoid blocking)
if git_dir=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" rev-parse --git-dir 2>/dev/null); then
  branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null \
           || GIT_OPTIONAL_LOCKS=0 git -C "$cwd" rev-parse --short HEAD 2>/dev/null)

  # Detect dirty / ahead / behind
  dirty=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" status --porcelain 2>/dev/null | head -1)
  ahead=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" rev-list --count @{u}..HEAD 2>/dev/null || echo 0)
  behind=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" rev-list --count HEAD..@{u} 2>/dev/null || echo 0)

  [ -n "$dirty"        ] && git_status_str+="!"
  [ "$ahead"  -gt 0 2>/dev/null ] && git_status_str+="⇡${ahead}"
  [ "$behind" -gt 0 2>/dev/null ] && git_status_str+="⇣${behind}"
fi

# Shorten home directory
short_cwd="${cwd/#$HOME/~}"

# Build left segment: dir  branch [status]
left=""
printf -v left "%b%s%b" "$LAVENDER" "$short_cwd" "$RESET"

if [ -n "$branch" ]; then
  printf -v left "%s %bon %b %b%s%b" \
    "$left" \
    "$WHITE" "$RESET" \
    "$MAUVE" "$branch" "$RESET"
  if [ -n "$git_status_str" ]; then
    printf -v left "%s %b[%s]%b" "$left" "$RED" "$git_status_str" "$RESET"
  fi
fi

# Build right segment: model  context%
right=""
if [ -n "$model" ]; then
  printf -v right "%b%s%b" "$GRAY" "$model" "$RESET"
fi
if [ -n "$used" ]; then
  used_int=${used%.*}
  if   [ "$used_int" -ge 80 ]; then ctx_color="$RED"
  elif [ "$used_int" -ge 50 ]; then ctx_color="$PEACH"
  else                               ctx_color="$GRAY"
  fi
  printf -v right "%s %b%s%%%b" "$right" "$ctx_color" "$used_int" "$RESET"
fi
if [ -n "$tokens" ]; then
  if [ "$tokens" -ge 1000 ] 2>/dev/null; then
    tok_fmt=$(awk -v t="$tokens" 'BEGIN{printf "%.1fk", t/1000}')
  else
    tok_fmt="${tokens}"
  fi
  printf -v right "%s %b%s%b" "$right" "$PEACH" "$tok_fmt" "$RESET"
fi

printf "%s  %s\n" "$left" "$right"
