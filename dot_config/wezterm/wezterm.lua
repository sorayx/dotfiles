local wezterm = require 'wezterm'
local config = {}

-- Window

config.window_decorations = "NONE"
config.enable_tab_bar = false
config.window_background_opacity = 0.8
config.text_background_opacity = 1.0
config.window_padding = {
  left = "0cell",
  right = "0cell",
  top = "0cell",
  bottom = "0cell",
}

-- Color

-- Cursor

config.colors = {

  -- Marker
  selection_bg = "rgba(180, 180, 180, 0.35)",
  selection_fg = "none",

  cursor_bg = "#DDDDDD",
  cursor_fg = "#000000", -- Text im Cursor
  cursor_border = "DDDDDD",
}

-- Font

config.font = wezterm.font_with_fallback({
  'JetBrainsMono Nerd Font',
  'Noto Sans Symbols 2',
  'Noto Sans Symbols',
  'Noto Color Emoji',
  'JetBrains Mono',
})
config.font_size = 13.0

return config
