--
-- ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
-- ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
-- ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
-- ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
-- ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
-- A GPU-accelerated cross-platform terminal emulator
-- https://wezfurlong.org/wezterm/
local wezterm = require('wezterm')

local wallpaper = os.getenv("HOME") .. "/.config/wezterm/wallpapers/sunset-tranquil-coastline.jpg"

local dimmer = { brightness = 0.1 }

config = wezterm.config_builder()

config = {
    automatically_reload_config = true,
    enable_tab_bar = false,
    window_close_confirmation = "NeverPrompt",
    window_decorations = "RESIZE", -- disable title bar, but enable resizable border
    default_cursor_style = "BlinkingBar",
    color_scheme = "Catppuccin Mocha",
    -- color_scheme = "Catppuccin Macchiato",
    -- color_scheme = 'Tokyo Night',

    -- font
    font = wezterm.font_with_fallback({ family = "JetBrainsMono Nerd Font Mono Propo", scale = 1, weight = "Bold" }),
    font_size = 15,

    -- background
    -- window_background_opacity = 0.9,
    macos_window_background_blur = 50,

    -- padding
    window_padding = {
	    left = 30,
	    right = 30,
	    top = 10,
	    bottom = 10,
     },

    native_macos_fullscreen_mode = true,

    background = {
		-- {
    --     source = { File = wallpaper },
    --     height = "Cover",
    --     width = "Cover",
    --     horizontal_align = "Center",
    --     repeat_x = "Repeat",
    --     repeat_y = "Repeat",
    --     opacity = 0.9,
    --     hsb = dimmer,
    --     -- speed = 200,
    -- },
    {
      source = {Color = "black"},
      opacity = 1,
      hsb = dimmer,
    }
	}
}

return config
