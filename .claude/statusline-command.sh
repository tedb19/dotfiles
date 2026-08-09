#!/usr/bin/env bash
# Claude Code status line — mirrors Starship/Catppuccin Macchiato style
# Format: ~/dir on  branch [status]  vX.Y.Z | Model (1M context) | 661.1k | 66%
# Catppuccin Macchiato palette (ANSI approximations)
LAVENDER_B='\033[1;38;2;183;189;248m'    # #b7bdf8 — git branch (bold)
RED='\033[38;2;237;135;150m'             # #ed8796 — git status / high context
YELLOW='\033[38;2;238;212;159m'          # #eed49f — context usage
GRAY='\033[38;2;128;135;162m'            # #8087a2 — overlay1 / dim info
WHITE='\033[38;2;202;211;245m'           # #cad3f5 — text
WHITE_B='\033[1;38;2;202;211;245m'       # #cad3f5 — text (bold)
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
printf -v left "%b%s%b" "$WHITE_B" "$short_cwd" "$RESET"

if [ -n "$branch" ]; then
  printf -v left "%s %bon%b %b %s%b" \
    "$left" \
    "$GRAY" "$RESET" \
    "$LAVENDER_B" "$branch" "$RESET"
  if [ -n "$git_status_str" ]; then
    printf -v left "%s %b[%s]%b" "$left" "$RED" "$git_status_str" "$RESET"
  fi
fi

# Right segment: vX.Y.Z | Model (1M context) | tokens | percent
sep=" ${GRAY}|${RESET} "
parts=()

if [ -n "$version" ]; then
  parts+=("${WHITE}v${version}${RESET}")
fi
if [ -n "$model" ]; then
  model_str="$model"
  if [ "$ctx_size" = "1000000" ]; then
    model_str+=" (1M context)"
  fi
  parts+=("${GRAY}${model_str}${RESET}")
fi
if [ -n "$tokens" ]; then
  if [ "$tokens" -ge 1000 ] 2>/dev/null; then
    tok_fmt=$(awk -v t="$tokens" 'BEGIN{printf "%.1fk", t/1000}')
  else
    tok_fmt="${tokens}"
  fi
  parts+=("${WHITE_B}${tok_fmt}${RESET}")
fi
if [ -n "$used" ]; then
  used_int=${used%.*}
  if [ "$used_int" -ge 80 ]; then ctx_color="$RED"
  else                            ctx_color="$YELLOW"
  fi
  parts+=("${ctx_color}${used_int}%${RESET}")
fi

right=""
for p in "${parts[@]}"; do
  if [ -z "$right" ]; then right="$p"; else right+="${sep}${p}"; fi
done

printf "%s  %b\n" "$left" "$right"
