local helpers = require 'helpers'
local wezterm = require 'wezterm'

-- local config = {}
local config = wezterm.config_builder()
helpers.apply_to_config(config)
return config
