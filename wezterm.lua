-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Font settings
config.font_size = 16
config.font = wezterm.font('JetBrains Mono', { italic = true })
--config.color_scheme = 'Tokyo Night'
config.color_scheme = 'GitHub Dark'

-- Colors
config.colors = {
    cursor_bg = "white",
    cursor_border = "white",
    foreground = "silver",
    background = '#0a0c10',
    tab_bar = {
        -- The color of the inactive tab bar edge/divider
        background = '#0a0c10',
        active_tab = {
            bg_color = '#2b2042',
            fg_color = 'silver',
        },
        inactive_tab = {
            bg_color = '#0a0c10',
            fg_color = 'silver',
        },
        new_tab = {
            bg_color = '#0a0c10',
            fg_color = 'silver',
        },
    },
}

-- Appearance
config.line_height = 0.9
--config.cell_width = 1.0
config.enable_scroll_bar = false
config.window_decorations = "RESIZE"
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false

config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

-- Misc
config.max_fps = 180
config.default_prog = { 'pwsh.exe', '-nologo' }

-- Tmux keybindings
config.disable_default_key_bindings = true
config.leader = { key=" ", mods="CTRL" }
config.keys = {
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
        mods="LEADER|SHIFT",
        key="\"",
        action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}
    },
    {
        mods = "LEADER|SHIFT",
        key = "%",
        action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" }
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
    },
    {
        mods = "CTRL|SHIFT",
        key = "F",
        action = wezterm.action.Search {CaseInSensitiveString = ""}
    },
    -- We can make separate bindings, but wezterm has keytables,
    -- which are like custom modes
    {
        key = "r",
        mods = "LEADER",
        action = wezterm.action.ActivateKeyTable { name = "resize_pane", one_shot = false }
    },
    -- Add Vi copy mode toggle like tmux
    { 
        key = "[",
        mods = "LEADER",
        action = wezterm.action.ActivateCopyMode
    },
    {
    key = 'Escape',
    mods = 'NONE',
    action = wezterm.action.DisableDefaultAssignment,
    },
}

