-- prayertimes_statusutils.lua
local Device = require("device")
local _ = require("gettext")
local T = require("ffi/util").template
local NetworkMgr = require("ui/network/manager")

local StatusUtils = {}

function StatusUtils.getBatteryText(format)
    if Device:hasBattery() then
        local powerd = Device:getPowerDevice()
        local battery_level = powerd:getCapacity() or 0
        local prefix = ""

        if type(powerd.getBatterySymbol) == "function" then
            prefix = powerd:getBatterySymbol(
                powerd:isCharged(),
                powerd:isCharging(),
                battery_level
            )
        end

        if format == "icon" then
            return prefix
        elseif format == "percent" then
            return T(_("%1 %"), battery_level)
        else
            if prefix == "" then
                return T(_("%1 %"), battery_level)
            else
                return T(_("%1 %2 %"), prefix, battery_level)
            end
        end
    end
    return ""
end

function StatusUtils.getWifiStatusText()
    if NetworkMgr:isWifiOn() then
        return _("")
    else
        return _("")
    end
end

function StatusUtils.getMemoryStatusText()
    local statm = io.open("/proc/self/statm", "r")
    if statm then
        local dummy, rss = statm:read("*number", "*number")
        statm:close()
        if rss == nil then return nil end
        rss = math.floor(rss * (4096 / 1024 / 1024))
        return T(_(" %1 MiB"), rss)
    end
end

function StatusUtils.getStatusText()
    local wifi_string    = StatusUtils.getWifiStatusText()
    local memory_string  = StatusUtils.getMemoryStatusText()

    local parts = {}
    for _, s in ipairs({ wifi_string, memory_string }) do
        if s ~= nil and s ~= "" then
            parts[#parts + 1] = s
        end
    end
    return table.concat(parts, " | ")
end

return StatusUtils
