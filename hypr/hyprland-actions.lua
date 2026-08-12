local actions = {}

local function dispatch(dispatcher)
    hl.dispatch(dispatcher)
end

function actions.arrange_windows(floating)
    local workspace = hl.get_active_workspace()
    local active = hl.get_active_window()
    if workspace == nil or active == nil then
        return
    end

    local windows = {}
    for _, window in ipairs(hl.get_workspace_windows(workspace)) do
        if window.address ~= active.address then
            table.insert(windows, window)
        end
    end
    table.insert(windows, active)

    if not floating then
        for _, window in ipairs(windows) do
            dispatch(hl.dsp.window.float({ action = "unset", window = window }))
        end
        return
    end

    local margin = 32
    local screen_width, screen_height = 3440, 1440
    local window_width, window_height = 1200, 1184

    for index, window in ipairs(windows) do
        local x, y = margin, margin
        if #windows > 1 then
            x = margin + math.floor((index - 1) * (screen_width - window_width - 2 * margin) / (#windows - 1))
            y = margin + math.floor((index - 1) * (screen_height - window_height - 2 * margin) / (#windows - 1))
        end

        dispatch(hl.dsp.window.float({ action = "set", window = window }))
        dispatch(hl.dsp.window.resize({ x = window_width, y = window_height, window = window }))
        dispatch(hl.dsp.window.move({ x = x, y = y, window = window }))
        dispatch(hl.dsp.focus({ window = window }))
        dispatch(hl.dsp.window.bring_to_top())
        dispatch(hl.dsp.cursor.move({ x = x + window_width / 2, y = y + window_height / 2 }))
    end
end

local gamemode = false

function actions.toggle_gamemode()
    gamemode = not gamemode
    hl.config({
        animations = { enabled = not gamemode },
        decoration = {
            rounding = 0,
            shadow = { enabled = not gamemode },
            blur = { enabled = not gamemode },
        },
        general = {
            gaps_in = 0,
            gaps_out = 0,
            border_size = gamemode and 1 or 2,
        },
    })
end

local function shell_quote(value)
    return "'" .. value:gsub("'", "'\\''") .. "'"
end

function actions.restore_scratchpad(workspace_name, menu)
    local current_workspace = hl.get_active_workspace()
    local windows = hl.get_workspace_windows("special:" .. workspace_name)
    if current_workspace == nil or #windows == 0 then
        hl.notification.create({ text = "No clients on " .. workspace_name, timeout = 3000, icon = "info" })
        return
    end

    table.sort(windows, function(left, right)
        return left.focus_history_id < right.focus_history_id
    end)

    local lines = {}
    for _, window in ipairs(windows) do
        table.insert(lines, string.format("%s %s %s", window.class, window.title, window.address))
    end

    local command = "printf '%s\\n' "
    for _, line in ipairs(lines) do
        command = command .. shell_quote(line) .. " "
    end
    local process = io.popen(command .. "| " .. menu)
    if process == nil then
        return
    end
    local selected = process:read("*l")
    process:close()
    if selected == nil then
        return
    end

    local address = selected:match("(0x%x+)%s*$")
    if address == nil then
        return
    end
    local window = hl.get_window("address:" .. address)
    if window == nil then
        return
    end

    dispatch(hl.dsp.window.move({ workspace = current_workspace, follow = true, window = window }))
    if window.floating then
        dispatch(hl.dsp.window.bring_to_top())
    end
end

return actions
