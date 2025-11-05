#!/usr/bin/env zsh
#
# Git Worktree & Branch Workflows with Gum
# Interactive git worktree and branch management using gum and fzf

# @help: Git Workflows | gwi | Initialize .trees folder in git repository | gwi | gwi
function gwi() {
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    gum style --foreground 196 "Not in a git repository"
    return 1
  fi

  local git_root=$(git rev-parse --show-toplevel)
  local trees_dir="$git_root/.trees"

  if [[ -d "$trees_dir" ]]; then
    gum style --foreground 214 "✓ .trees directory already exists at $trees_dir"
    return 0
  fi

  mkdir -p "$trees_dir"
  gum style --foreground 35 "✓ Created .trees directory at $trees_dir"

  # Add to .gitignore if not already there
  local gitignore="$git_root/.gitignore"
  if [[ -f "$gitignore" ]] && ! grep -q "^\.trees/$" "$gitignore"; then
    echo ".trees/" >> "$gitignore"
    gum style --foreground 35 "✓ Added .trees/ to .gitignore"
  fi
}

# @help: Git Workflows | gw | Switch to existing worktree using fzf | gw | gw
function gw() {
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    gum style --foreground 196 "Not in a git repository"
    return 1
  fi

  local git_root=$(git rev-parse --show-toplevel)

  # Get list of worktrees (excluding main worktree)
  local worktrees=$(git worktree list --porcelain | awk '
    /^worktree/ { path=$2 }
    /^branch/ {
      gsub(/.*\//, "", $2)
      branch=$2
    }
    /^$/ {
      if (path != "") {
        print path " (" branch ")"
        path=""
        branch=""
      }
    }
  ')

  if [[ -z "$worktrees" ]]; then
    gum style --foreground 214 "No worktrees found. Use 'gwn' to create one."
    return 0
  fi

  # Use fzf to select worktree
  local selected=$(echo "$worktrees" | fzf \
    --height=40% \
    --border \
    --prompt="Select worktree > " \
    --preview="echo {}; echo; ls -la {1}" \
    --preview-window=right:50%)

  if [[ -n "$selected" ]]; then
    local worktree_path=$(echo "$selected" | awk '{print $1}')
    cd "$worktree_path" && gum style --foreground 35 "✓ Switched to $(basename $worktree_path)"
  fi
}

# @help: Git Workflows | gwn | Create new worktree in .trees/ folder | gwn [branch-name] | gwn feature-auth
function gwn() {
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    gum style --foreground 196 "Not in a git repository"
    return 1
  fi

  local git_root=$(git rev-parse --show-toplevel)
  local trees_dir="$git_root/.trees"

  # Ensure .trees directory exists
  if [[ ! -d "$trees_dir" ]]; then
    if gum confirm "Create .trees directory?"; then
      gwi
    else
      return 1
    fi
  fi

  # Get branch name (from argument or prompt)
  local branch_name="$1"
  if [[ -z "$branch_name" ]]; then
    branch_name=$(gum input --placeholder "Enter branch name")
    if [[ -z "$branch_name" ]]; then
      gum style --foreground 196 "Branch name required"
      return 1
    fi
  fi

  local worktree_path="$trees_dir/$branch_name"

  # Check if worktree already exists
  if [[ -d "$worktree_path" ]]; then
    gum style --foreground 196 "Worktree already exists at $worktree_path"
    return 1
  fi

  # Ask if creating new branch or using existing
  local create_new=$(gum choose --header="Branch strategy" "Create new branch" "Use existing branch")

  if [[ "$create_new" == "Create new branch" ]]; then
    # Ask for base branch
    local base_branch=$(git branch --format="%(refname:short)" | fzf \
      --height=40% \
      --border \
      --prompt="Select base branch > " \
      --preview="git log --oneline --graph --color=always {}" \
      --preview-window=right:60%)

    if [[ -z "$base_branch" ]]; then
      gum style --foreground 196 "Base branch required"
      return 1
    fi

    # Create worktree with new branch
    gum spin --spinner dot --title "Creating worktree..." -- \
      git worktree add -b "$branch_name" "$worktree_path" "$base_branch"
  else
    # Use existing branch
    local existing_branch=$(git branch --all --format="%(refname:short)" | sed 's|origin/||' | sort -u | fzf \
      --height=40% \
      --border \
      --prompt="Select existing branch > " \
      --preview="git log --oneline --graph --color=always {}" \
      --preview-window=right:60%)

    if [[ -z "$existing_branch" ]]; then
      gum style --foreground 196 "Branch required"
      return 1
    fi

    # Create worktree with existing branch
    gum spin --spinner dot --title "Creating worktree..." -- \
      git worktree add "$worktree_path" "$existing_branch"
  fi

  if [[ $? -eq 0 ]]; then
    gum style --foreground 35 "✓ Created worktree at $worktree_path"
    if gum confirm "Switch to new worktree?"; then
      cd "$worktree_path"
    fi
  else
    gum style --foreground 196 "Failed to create worktree"
    return 1
  fi
}

# @help: Git Workflows | gwm | Interactive worktree manager menu | gwm | gwm
function gwm() {
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    gum style --foreground 196 "Not in a git repository"
    return 1
  fi

  local action=$(gum choose --header="Worktree Manager" \
    "List worktrees" \
    "Add worktree" \
    "Remove worktree" \
    "Prune stale worktrees" \
    "Initialize .trees" \
    "Exit")

  case "$action" in
    "List worktrees")
      git worktree list
      ;;
    "Add worktree")
      gwn
      ;;
    "Remove worktree")
      local git_root=$(git rev-parse --show-toplevel)

      # Get worktrees, excluding the main repository
      local worktrees=$(git worktree list --porcelain | awk -v root="$git_root" '
        /^worktree/ {
          sub(/^worktree /, "")
          path=$0
        }
        /^branch/ {
          sub(/^branch /, "")
          sub(/.*\//, "")
          branch=$0
        }
        /^$/ {
          if (path != "" && path != root) {
            print path "|" branch
            path=""
            branch=""
          }
        }
      ')

      if [[ -z "$worktrees" ]]; then
        gum style --foreground 214 "No worktrees to remove"
        return 0
      fi

      # Format for display
      local display_list=$(echo "$worktrees" | awk -F'|' '{
        printf "%s (%s)\n", $1, $2
      }')

      local selected=$(echo "$display_list" | fzf \
        --height=40% \
        --border \
        --prompt="Select worktree to remove > " \
        --preview="path=\$(echo {} | awk '{print \$1}'); echo \$path; echo; ls -la \$path 2>/dev/null")

      if [[ -n "$selected" ]]; then
        local worktree_path=$(echo "$selected" | sed 's/ (.*//')
        gum style --foreground 214 "Selected: $worktree_path"

        if gum confirm "Remove this worktree? This will delete the directory."; then
          # Try to remove, capture error
          local error_output
          error_output=$(git worktree remove "$worktree_path" 2>&1)
          local exit_code=$?

          if [[ $exit_code -eq 0 ]]; then
            gum style --foreground 35 "✓ Removed worktree"
          else
            gum style --foreground 196 "Failed to remove worktree:"
            echo "$error_output"

            # Offer force removal if it failed
            if echo "$error_output" | grep -q "contains modified or untracked files"; then
              if gum confirm "Worktree has uncommitted changes. Force remove?"; then
                git worktree remove --force "$worktree_path"
                if [[ $? -eq 0 ]]; then
                  gum style --foreground 35 "✓ Force removed worktree"
                fi
              fi
            fi
          fi
        fi
      fi
      ;;
    "Prune stale worktrees")
      if gum confirm "Prune stale worktree information?"; then
        git worktree prune -v
        gum style --foreground 35 "✓ Pruned stale worktrees"
      fi
      ;;
    "Initialize .trees")
      gwi
      ;;
    "Exit")
      return 0
      ;;
  esac
}

