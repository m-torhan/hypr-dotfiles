#!/usr/bin/env lua

local function shell_quote(value)
    return "'" .. value:gsub("'", "'\\''") .. "'"
end

local home = assert(os.getenv("HOME"), "HOME is not set")
local wallpapers_directory = home .. "/.config/hypr/wallpapers"
local change_interval_seconds = 60 * 60

local function load_wallpapers()
    local command = "find -L " .. shell_quote(wallpapers_directory) .. " -mindepth 1 -maxdepth 1 -type f -print0 2>/dev/null"
    local process = assert(io.popen(command))
    local output = process:read("*a")
    process:close()

    local wallpapers = {}
    for path in output:gmatch("([^%z]+)%z") do
        table.insert(wallpapers, path)
    end
    return wallpapers
end

local function shuffle(values)
    for index = #values, 2, -1 do
        local other = math.random(index)
        values[index], values[other] = values[other], values[index]
    end
end

local function command_succeeded(command)
    local success, _, code = os.execute(command .. " >/dev/null 2>&1")
    return success == true or success == 0 or code == 0
end

local function wait_for_daemon()
    while not command_succeeded("awww query") do
        os.execute("sleep 0.2")
    end
end

math.randomseed(os.time())

while true do
    local wallpapers = load_wallpapers()
    if #wallpapers == 0 then
        io.stderr:write("awww.lua: no wallpapers found in " .. wallpapers_directory .. "\n")
        os.exit(1)
    end

    shuffle(wallpapers)
    for _, wallpaper in ipairs(wallpapers) do
        wait_for_daemon()
        if command_succeeded("awww img " .. shell_quote(wallpaper)) then
            os.execute("sleep " .. change_interval_seconds)
        else
            io.stderr:write("awww.lua: failed to load " .. wallpaper .. "\n")
        end
    end
end
