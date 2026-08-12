#!/usr/bin/env lua

local direction = arg[1]
local screen = tonumber(arg[2])
local delta = direction == "down" and 1 or direction == "up" and -1 or nil
if delta == nil or screen == nil or screen < 0 or screen % 1 ~= 0 then
    io.stderr:write("usage: change-active-workspace.lua <up|down> <screen>\n")
    os.exit(2)
end

local code = string.format([[
local monitors = hl.get_monitors()
table.sort(monitors, function(left, right) return left.id < right.id end)
local monitor = monitors[%d]
if monitor == nil or monitor.active_workspace == nil then return end

local current = monitor.active_workspace.id
if current < 1 or current > 10 then return end

local available = {}
for id = 1, 10 do
    local workspace = hl.get_workspace(id)
    if workspace == nil or workspace.monitor == nil or workspace.monitor.id == monitor.id then
        table.insert(available, id)
    end
end

local index
for i, id in ipairs(available) do
    if id == current then
        index = i
        break
    end
end
if index == nil then return end

index = math.max(1, math.min(#available, index + (%d)))
local target = available[index]
if target ~= current then
    hl.dispatch(hl.dsp.focus({ workspace = target }))
end
]],
    screen + 1,
    delta
)
local status = os.execute("hyprctl eval '" .. code .. "'")
if status ~= true and status ~= 0 then
    os.exit(1)
end
