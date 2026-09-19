hl.monitor({
    output = "eDP-1",
    mode = "1920x1200@60",
    position = "0x0",
    scale = "1.2",
})

-- Quick plug monitors with their negotiated settings
--monitor = , preferred, auto, 1
hl.monitor({
    output = "",
    mode = "1920x1080@180",
    position = "auto",
    scale = "1",
})

local terminal = "alacritty"
local fileManager = "pcmanfm"
local menu = "vicinae toggle"
local browser = "chromium --enable-features=UseOzonePlatform --ozone-platform=wayland --incognito"
local notes = "logseq-desktop-electron --enable-features=UseOzonePlatform --ozone-platform=wayland"
local keepass = "keepassxc"
local discord = "vesktop --enable-features=UseOzonePlatform --ozone-platform=wayland"
local screenshot = "flameshot gui"
local vm = "virt-manager"

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar & hyprpaper & hypridle")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("vicinae server")
end)


-- See https://wiki.hypr.land/Configuring/Environment-variables/
hl.env("GDK_SCALE", "2")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("FONT_NAME", "JetBrainsMono Nerd Font 14")
hl.env("DOCUMENT_FONT_NAME", "JetBrainsMono  Nerd Font 14")
hl.env("MONOSPACE_FONT_NAME", "JetBrainsMono Nerd Font 14")
hl.env("FONT_ANTIALIASING", "rgba")
hl.env("FONT_HINTING", "full")

-- Window rules
hl.window_rule({
    name = "IDA float fix",
    match = {
        float = true,
        class = "com.hex-rays.ida",
    },
})
hl.window_rule({
    name = "IDA float fix",
    match = {
        float = true,
        title = ".*About.*",
    },
})
hl.window_rule({
    name = "IDA float fix",
    match = {
        title = "title:.*IDA - .*",
    },
    suppress_event = "maximize",
})
hl.window_rule({
    name = "IDA float fix",
    match = {
        title = "IDA: Quick start",
    },
    suppress_event = "maximize",
})
hl.layer_rule({
    name = "vicinae-blur",
    match = {
        namespace = "vicinae",
    },
    blur = true,
})
hl.layer_rule({
    name = "vicinae-no-animation",
    match = {
        namespace = "vicinae",
    },
    no_anim = true,
})
hl.window_rule({
    name = "suppress-maximize-events",
    match = {
        class = ".*",
    },
    -- Ignore maximize requests from all apps. You'll probably like this.
    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    -- Fix some dragging issues with XWayland
    no_focus = true,
})


-- Gestures config
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})
hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})

local mainMod = "ALT"

-- NOTE: Program keybinds go here
hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exit())
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd(notes))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.exec_cmd(keepass))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd(discord))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(screenshot))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd(vm))

-- DWM-like window navigation
hl.bind(mainMod .. " + m", hl.dsp.group.toggle())
hl.bind(mainMod .. " + j", hl.dsp.group.next())
hl.bind(mainMod .. " + k", hl.dsp.group.prev())
hl.bind(mainMod .. " + j", hl.dsp.window.cycle_next({ next = true }))
hl.bind(mainMod .. " + k", hl.dsp.window.cycle_next({ next = true } --[[ cyclenext: unrecognized arg(s) "-1" ]]))
hl.bind(mainMod .. " + l", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + h", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + RETURN", hl.dsp.layout("swapwithmaster master"))
hl.bind("SUPER + d", hl.dsp.layout("removemaster"))
-- MOD + TAB to go to previous workspace
hl.bind(mainMod .. " + TAB", hl.dsp.focus({ workspace = "previous" }))

-- Extra monitors config
hl.bind("SUPER + 1", hl.dsp.focus({ monitor = 0 }))
hl.bind("SUPER + 2", hl.dsp.focus({ monitor = 1 }))
hl.bind("SUPER + 3", hl.dsp.focus({ monitor = 2 }))
hl.bind("SUPER + 4", hl.dsp.focus({ monitor = 3 }))
hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ monitor = "0" }))
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ monitor = "1" }))
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ monitor = "2" }))
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ monitor = "3" }))

-- Core workspace focus keybinds
hl.bind(mainMod .. " + 1", hl.dsp.focus({workspace = 1}))
hl.bind(mainMod .. " + 2", hl.dsp.focus({workspace = 2}))
hl.bind(mainMod .. " + 3", hl.dsp.focus({workspace = 3}))
hl.bind(mainMod .. " + 4", hl.dsp.focus({workspace = 4}))
hl.bind(mainMod .. " + 5", hl.dsp.focus({workspace = 5}))
hl.bind(mainMod .. " + 6", hl.dsp.focus({workspace = 6}))
hl.bind(mainMod .. " + 7", hl.dsp.focus({workspace = 7}))
hl.bind(mainMod .. " + 8", hl.dsp.focus({workspace = 8}))
hl.bind(mainMod .. " + 9", hl.dsp.focus({workspace = 9}))
hl.bind(mainMod .. " + 0", hl.dsp.focus({workspace = 10}))

-- Core workspace move keybinds
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({workspace = 1}))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({workspace = 2}))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({workspace = 3}))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({workspace = 4}))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({workspace = 5}))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({workspace = 6}))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({workspace = 7}))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({workspace = 8}))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({workspace = 9}))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({workspace = 10}))

-- Workspace cycling
hl.bind(mainMod .. " + a", hl.dsp.focus( {workspace = "e-1"}))
hl.bind(mainMod .. " + s", hl.dsp.focus( {workspace = "e+1"}))

-- Mouse binds
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

-- Fn button functionality
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })


hl.config({
    xwayland = {
        force_zero_scaling = false,
    }, 
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 2,
        col = {
            active_border = { colors = { "rgb(59278f)", "rgb(59278f)" } },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "master",
    },
    decoration = {
        rounding = 2,
        rounding_power = 2,
        -- Change transparency of focused and unfocused windows
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = false,
    },
    -- See workspace rules on wiki
    dwindle = {
        --pseudotile = true, -- Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true, -- You probably want this
    },
    -- See https://wiki.hypr.land/Configuring/Master-Layout/ for more
    master = {
        new_status = "master",
    },
    misc = {
        force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
    },

    -- https://wiki.hypr.land/Configuring/Variables/#input
    -- Keyboard delay, inverted scroll, etc
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
        touchpad = {
            natural_scroll = true,
        },
        repeat_delay = 200,
        repeat_rate = 50,
    },
    -- Monocle mode 
    group = {
        insert_after_current = true,
        focus_removed_window = true,
        groupbar = {
            enabled = true,
            render_titles = false,
            height = 4,
        },
    },
    -- Fix cursor lag on NVIDIA cards
    cursor = {
        no_hardware_cursors = true,
    },
})

