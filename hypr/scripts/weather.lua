#!/usr/bin/env lua

local function shell_quote(value)
    return "'" .. value:gsub("'", "'\\''") .. "'"
end

local home = assert(os.getenv("HOME"), "HOME is not set")
local cache_path = home .. "/.cache/wttr_cache"
local expiry_seconds = 3600

local cache = io.open(cache_path, "r")
if cache then
    local data = cache:read("*a")
    cache:close()

    local stat = io.popen("stat -c %Y " .. shell_quote(cache_path) .. " 2>/dev/null")
    local modified = stat and tonumber(stat:read("*l")) or nil
    if stat then
        stat:close()
    end
    if modified and os.time() - modified < expiry_seconds and data ~= "" then
        io.write(data)
        return
    end
end

local format = "%l+%c+%C+%t+%h+%w+%p+%P+UV%u+%S-%s+%m"
local request = io.popen("curl -fsS " .. shell_quote("wttr.in/Gdansk?format=" .. format) .. " 2>/dev/null")
local response = request and request:read("*a") or ""
if request then
    request:close()
end

local output = io.open(cache_path, "w")
if output then
    output:write(response)
    output:close()
end
io.write(response)
