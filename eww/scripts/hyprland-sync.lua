#!/usr/bin/env lua

local command = [[hyprctl eval 'require("hyprland-eww").update_all()' >/dev/null 2>&1]]

while true do
    local success, _, code = os.execute(command)
    if success == true or success == 0 or code == 0 then
        break
    end
    os.execute("sleep 0.2")
end

print("synced")
io.stdout:flush()

while true do
    os.execute("sleep 3600")
end
