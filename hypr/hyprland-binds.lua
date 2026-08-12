return function(defaults, actions, eww)
    local mod = "SUPER"
    local function bind(keys, dispatcher, options) hl.bind(keys, dispatcher, options) end
    local function exec(command, rule) return hl.dsp.exec_cmd(command, rule) end
    local function dispatch_all(...)
        local dispatchers = { ... }
        return function()
            for _, dispatcher in ipairs(dispatchers) do hl.dispatch(dispatcher) end
        end
    end

    bind("XF86AudioRaiseVolume", exec("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
    bind("XF86AudioLowerVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
    bind("XF86Search", exec("launchpad"), { locked = true, repeating = true })
    bind("XF86AudioMute", exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
    bind("XF86AudioPlay", exec("playerctl play-pause"), { locked = true })
    bind("XF86AudioNext", exec("playerctl next"), { locked = true })
    bind("XF86AudioPrev", exec("playerctl previous"), { locked = true })
    bind("XF86MonBrightnessDown", exec("brightnessctl set 10%-"))
    bind("XF86MonBrightnessUp", exec("brightnessctl set 10%+"))

    bind(mod .. " + V", exec([[cliphist list | tr -d '\000' | ]] .. defaults.menu_dmenu .. ' --prompt-text "Clipboard history: " | cliphist decode | wl-copy'))
    bind(mod .. " + SHIFT + V", exec([[cliphist list | tr -d '\000' | ]] .. defaults.menu_dmenu .. ' --prompt-text "Delete from clipboard history: " | cliphist delete'))
    bind("Print", exec("hyprshot --freeze -z -m output"))
    bind(mod .. " + Print", exec("hyprshot --freeze -z -m window"))
    bind("SHIFT + Print", exec("hyprshot --freeze -z -m region"))

    bind(mod .. " + C", hl.dsp.window.close())
    bind(mod .. " + Q", exec(defaults.terminal))
    bind(mod .. " + SHIFT + Q", exec(defaults.terminal, { float = true }))
    bind(mod .. " + W", exec(defaults.browser))
    bind(mod .. " + E", exec(defaults.file_manager))
    bind(mod .. " + SHIFT + E", exec(defaults.file_manager, { float = true }))
    bind(mod .. " + R", exec(defaults.menu_drun .. ' --prompt-text "Apps: "'))
    bind(mod .. " + F", hl.dsp.window.float({ action = "toggle" }))
    bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen({ action = "toggle" }))
    bind(mod .. " + CTRL + P", hl.dsp.window.pseudo({ action = "toggle" }))
    bind(mod .. " + SEMICOLON", exec("rofimoji --selector " .. defaults.menu))
    bind(mod .. " + CTRL + L", exec(defaults.lock))
    bind(mod .. " + CTRL + K", function() eww.switch_keyboard(defaults.keyboard) end)

    for key, direction in pairs({ h = "left", l = "right", k = "up", j = "down" }) do
        bind(mod .. " + " .. key, dispatch_all(hl.dsp.focus({ direction = direction }), hl.dsp.window.bring_to_top()))
    end
    bind(mod .. " + n", dispatch_all(hl.dsp.window.cycle_next(), hl.dsp.window.bring_to_top()))
    bind(mod .. " + m", dispatch_all(hl.dsp.window.cycle_next({ next = false }), hl.dsp.window.bring_to_top()))

    for workspace = 1, 10 do
        local key = workspace % 10
        bind(mod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
        bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace, follow = false }))
    end

    local shifted_moves = {
        u = { direction = "left", x = 20, y = 0 }, p = { direction = "right", x = -20, y = 0 },
        o = { direction = "up", x = 0, y = 20 }, i = { direction = "down", x = 0, y = -20 },
    }
    for key, move in pairs(shifted_moves) do
        bind(mod .. " + SHIFT + " .. key, dispatch_all(
            hl.dsp.window.move({ direction = move.direction }),
            hl.dsp.window.move({ x = move.x, y = move.y, relative = true })
        ))
    end
    for key, move in pairs({ u = {-10, 0}, p = {10, 0}, o = {0, -10}, i = {0, 10} }) do
        bind(mod .. " + " .. key, hl.dsp.window.move({ x = move[1], y = move[2], relative = true }), { repeating = true })
    end

    bind(mod .. " + y", hl.dsp.window.center())
    bind(mod .. " + SHIFT + y", hl.dsp.window.resize({ x = 1200, y = 1184 }))
    bind(mod .. " + CTRL + y", dispatch_all(hl.dsp.window.resize({ x = 1200, y = 1184 }), hl.dsp.window.center()))
    bind(mod .. " + z", function() actions.arrange_windows(false) end)
    bind(mod .. " + CTRL + z", function() actions.arrange_windows(true) end)

    for _, name in ipairs({ "S", "A", "D" }) do
        local workspace = "scratchpad_" .. name
        bind(mod .. " + " .. name, hl.dsp.workspace.toggle_special(workspace))
        bind(mod .. " + SHIFT + " .. name, hl.dsp.window.move({ workspace = "special:" .. workspace, follow = false }))
        bind(mod .. " + CTRL + " .. name, function()
            actions.restore_scratchpad(workspace, defaults.menu .. ' --prompt-text "Scratchpad ' .. name .. '"')
        end)
    end

    bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
    bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
    bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
    bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
    bind(mod .. " + CTRL + G", actions.toggle_gamemode)
end
