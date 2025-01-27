local wezterm = require 'wezterm'

local module = {}

local function setup_font(config)
    config.font = wezterm.font 'Monaspace Xenon'
    -- config.font = wezterm.font 'JetBrains Mono'
    config.font_size = 14.0
end

local function setup_dark_colorscheme(config)
    config.color_scheme = 'Rosé Pine (Gogh)'
end

local function setup_light_colorscheme(config)
    config.color_scheme = 'Rosé Pine Dawn (Gogh)'
end

local function disable_ligatures(config)
    config.harfbuzz_features = { 'calt=0' }
end

local function setup_window_padding(config)
    config.window_padding = {
        left = 5,
        right = 6,
        top = 5,
        bottom = 5,
    }
end

-- This sets up the deadkeys so that using vim is better.
-- https://wezfurlong.org/wezterm/config/keyboard-concepts.html#defining-assignments-for-key-combinations-that-may-be-composed
local function setup_deadkey(config)
    config.use_dead_keys = false
end

local function setup_quick_select(config)
    config.leader = { key = 'Space', mods = 'CTRL|SHIFT' }
    config.keys = {
        {
            key = 'a',
            mods = 'LEADER',
            action = wezterm.action.QuickSelect,
        },
    }
end

local function setup_light_colors(config)
    config.keys = {
        {
            key = 'e',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.EmitEvent 'toggle-colorscheme',
        },
    }
end

local function setup_left_option_key(config)
    config.send_composed_key_when_left_alt_is_pressed = false
    config.send_composed_key_when_right_alt_is_pressed = true
end

function module.apply_to_config(config)
    setup_left_option_key(config)
    setup_font(config)
    setup_dark_colorscheme(config)
    -- setup_light_colors(config)
    setup_deadkey(config)
    setup_window_padding(config)
    disable_ligatures(config)
    setup_quick_select(config)
end

return module
