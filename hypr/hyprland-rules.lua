local colors = require("hyprland-colors")
local vars = require("hyprland-variables")

hl.layer_rule({ name = "blur-launcher", match = { namespace = "launcher" }, blur = true, dim_around = true })
hl.layer_rule({ name = "noanim-hyprpicker", match = { namespace = "hyprpicker" }, no_anim = true })
hl.layer_rule({ name = "noanim-selection", match = { namespace = "selection" }, no_anim = true })

hl.window_rule({ name = "border-floating", match = { float = true }, rounding = 8 })
hl.window_rule({
    name = "border-no-floating", match = { float = false },
    border_color = colors.sapphire .. " " .. colors.background, no_shadow = true,
})
hl.window_rule({ name = "render-unfocused-kitty", match = { title = "^(kitty)(.*)$" }, render_unfocused = true })

for _, workspace in ipairs({ "scratchpad_S", "scratchpad_A", "scratchpad_D" }) do
    hl.window_rule({
        name = "special-workspace-" .. workspace .. "-border-color",
        match = { workspace = "special:" .. workspace },
        border_color = colors.yellow .. " " .. colors.black,
    })
end

hl.window_rule({
    name = "obsidian", match = { class = "md.Obsidian" }, float = true,
    size = { vars.default_floating_x_wide_w, vars.default_floating_h }, center = true,
})
hl.window_rule({
    name = "spotify", match = { class = "(spotify|Spotify|Plexamp)" }, float = true,
    size = { vars.default_floating_w, vars.default_floating_h },
    move = { vars.default_floating_r_x, vars.default_floating_y },
})
hl.window_rule({
    name = "float-windows",
    match = { class = "(signal|Signal|org.telegram.desktop|org.pulseaudio.pavucontrol|xdg-desktop-portal-gtk)" },
    float = true,
})
hl.window_rule({
    name = "center-windows",
    match = { class = "(kitty|thunar|Thunar|signal|org.telegram.desktop|org.pulseaudio.pavucontrol|xdg-desktop-portal-gtk)" },
    size = { vars.default_floating_w, vars.default_floating_h }, center = true,
})
