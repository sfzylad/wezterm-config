local io = require 'io'
local os = require 'os'

local wezterm = require 'wezterm'
local act = wezterm.action

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

-- local config = {}
local config = wezterm.config_builder()
-- helpers.apply_to_config(config)

config.font = wezterm.font 'Monaspace Xenon'
config.font_size = 13.5
config.color_scheme = 'Rosé Pine (Gogh)'
-- config.color_scheme = 'Mellifluous'
config.harfbuzz_features = { 'calt=0' }
config.window_padding = {
    left = 5,
    right = 6,
    top = 5,
    bottom = 5,
}
config.use_dead_keys = false
config.leader = { key = 'Space', mods = 'ALT|CTRL|SHIFT' }
config.keys = {
    {
        key = 'a',
        mods = 'LEADER',
        action = wezterm.action.QuickSelect,
    },
}

config.quick_select_patterns = {
  '[k-z]{6,40}', -- JJ ChangeID
}

config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true

config.keys = {
    {
        key = 'E',
        mods = 'CTRL',
        action = wezterm.action.EmitEvent 'toggle-light-colorscheme',
    },
}

return config
