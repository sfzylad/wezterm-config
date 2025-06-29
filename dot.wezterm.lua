-- local helpers = require 'helpers'
local wezterm = require 'wezterm'

wezterm.on('toggle-light-colorscheme', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if not overrides.color_scheme then
    overrides.color_scheme = 'Github'
    -- overrides.color_scheme = 'Rosé Pine Dawn (Gogh)'
  else
    overrides.color_scheme = nil
  end
  window:set_config_overrides(overrides)
end)

wezterm.on('toggle-dark-colorscheme', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if not overrides.color_scheme then
    overrides.color_scheme = 'Rosé Pine Dawn (Gogh)'
    -- overrides.window_background_opacity = 0.5
  else
    overrides.color_scheme = nil
  end
  window:set_config_overrides(overrides)
end)

-- local config = {}
local config = wezterm.config_builder()
-- helpers.apply_to_config(config)

config.font = wezterm.font 'Monaspace Xenon'
config.font_size = 13.5
config.color_scheme = 'Rosé Pine (Gogh)'
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
