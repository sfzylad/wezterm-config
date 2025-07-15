local io = require 'io'
local os = require 'os'

local wezterm = require 'wezterm'
local act = wezterm.action

-- Helper functions
local write_theme = function (content)
    local h = os.getenv("HOME")
    local theme_dir = h .. "/" .. "tmp"
    os.execute("mkdir -p " .. theme_dir)
    local theme_file = h .. "/" .. "tmp" .. "/" .. ".theme"

    local f = io.open(theme_file, "w+")
    f:write(content)
    f:flush()
    f:close()
end

local format_time = function()
  local date = os.date("%I:%M %p")
  return date
end

local function update_status(window, pane)
  window:set_right_status(format_time())
end

wezterm.on("active-pane-changed", function(window, pane)
  update_status(window, pane)
end)

wezterm.on("update-right-status", function(window, pane)
  update_status(window, pane)
end)

wezterm.on("gui-startup", function(window, pane)
  update_status(window, pane)
end)

wezterm.on('toggle-light-colorscheme', function(window, pane)
  local name = '/Users/dzyla/tmp/.theme'
  local overrides = window:get_config_overrides() or {}
  if not overrides.color_scheme then
    overrides.color_scheme = 'Github'
    write_theme("--light --syntax-theme=GitHub")
  else
    overrides.color_scheme = nil
    write_theme("--dark --syntax-theme=ansi")
  end
  window:set_config_overrides(overrides)
end)

-- Config starts here
local config = wezterm.config_builder()

config.font = wezterm.font 'Monaspace Xenon'
config.font_size = 13.5
-- config.color_scheme = 'Rosé Pine (Gogh)'
config.color_scheme = 'Mellifluous'
config.harfbuzz_features = { 'calt=0' }
config.custom_block_glyphs = false
config.use_dead_keys = false
config.leader = { key = 'Space', mods = 'ALT|CTRL|SHIFT' }
config.keys = {
    {
        key = 'a',
        mods = 'LEADER',
        action = wezterm.action.QuickSelect,
    },
}

-- Cursor
config.cursor_thickness = 1
config.cursor_blink_rate = 500
config.animation_fps = 1
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'

-- Visual bell
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 50,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 50,
}

-- Padding
local padding = 1
config.window_padding = {
    left = padding,
    right = padding,
    top = padding,
    bottom = padding,
}
-- config.window_padding = {
--     left = 5,
--     right = 6,
--     top = 5,
--     bottom = 5,
-- }

-- UI
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.max_fps = 144

-- Disable audible bell
config.audible_bell = "Disabled"

config.colors = {
  visual_bell = '#202020',
}

config.quick_select_patterns = {
  '[k-z]{6,40}', -- JJ ChangeID
}

config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true
config.window_background_opacity = 0.95

config.keys = {
    {
        key = 'E',
        mods = 'CTRL',
        action = wezterm.action.EmitEvent 'toggle-light-colorscheme',
    },
}

return config