-- TMUX VI COPY MODE
config.key_tables = {
    resize_pane = {
        { key = "h", action = wezterm.action.AdjustPaneSize { "Left", 1 } },
        { key = "j", action = wezterm.action.AdjustPaneSize { "Down", 1 } },
        { key = "k", action = wezterm.action.AdjustPaneSize { "Up", 1 } },
        { key = "l", action = wezterm.action.AdjustPaneSize { "Right", 1 } },
        { key = "Escape", action = "PopKeyTable" },
        { key = "q", action = "PopKeyTable" },
        -- dc mm nu merge??
        { key = "Backspace", action = wezterm.action.AdjustPaneSize { "Left", 1 } },
    },
    copy_mode = {
      { key = 'Tab', mods = 'NONE', action = wezterm.action.CopyMode 'MoveForwardWord' },
      {
        key = 'Tab',
        mods = 'SHIFT',
        action = wezterm.action.CopyMode 'MoveBackwardWord',
      },
      {
        key = 'Enter',
        mods = 'NONE',
        action = wezterm.action.CopyMode 'MoveToStartOfNextLine',
      },
      {
        key = 'Space',
        mods = 'NONE',
        action = wezterm.action.CopyMode { SetSelectionMode = 'Cell' },
      },
      {
        key = '$',
        mods = 'NONE',
        action = wezterm.action.CopyMode 'MoveToEndOfLineContent',
      },
      {
        key = '$',
        mods = 'SHIFT',
        action = wezterm.action.CopyMode 'MoveToEndOfLineContent',
      },
      { key = ',', mods = 'NONE', action = wezterm.action.CopyMode 'JumpReverse' },
      { key = '0', mods = 'NONE', action = wezterm.action.CopyMode 'MoveToStartOfLine' },
      { key = ';', mods = 'NONE', action = wezterm.action.CopyMode 'JumpAgain' },
      {
        key = 'F',
        mods = 'NONE',
        action = wezterm.action.CopyMode { JumpBackward = { prev_char = false } },
      },
      {
        key = 'F',
        mods = 'SHIFT',
        action = wezterm.action.CopyMode { JumpBackward = { prev_char = false } },
      },
      {
        key = 'G',
        mods = 'NONE',
        action = wezterm.action.CopyMode 'MoveToScrollbackBottom',
      },
      {
        key = 'G',
        mods = 'SHIFT',
        action = wezterm.action.CopyMode 'MoveToScrollbackBottom',
      },
      { key = 'H', mods = 'NONE', action = wezterm.action.CopyMode 'MoveToViewportTop' },
      {
        key = 'H',
        mods = 'SHIFT',
        action = wezterm.action.CopyMode 'MoveToViewportTop',
      },
      {
        key = 'L',
        mods = 'NONE',
        action = wezterm.action.CopyMode 'MoveToViewportBottom',
      },
      {
        key = 'L',
        mods = 'SHIFT',
        action = wezterm.action.CopyMode 'MoveToViewportBottom',
      },
      {
        key = 'M',
        mods = 'NONE',
        action = wezterm.action.CopyMode 'MoveToViewportMiddle',
      },
      {
        key = 'M',
        mods = 'SHIFT',
        action = wezterm.action.CopyMode 'MoveToViewportMiddle',
      },
      {
        key = 'O',
        mods = 'NONE',
        action = wezterm.action.CopyMode 'MoveToSelectionOtherEndHoriz',
      },
      {
        key = 'O',
        mods = 'SHIFT',
        action = wezterm.action.CopyMode 'MoveToSelectionOtherEndHoriz',
      },
      {
        key = 'T',
        mods = 'NONE',
        action = wezterm.action.CopyMode { JumpBackward = { prev_char = true } },
      },
      {
        key = 'T',
        mods = 'SHIFT',
        action = wezterm.action.CopyMode { JumpBackward = { prev_char = true } },
      },
      {
        key = 'V',
        mods = 'NONE',
        action = wezterm.action.CopyMode { SetSelectionMode = 'Line' },
      },
      {
        key = 'V',
        mods = 'SHIFT',
        action = wezterm.action.CopyMode { SetSelectionMode = 'Line' },
      },
      {
        key = '^',
        mods = 'NONE',
        action = wezterm.action.CopyMode 'MoveToStartOfLineContent',
      },
      {
        key = '^',
        mods = 'SHIFT',
        action = wezterm.action.CopyMode 'MoveToStartOfLineContent',
      },
      { key = 'b', mods = 'NONE', action = wezterm.action.CopyMode 'MoveBackwardWord' },
      { key = 'b', mods = 'ALT', action = wezterm.action.CopyMode 'MoveBackwardWord' },
      { key = 'b', mods = 'CTRL', action = wezterm.action.CopyMode 'PageUp' },
      {
        key = 'c',
        mods = 'CTRL',
        action = wezterm.action.CopyMode 'Close' ,
      },
      {
        key = 'd',
        mods = 'CTRL',
        action = wezterm.action.CopyMode { MoveByPage = 0.5 },
      },
      {
        key = 'J',
        mods = 'SHIFT',
        action = wezterm.action.CopyMode { MoveByPage = 0.1 },
      },
      {
        key = 'e',
        mods = 'NONE',
        action = wezterm.action.CopyMode 'MoveForwardWordEnd',
      },
      {
        key = 'f',
        mods = 'NONE',
        action = wezterm.action.CopyMode { JumpForward = { prev_char = false } },
      },
      { key = 'f', mods = 'ALT', action = wezterm.action.CopyMode 'MoveForwardWord' },
      { key = 'f', mods = 'CTRL', action = wezterm.action.CopyMode 'PageDown' },
      {
        key = 'g',
        mods = 'NONE',
        action = wezterm.action.CopyMode 'MoveToScrollbackTop',
      },
      { key = 'h', mods = 'NONE', action = wezterm.action.CopyMode 'MoveLeft' },
      { key = 'j', mods = 'NONE', action = wezterm.action.CopyMode 'MoveDown' },
      { key = 'k', mods = 'NONE', action = wezterm.action.CopyMode 'MoveUp' },
      { key = 'l', mods = 'NONE', action = wezterm.action.CopyMode 'MoveRight' },
      {
        key = 'm',
        mods = 'ALT',
        action = wezterm.action.CopyMode 'MoveToStartOfLineContent',
      },
      {
        key = 'o',
        mods = 'NONE',
        action = wezterm.action.CopyMode 'MoveToSelectionOtherEnd',
      },
      {
        key = 'q',
        mods = 'NONE',
        action = wezterm.action.CopyMode 'Close',
      },
      {
        key = 't',
        mods = 'NONE',
        action = wezterm.action.CopyMode { JumpForward = { prev_char = true } },
      },
      {
        key = 'u',
        mods = 'CTRL',
        action = wezterm.action.CopyMode { MoveByPage = -0.5 },
      },
      {
        key = 'K',
        mods = 'SHIFT',
        action = wezterm.action.CopyMode { MoveByPage = -0.1 },
      },
      {
        key = 'v',
        mods = 'NONE',
        action = wezterm.action.CopyMode { SetSelectionMode = 'Cell' },
      },
      {
        key = 'v',
        mods = 'CTRL',
        action = wezterm.action.CopyMode { SetSelectionMode = 'Block' },
      },
      { key = 'w', mods = 'NONE', action = wezterm.action.CopyMode 'MoveForwardWord' },
      {
        key = 'y',
        mods = 'NONE',
        action = wezterm.action.Multiple {
          { CopyTo = 'ClipboardAndPrimarySelection' },
          { CopyMode = 'Close' },
        },
      },
      { key = 'PageUp', mods = 'NONE', action = wezterm.action.CopyMode 'PageUp' },
      { key = 'PageDown', mods = 'NONE', action = wezterm.action.CopyMode 'PageDown' },
      {
        key = 'End',
        mods = 'NONE',
        action = wezterm.action.CopyMode 'MoveToEndOfLineContent',
      },
      {
        key = 'Home',
        mods = 'NONE',
        action = wezterm.action.CopyMode 'MoveToStartOfLine',
      },
      { key = 'LeftArrow', mods = 'NONE', action = wezterm.action.CopyMode 'MoveLeft' },
      {
        key = 'LeftArrow',
        mods = 'ALT',
        action = wezterm.action.CopyMode 'MoveBackwardWord',
      },
      {
        key = 'RightArrow',
        mods = 'NONE',
        action = wezterm.action.CopyMode 'MoveRight',
      },
      {
        key = 'RightArrow',
        mods = 'ALT',
        action = wezterm.action.CopyMode 'MoveForwardWord',
      },
      { key = 'UpArrow', mods = 'NONE', action = wezterm.action.CopyMode 'MoveUp' },
      { key = 'DownArrow', mods = 'NONE', action = wezterm.action.CopyMode 'MoveDown' },
      { key = '/', mods = 'NONE', action = wezterm.action.Multiple({
                wezterm.action.CopyMode('ClearPattern'),
                wezterm.action.Search({ CaseInSensitiveString = '' }),
          }),
      },
  },
  --search_mode = {
  --      { key = 'Escape', mods = 'NONE', action = wezterm.action.complete_search(true) },
  --      { key = 'Enter', mods = 'NONE', action = wezterm.action.complete_search(false) },
  --},
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
