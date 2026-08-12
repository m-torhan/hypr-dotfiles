local eww = {}

local function shell_quote(value)
    return "'" .. value:gsub("'", "'\\''") .. "'"
end

local function update(values)
    local command = "eww update"
    for name, value in pairs(values) do
        command = command .. " " .. name .. "=" .. shell_quote(value)
    end
    hl.exec_cmd(command)
end

local function monitors_by_id()
    local monitors = hl.get_monitors()
    table.sort(monitors, function(left, right)
        return left.id < right.id
    end)
    return monitors
end

local function monitor_state(monitors)
    local active = {}
    for _, monitor in ipairs(monitors) do
        table.insert(active, monitor.active_workspace and monitor.active_workspace.id or 0)
    end
    return "[" .. table.concat(active, ",") .. "]"
end

local function workspace_state(monitors)
    local screen_by_monitor = {}
    for screen, monitor in ipairs(monitors) do
        screen_by_monitor[monitor.id] = screen - 1
    end

    local entries = {}
    for id = 1, 10 do
        local workspace = hl.get_workspace(id)
        local windows = workspace and workspace.windows or 0
        local monitor_id = workspace and workspace.monitor and workspace.monitor.id
        local display = screen_by_monitor[monitor_id] or 0
        table.insert(entries, string.format('{"id":%d,"windows":%d,"display":%d}', id, windows, display))
    end
    return "[" .. table.concat(entries, ",") .. "]"
end

function eww.update_monitors()
    local monitors = monitors_by_id()
    update({
        num_monitors = tostring(#monitors),
        current_workspace = monitor_state(monitors),
    })
end

function eww.update_workspaces()
    update({ workspaces = workspace_state(monitors_by_id()) })
end

function eww.switch_keyboard(keyboard)
    hl.exec_cmd("hyprctl switchxkblayout " .. shell_quote(keyboard) .. " next")
end

function eww.update_all()
    local monitors = monitors_by_id()
    update({
        num_monitors = tostring(#monitors),
        current_workspace = monitor_state(monitors),
        workspaces = workspace_state(monitors),
    })
end

for _, event in ipairs({
    "monitor.added",
    "monitor.removed",
    "monitor.focused",
    "monitor.layout_changed",
    "workspace.active",
    "workspace.created",
    "workspace.removed",
    "workspace.move_to_monitor",
    "window.open",
    "window.destroy",
    "window.move_to_workspace",
}) do
    hl.on(event, eww.update_all)
end

local update_timer
local function schedule_update()
    update_timer = hl.timer(eww.update_all, { timeout = 1000, type = "oneshot" })
end

hl.on("hyprland.start", schedule_update)

return eww
