--
-- ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
-- ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
-- ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
-- ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
-- ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
-- A GPU-accelerated cross-platform terminal emulator
-- https://wezfurlong.org/wezterm/
local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- general
config.automatically_reload_config = true
config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE" -- disable title bar, but enable resizable border
config.default_cursor_style = "BlinkingBar"
config.color_scheme = "Catppuccin Mocha (Gogh)"

-- GPU rendering
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

-- font
config.font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Medium" })
config.font_size = 14
config.line_height = 1.5

-- scrollback
config.scrollback_lines = 5000

-- padding
config.window_padding = {
	left = 30,
	right = 30,
	top = 30,
	bottom = 30,
}

config.native_macos_fullscreen_mode = true

config.keys = {
	-- ═══ Line editing ═══
	-- CMD+Left: go to start of line (Ctrl+A)
	{ key = "LeftArrow", mods = "SUPER", action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }) },
	-- CMD+Right: go to end of line (Ctrl+E)
	{ key = "RightArrow", mods = "SUPER", action = wezterm.action.SendKey({ key = "e", mods = "CTRL" }) },
	-- OPT+Left: move back one word (ESC b)
	{ key = "LeftArrow", mods = "OPT", action = wezterm.action.SendString("\x1bb") },
	-- OPT+Right: move forward one word (ESC f)
	{ key = "RightArrow", mods = "OPT", action = wezterm.action.SendString("\x1bf") },
	-- SHIFT+CMD+Backspace: delete entire line to left (Ctrl+U)
	{ key = "Backspace", mods = "SHIFT|SUPER", action = wezterm.action.SendKey({ key = "u", mods = "CTRL" }) },
	-- SHIFT+OPT+Backspace: delete word backward (Ctrl+W)
	{ key = "Backspace", mods = "SHIFT|OPT", action = wezterm.action.SendKey({ key = "w", mods = "CTRL" }) },
	-- SHIFT+Enter: send CSI u sequence so apps (e.g. Claude Code) can distinguish Shift+Enter
	{ key = "Enter", mods = "SHIFT", action = wezterm.action.SendString("\x1b[13;2u") },

	-- ═══ Pane splitting ═══
	-- Ctrl+Shift+\ : split horizontal (side by side)
	{ key = "\\", mods = "CMD|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	-- Ctrl+Shift+- : split vertical (top/bottom)
	{ key = "-", mods = "CMD|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- ═══ Pane navigation ═══
	{ key = "LeftArrow", mods = "CMD|SHIFT", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "RightArrow", mods = "CMD|SHIFT", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "UpArrow", mods = "CMD|SHIFT", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "DownArrow", mods = "CMD|SHIFT", action = wezterm.action.ActivatePaneDirection("Down") },

	-- ═══ Pane resize (vim-style) ═══
	{ key = "h", mods = "CMD|SHIFT", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
	{ key = "l", mods = "CMD|SHIFT", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
	{ key = "k", mods = "CMD|SHIFT", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
	{ key = "j", mods = "CMD|SHIFT", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },

	-- ═══ Pane management ═══
	-- Ctrl+Shift+Z : toggle zoom (fullscreen a pane, press again to restore)
	{ key = "z", mods = "CMD|SHIFT", action = wezterm.action.TogglePaneZoomState },
	-- Ctrl+Shift+W : close current pane
	{ key = "w", mods = "CMD|SHIFT", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
}

return config