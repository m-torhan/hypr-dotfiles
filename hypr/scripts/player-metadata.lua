#!/usr/bin/env lua

local function shell_quote(value)
    return "'" .. value:gsub("'", "'\\''") .. "'"
end

local function metadata(format)
    local command = "playerctl metadata --format " .. shell_quote(format) .. " 2>/dev/null"
    local process = io.popen(command)
    local value = process and process:read("*l") or nil
    if process then
        process:close()
    end
    return value or ""
end

local function artwork()
    local art_url = metadata("{{mpris:artUrl}}")
    if art_url == "" then
        return ""
    end

    local home = assert(os.getenv("HOME"), "HOME is not set")
    local cache_dir = home .. "/.cache/hyprlock"
    local extension = art_url:match("%.([%w]+)[%?#].*$") or art_url:match("%.([%w]+)$") or "img"
    local art_path = cache_dir .. "/player-art." .. extension
    os.execute("mkdir -p " .. shell_quote(cache_dir))

    local command = "curl -fsSL -o " .. shell_quote(art_path) .. " " .. shell_quote(art_url)
    local ok = os.execute(command .. " >/dev/null 2>&1")
    return (ok == true or ok == 0) and art_path or ""
end

local handlers = {
    title = function()
        return metadata("{{artist}} - {{title}}")
    end,
    album = function()
        return metadata("{{album}}")
    end,
    source = function()
        local player = metadata("{{playerName}}"):lower()
        if player:find("firefox", 1, true) then
            return "Firefox 󰈹"
        elseif player:find("spotify", 1, true) then
            return "Spotify "
        elseif player:find("chrom", 1, true) then
            return "Chrome "
        end
        return ""
    end,
    art = artwork,
}

local handler = handlers[arg[1] or ""]
if handler == nil then
    io.stderr:write("usage: player-metadata.lua <title|album|source|art>\n")
    os.exit(2)
end

print(handler())
