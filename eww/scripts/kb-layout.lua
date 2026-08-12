#!/usr/bin/env lua

local function shell_quote(value)
    return "'" .. value:gsub("'", "'\\''") .. "'"
end

local keyboard = arg[1] or "obins-anne-pro-2-c18-(qmk)"

local function emit(layout)
    if layout ~= nil and layout ~= "" then
        print(layout)
        io.stdout:flush()
    end
end

local filter = ".keyboards[] | select(.name == $keyboard) | .active_keymap"
local command = "hyprctl devices -j 2>/dev/null | jq -r --arg keyboard "
    .. shell_quote(keyboard) .. " " .. shell_quote(filter)
local function query_layout()
    local query = io.popen(command)
    if query then
        emit(query:read("*l"))
        query:close()
    end
end

query_layout()

local runtime_directory = assert(os.getenv("XDG_RUNTIME_DIR"), "XDG_RUNTIME_DIR is not set")
local instance = assert(os.getenv("HYPRLAND_INSTANCE_SIGNATURE"), "HYPRLAND_INSTANCE_SIGNATURE is not set")
local socket = runtime_directory .. "/hypr/" .. instance .. "/.socket2.sock"
local events = io.popen("socat -u UNIX-CONNECT:" .. shell_quote(socket) .. " -")
if events == nil then
    os.exit(1)
end

for line in events:lines() do
    if line:match("^activelayout>>") then
        query_layout()
    end
end

events:close()
