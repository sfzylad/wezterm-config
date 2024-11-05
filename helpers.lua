local wezterm = require 'wezterm'

local module = {}

local function setup_font(config)
    config.font = wezterm.font 'JetBrains Mono'
    config.font_size = 13.0
end

local function setup_colorscheme(config)
    config.color_scheme = 'Rosé Pine (Gogh)'
end

-- This sets up the deadkeys so that using vim is better.
-- https://wezfurlong.org/wezterm/config/keyboard-concepts.html#defining-assignments-for-key-combinations-that-may-be-composed
local function setup_deadkey(config)
    config.use_dead_keys = false
end

local function setup_left_option_key(config)
    config.send_composed_key_when_left_alt_is_pressed = false
    config.send_composed_key_when_right_alt_is_pressed = true
end

function module.apply_to_config(config)
    setup_left_option_key(config)
    setup_font(config)
    setup_colorscheme(config)
    setup_deadkey(config)
end

return module
