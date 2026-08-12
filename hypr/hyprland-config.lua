local colors = require("hyprland-colors")

hl.config({
    cursor = { no_hardware_cursors = true, inactive_timeout = 15 },
    input = {
        kb_layout = "us", kb_variant = "", kb_model = "", kb_options = "", kb_rules = "",
        follow_mouse = 1,
        touchpad = { natural_scroll = true },
        sensitivity = 0,
    },
    general = {
        gaps_in = 0, gaps_out = 0, border_size = 2,
        col = { active_border = colors.sapphire, inactive_border = colors.black },
        layout = "dwindle", allow_tearing = true,
    },
    decoration = {
        blur = {
            enabled = true, size = 4, passes = 1, new_optimizations = true,
            ignore_opacity = true, noise = 0, contrast = 1.0,
            vibrancy = 0.0, brightness = 1.0,
        },
        dim_special = 0.4,
        shadow = { enabled = true, range = 64, render_power = 8, color = colors.black },
    },
    render = { cm_enabled = false },
    animations = { enabled = true },
    dwindle = { preserve_split = true },
    misc = {
        disable_hyprland_logo = true, force_default_wallpaper = 0,
        mouse_move_enables_dpms = true, background_color = colors.background,
    },
})

hl.animation({ leaf = "windows", enabled = true, speed = 1, bezier = "default", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 1, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "layers", enabled = true, speed = 1, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1, bezier = "default", style = "slidefadevert 20%" })
