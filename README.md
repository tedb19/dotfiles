# Dotfiles

Personal macOS (Apple Silicon) dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/). Configs live under `.config/` and are symlinked into `~` by `stow -t ~ .`.

## Install

```sh
git clone git@github.com:tedb19/dotfiles.git ~/Area51/dotfiles
cd ~/Area51/dotfiles
./quickstart.sh
```

`quickstart.sh` installs Homebrew, formulae (`brew-packages.txt`) and casks, symlinks configs with stow, installs runtimes via asdf, and wires up herdr agent integrations.

## Manual setup

Some steps can't be scripted (macOS security prompts, credential logins, GUI-only settings). Do these after `quickstart.sh`:

### Shell / editor
- Restart the terminal, or `source ~/.zshrc`.
- VS Code: Command Palette → **Shell Command: Install 'code' command in PATH**.

### GitHub CLI
- `gh auth login` — credentials (`.config/gh/hosts.yml`) are gitignored, so auth is per-machine.

### Karabiner-Elements (Caps Lock → F18, herdr prefix)
Karabiner needs OS permissions and a privileged daemon that only start after approval + reboot. Without these, the Caps Lock remap silently does nothing.

1. **Privacy & Security → Input Monitoring** and **→ Accessibility**: enable **Karabiner-Elements** in both.
2. **General → Login Items & Extensions → Driver Extensions**: enable **Karabiner** (the `org.pqrs` DriverKit extension).
3. **General → Login Items & Extensions → "Allow in the Background"**: enable **Karabiner-Elements** and **Karabiner-Elements Privileged Daemons**. This is separate from the permissions above and easy to miss.
4. **Reboot.** The `Karabiner-VirtualHIDDevice-Daemon` registers on next boot; until it runs, the key grabber loops `bind_failed` and no keys are remapped.
5. Verify: open **Karabiner-EventViewer**, press **Caps Lock** → it should report `f18`. Then in herdr, press Caps Lock as the prefix (herdr `prefix = "f18"`).

Troubleshoot: `pgrep -lf VirtualHIDDevice-Daemon` must print a PID. If empty after reboot, re-check step 3, then restart Karabiner from its menu bar icon.

### Raycast (Opt+W → Ghostty quick access)
Raycast hotkeys live in an encrypted local store (`~/Library/Application Support/com.raycast.macos/`), **not** in this repo, so they don't sync via stow.

- Set the app hotkey: Raycast Settings → search **Ghostty** → **Record Hotkey** → `Opt+W`.
- Sign in to Raycast for its own cloud sync of settings/extensions across machines.

### herdr
- Agent integrations are installed by `quickstart.sh` (`herdr integration install claude|opencode`); the Claude hooks land outside the stow tree, per machine.
- The single-key prefix (Caps Lock) depends on the Karabiner setup above.

### Claude Code statusline
- The statusline script (`.claude/statusline-command.sh`) is stowed into `~/.claude/`, and `quickstart.sh` wires the `statusLine` reference into `~/.claude/settings.json` with a portable `~` path. No manual step.
