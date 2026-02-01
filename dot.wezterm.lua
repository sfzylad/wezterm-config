local io = require 'io'
local os = require 'os'

local wezterm = require 'wezterm'

-- Helper functions
local write_theme = function(content)
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

local function update_status(window, _)
    window:set_right_status(format_time())
end


-- Function to get the current process name
local function get_current_process_name(tab)
    local process_name = tab.active_pane.foreground_process_name
    if process_name == "" then
        process_name = "wezterm"
    else
        -- Extract the last part of the process name (e.g., "bash" from "/usr/bin/bash")
        process_name = string.match(process_name, "([^/]+)$")
    end
    return process_name
end

-- Function to periodically update the tab titles
wezterm.on('update-right-status', function(window, _)
    window:set_right_status(" ")
end)


-- Config starts here
local config = wezterm.config_builder()

-- config.font = wezterm.font 'Monaspace Xenon'
config.font = wezterm.font {
    family = 'Fira Code',
    -- https://github.com/tonsky/FiraCode/wiki/How-to-enable-stylistic-sets
    harfbuzz_features = {
        'calt=0', -- disable all ligatures and then enable just selected few
        'cv05',   -- nicer 'i'
        'cv09',   -- nicer 'l'
        'cv31',   -- nicer brackets
        'ss03',   -- nicer &
        'ss05',   -- nicer @
    },
}
config.font_size = 13.5

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

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
    local title = tab_info.tab_title
    -- if the tab title is explicitly set, take that
    if title and #title > 0 then
        return title
    end
    -- Otherwise, use the title from the active pane
    -- in that tab
    return tab_info.active_pane.title
end

wezterm.on(
    'format-tab-title',
    function(tab, _, _, _, hover, max_width)
        local process_name = get_current_process_name(tab)
        local edge_background = '#0b0022'
        local background = '#1b1032'
        local foreground = '#808080'

        if tab.is_active then
            background = '#2b2042'
            foreground = '#c0c0c0'
        elseif hover then
            background = '#3b3052'
            foreground = '#909090'
        end

        local edge_foreground = background

        local title = tab_title(tab)

        -- ensure that the titles fit in the available space,
        -- and that we have room for the edges.
        title = wezterm.truncate_right(title, max_width - 2)

        return {
            { Background = { Color = edge_background } },
            { Foreground = { Color = edge_foreground } },
            { Text = SOLID_LEFT_ARROW },
            { Background = { Color = background } },
            { Foreground = { Color = foreground } },
            { Text = process_name },
            { Background = { Color = edge_background } },
            { Foreground = { Color = edge_foreground } },
            { Text = SOLID_RIGHT_ARROW },
        }
    end
)

wezterm.on("active-pane-changed", function(window, pane)
    update_status(window, pane)
end)

wezterm.on("update-right-status", function(window, pane)
    update_status(window, pane)
end)

wezterm.on("gui-startup", function(window, pane)
    update_status(window, pane)
end)

wezterm.on('toggle-light-colorscheme', function(window, _)
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

return config
