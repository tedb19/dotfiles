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

config = {
	automatically_reload_config = true,
	enable_tab_bar = false,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE", -- disable title bar, but enable resizable border
	default_cursor_style = "BlinkingBar",
	color_scheme = "Tokyo Night",
	-- color_scheme = "Catppuccin Mocha (Gogh)",
	-- color_scheme = 'Tokyo Night',

	-- font
	-- try JetBrainsMono Nerd Font Propo if this doesn't work
	font = wezterm.font_with_fallback({
		family = "JetBrainsMono Nerd Font Mono Propo",
		scale = 1,
		weight = "ExtraBold",
		stretch = "Expanded",
	}),

	font_size = 14,
	line_height = 1.2,

	-- padding
	window_padding = {
		left = 30,
		right = 30,
		top = 30,
		bottom = 30,
	},

	native_macos_fullscreen_mode = true,

	keys = {
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
	},
}

return config