#!/usr/bin/env bash
# Claude Code status line
# Format: ~/dir on  branch [status]  vX.Y.Z | Model (1M context) | 661.1k | 66%
# Palette sampled from the mini's statusline
DIR_B='\033[1;38;2;215;215;252m'      # #d7d7fc — directory (bold)
BRANCH_B='\033[1;38;2;209;177;250m'   # #d1b1fa — git branch (bold)
RED='\033[38;2;237;135;150m'          # #ed8796 — git status / high context
TEAL='\033[38;2;183;214;214m'         # #b7d6d6 — version / model
PEACH_B='\033[1;38;2;249;216;180m'    # #f9d8b4 — tokens / context percent (bold)
ON='\033[38;2;167;173;198m'           # #a7adc6 — "on"
GRAY='\033[38;2;123;124;157m'         # #7b7c9d — pipe separators
RESET='\033[0m'

input=$(cat)

cwd=$(echo "$input"      | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input"    | jq -r '.model.display_name // ""')
version=$(echo "$input"  | jq -r '.version // ""')
used=$(echo "$input"     | jq -r '.context_window.used_percentage // empty')
tokens=$(echo "$input"   | jq -r '.context_window.total_input_tokens // empty')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
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

# Left segment: ~/dir on  branch [status]
printf -v left "%b%s%b" "$DIR_B" "$short_cwd" "$RESET"

if [ -n "$branch" ]; then
  printf -v left "%s %bon%b %b %s%b" \
    "$left" \
    "$ON" "$RESET" \
    "$BRANCH_B" "$branch" "$RESET"
  if [ -n "$git_status_str" ]; then
    printf -v left "%s %b[%s]%b" "$left" "$RED" "$git_status_str" "$RESET"
  fi
fi

# Right segment: vX.Y.Z | Model (1M context) | tokens | percent
sep=" ${GRAY}|${RESET} "
parts=()

if [ -n "$version" ]; then
  parts+=("${TEAL}v${version}${RESET}")
fi
if [ -n "$model" ]; then
  model_str="$model"
  if [ "$ctx_size" = "1000000" ]; then
    model_str+=" (1M context)"
  fi
  parts+=("${TEAL}${model_str}${RESET}")
fi
if [ -n "$tokens" ]; then
  if [ "$tokens" -ge 1000 ] 2>/dev/null; then
    tok_fmt=$(awk -v t="$tokens" 'BEGIN{printf "%.1fk", t/1000}')
  else
    tok_fmt="${tokens}"
  fi
  parts+=("${PEACH_B}${tok_fmt}${RESET}")
fi
if [ -n "$used" ]; then
  used_int=${used%.*}
  if [ "$used_int" -ge 80 ]; then ctx_color="$RED"
  else                            ctx_color="$PEACH_B"
  fi
  parts+=("${ctx_color}${used_int}%${RESET}")
fi

right=""
for p in "${parts[@]}"; do
  if [ -z "$right" ]; then right="$p"; else right+="${sep}${p}"; fi
done

printf "%s  %b\n" "$left" "$right"
