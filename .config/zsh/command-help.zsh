#!/usr/bin/env zsh
#
# Command Help System
# General help system for documenting and discovering custom commands

# Internal function to parse @help comments from files
function __parse_help_data() {
  local help_data=""

  # Parse git-workflows.zsh
  if [[ -f "$HOME/.config/zsh/git-workflows.zsh" ]]; then
    help_data+=$(grep "^# @help:" "$HOME/.config/zsh/git-workflows.zsh" | sed 's/^# @help: //')
    help_data+=$'\n'
  fi

  # Parse aliases.zsh for documented aliases
  if [[ -f "$HOME/.config/zsh/aliases.zsh" ]]; then
    help_data+=$(grep "^# @help:" "$HOME/.config/zsh/aliases.zsh" | sed 's/^# @help: //')
    help_data+=$'\n'
  fi

  # Remove trailing newline and output
  echo -n "$help_data"
}

# Internal function to format help data for simple display
function __format_help_simple() {
  local category=""
  local prev_category=""

  __parse_help_data | while IFS='|' read -r cat cmd desc usage example; do
    # Trim whitespace
    cat=$(echo "$cat" | xargs)
    cmd=$(echo "$cmd" | xargs)
    desc=$(echo "$desc" | xargs)
    usage=$(echo "$usage" | xargs)

    # Print category header if changed
    if [[ "$cat" != "$prev_category" ]]; then
      [[ -n "$prev_category" ]] && echo  # blank line between categories
      gum style --bold --foreground 35 "━━━ $cat ━━━"
      echo
      prev_category="$cat"
    fi

    # Print command info
    gum style --bold --foreground 214 "  $cmd"
    echo "    $desc"
    echo "    Usage: $usage"
    echo
  done
}

# Internal function to format help data for fzf display
function __format_help_fzf() {
  __parse_help_data | while IFS='|' read -r cat cmd desc usage example; do
    # Trim whitespace
    cat=$(echo "$cat" | xargs)
    cmd=$(echo "$cmd" | xargs)
    desc=$(echo "$desc" | xargs)

    # Format: [Category] command - description
    printf "[%s] %s - %s\n" "$cat" "$cmd" "$desc"
  done
}

# Internal function to generate preview for fzf
function __generate_preview() {
  local selected="$1"

  # Extract command name from selection
  local cmd=$(echo "$selected" | sed -E 's/^\[.*\] ([^ ]+) -.*/\1/')

  # Find the full help data for this command
  __parse_help_data | while IFS='|' read -r cat command desc usage example; do
    command=$(echo "$command" | xargs)

    if [[ "$command" == "$cmd" ]]; then
      cat=$(echo "$cat" | xargs)
      desc=$(echo "$desc" | xargs)
      usage=$(echo "$usage" | xargs)
      example=$(echo "$example" | xargs)

      # Generate styled preview
      gum style --bold --foreground 35 "$command"
      echo
      gum style --foreground 214 "Category: $cat"
      echo
      gum style --bold "Description:"
      echo "$desc"
      echo
      gum style --bold "Usage:"
      gum style --foreground 33 "  $usage"
      echo
      gum style --bold "Example:"
      gum style --foreground 33 "  $example"

      # Try to find function definition and show first few lines
      if declare -f "$command" > /dev/null 2>&1; then
        echo
        gum style --bold "Implementation:"
        declare -f "$command" | head -n 10 | tail -n +2
      fi

      return
    fi
  done
}

# Main help command
# @help: Help System | ch | Show help for custom commands | ch [--interactive|-i] [filter] | ch git
function ch() {
  local interactive=false
  local filter=""

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -i|--interactive)
        interactive=true
        shift
        ;;
      *)
        filter="$1"
        shift
        ;;
    esac
  done

  if [[ "$interactive" == true ]]; then
    # Interactive mode with fzf
    local help_list=$(__format_help_fzf)

    if [[ -n "$filter" ]]; then
      help_list=$(echo "$help_list" | grep -i "$filter")
    fi

    if [[ -z "$help_list" ]]; then
      gum style --foreground 196 "No commands found matching filter: $filter"
      return 1
    fi

    local selected=$(echo "$help_list" | fzf \
      --height=80% \
      --border \
      --prompt="Search commands > " \
      --preview="source $HOME/.config/zsh/command-help.zsh && __generate_preview {}" \
      --preview-window=right:60% \
      --header="Press ENTER to select, ESC to exit")

    if [[ -n "$selected" ]]; then
      local cmd=$(echo "$selected" | sed -E 's/^\[.*\] ([^ ]+) -.*/\1/')
      echo
      gum style --foreground 35 "Selected command: $cmd"

      if gum confirm "Copy example to clipboard?" 2>/dev/null; then
        # Extract example and copy to clipboard
        local example=$(__parse_help_data | grep "|$cmd|" | cut -d'|' -f5 | xargs)
        if [[ -n "$example" ]]; then
          echo -n "$example" | pbcopy
          gum style --foreground 35 "✓ Copied to clipboard: $example"
        fi
      fi
    fi
  else
    # Simple list mode
    gum style --bold --border double --padding "0 1" --margin "1 0" \
      --foreground 35 "Custom Command Help"
    echo

    if [[ -n "$filter" ]]; then
      __format_help_simple | grep -i "$filter" -A 3 --color=never
    else
      __format_help_simple
    fi

    echo
    gum style --italic --foreground 240 "💡 Use 'ch -i' for interactive mode with examples and search"
  fi
}
