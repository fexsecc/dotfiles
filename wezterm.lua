-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Font settings
config.font_size = 16
config.font = wezterm.font('JetBrains Mono', { italic = true })
config.color_scheme = 'Tokyo Night'

-- Colors
config.colors = {
    cursor_bg = "white",
    cursor_border = "white"
}

-- Appearance
config.window_decorations = "NONE"
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false

config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0
}

-- Misc
config.max_fps = 180
config.default_prog = { 'pwsh.exe', '-nologo' }

-- Tmux keybindings
config.disable_default_key_bindings = true
config.leader = { key=" ", mods="CTRL" }
config.keys = {
    { 
        key = 'a',
        mods = 'CTRL',
        action = wezterm.action.CopyMode 'MoveToStartOfLine'
    },
    {
        mods = "SHIFT|CTRL",
        key = "c",
        action = wezterm.action.CopyTo 'Clipboard'
    },
    {
        mods = "SHIFT|CTRL",
        key = "v",
        action = wezterm.action.PasteFrom 'Clipboard'
    },
    {
        mods = "LEADER",
        key = "c",
        action = wezterm.action.SpawnTab "CurrentPaneDomain",
    },
    {
        mods = "LEADER",
        key = "x",
        action = wezterm.action.CloseCurrentPane { confirm = true }
    },
    {
        mods = "LEADER",
        key = "p",
        action = wezterm.action.ActivateTabRelative(-1)
    },
    {
        mods = "LEADER",
        key = "n",
        action = wezterm.action.ActivateTabRelative(1)
    },
    {
        mods = "LEADER",
        key = "\"",
        action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" }
    },
    {
        mods = "LEADER",
        key = "%",
        action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" }
    },
    {
        mods = "CTRL",
        key = "h",
        action = wezterm.action.ActivatePaneDirection "Left"
    },
    {
        mods = "CTRL",
        key = "j",
        action = wezterm.action.ActivatePaneDirection "Down"
    },
    {
        mods = "CTRL",
        key = "k",
        action = wezterm.action.ActivatePaneDirection "Up"
    },
    {
        mods = "CTRL",
        key = "l",
        action = wezterm.action.ActivatePaneDirection "Right"
    }
}

-- bind 1-9 to switching windows
for i = 0, 9 do
    -- leader + number to activate that tab
    table.insert(config.keys, {
        key = tostring(i),
        mods = "LEADER",
        action = wezterm.action.ActivateTab(i-1),
    })
end

-- smart-splits
local smart_splits = wezterm.plugin.require('https://github.com/mrjones2014/smart-splits.nvim')

smart_splits.apply_to_config(config, {
  -- the default config is here, if you'd like to use the default keys,
  -- you can omit this configuration table parameter and just use
  -- smart_splits.apply_to_config(config)

  -- directional keys to use in order of: left, down, up, right
  direction_keys = { 'h', 'j', 'k', 'l' },
  -- if you want to use separate direction keys for move vs. resize, you
  -- can also do this:
  direction_keys = {
    move = { 'h', 'j', 'k', 'l' },
    resize = { 'LeftArrow', 'DownArrow', 'UpArrow', 'RightArrow' },
  },
  -- modifier keys to combine with direction_keys
  modifiers = {
    move = 'CTRL', -- modifier to use for pane movement, e.g. CTRL+h to move left
    resize = 'META', -- modifier to use for pane resize, e.g. META+h to resize to the left
  },
  -- log level to use: info, warn, error
  log_level = 'info',
})

-- Finally, return the configuration to wezterm:
return config
