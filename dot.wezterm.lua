local helpers = require 'helpers'
local wezterm = require 'wezterm'

wezterm.on('toggle-light-colorscheme', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if not overrides.color_scheme then
    overrides.color_scheme = 'Rosé Pine Dawn (Gogh)'
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
helpers.apply_to_config(config)
config.keys = {
    {
        key = 'E',
        mods = 'CTRL',
        action = wezterm.action.EmitEvent 'toggle-light-colorscheme',
    },
}
return config
