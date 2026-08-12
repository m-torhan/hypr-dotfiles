hl.on("hyprland.start", function()
    for _, command in ipairs({
        "eww open-many bar_0 bar_1",
        "hypridle",
        "awww-daemon",
        '"$HOME/.config/hypr/scripts/awww.lua"',
        "hyprpm reload -n",
        "wl-clipboard-history -t",
        "rm -f \"$HOME/.cache/cliphist/db\" && wl-paste --watch cliphist store",
        "systemctl --user start hyprpolkitagent",
        "systemctl --user start hyprsunset",
    }) do
        hl.exec_cmd(command)
    end
end)