# @help: Git Workflows | gbc | Enhanced branch checkout with fzf and git log preview | gbc | gbc
function gbc() {
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    gum style --foreground 196 "Not in a git repository"
    return 1
  fi

  local branches=$(git branch --all --format="%(refname:short)" | sed 's|origin/||' | sort -u)

  local selected=$(echo "$branches" | fzf \
    --height=60% \
    --border \
    --prompt="Select branch > " \
    --preview="git log --oneline --graph --color=always --date=short --pretty='format:%C(auto)%h %C(green)%ad %C(blue)%an%C(auto)%d %s' {}" \
    --preview-window=right:60%)

  if [[ -n "$selected" ]]; then
    gum spin --spinner dot --title "Checking out branch..." -- \
      git checkout "$selected"

    if [[ $? -eq 0 ]]; then
      gum style --foreground 35 "✓ Switched to branch: $selected"
    else
      gum style --foreground 196 "Failed to checkout branch"
    fi
  fi
}

# @help: Git Workflows | gws | Show quick status of all worktrees | gws | gws
function gws() {
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    gum style --foreground 196 "Not in a git repository"
    return 1
  fi

  gum style --bold --foreground 35 "Git Worktrees"
  echo

  git worktree list --porcelain | awk '
    BEGIN { worktree="" }
    /^worktree/ { worktree=$2 }
    /^HEAD/ { head=$2 }
    /^branch/ {
      gsub(/.*\//, "", $2)
      branch=$2
    }
    /^$/ {
      if (worktree != "") {
        printf "📁 %s\n", worktree
        printf "   🌿 Branch: %s\n", (branch != "" ? branch : "detached")
        printf "   📌 HEAD: %.8s\n\n", head
        worktree=""
        branch=""
        head=""
      }
    }
  '
}
