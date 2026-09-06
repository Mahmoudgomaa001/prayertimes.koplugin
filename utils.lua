-- utils.lua
local WidgetContainer   = require("ui/widget/container/widgetcontainer")
local UIManager         = require("ui/uimanager")
local DataStorage       = require("datastorage")
local LuaSettings       = require("luasettings")
local FrameContainer    = require("ui/widget/container/framecontainer")
local InputContainer    = require("ui/widget/container/inputcontainer")
local TextBoxWidget     = require("ui/widget/textboxwidget")
local TextWidget        = require("ui/widget/textwidget")
local ImageWidget       = require("ui/widget/imagewidget")
local VerticalGroup     = require("ui/widget/verticalgroup")
local HorizontalGroup   = require("ui/widget/horizontalgroup")
local VerticalSpan      = require("ui/widget/verticalspan")
local HorizontalSpan    = require("ui/widget/horizontalspan")
local CenterContainer   = require("ui/widget/container/centercontainer")
local LeftContainer     = require("ui/widget/container/leftcontainer")
local RightContainer    = require("ui/widget/container/rightcontainer")
local LineWidget        = require("ui/widget/linewidget")
local Font              = require("ui/font")
local Geom              = require("ui/geometry")
local GestureRange      = require("ui/gesturerange")
local Blitbuffer        = require("ffi/blitbuffer")
local Screen            = require("device").screen
local Menu              = require("ui/widget/menu")
local InfoMessage       = require("ui/widget/infomessage")
local MultiInputDialog  = require("ui/widget/multiinputdialog")
local lfs               = require("libs/libkoreader-lfs")
local Device            = require("device")
local logger            = require("logger")

local defaults = require("defaults")
local DEFAULTS = defaults.DEFAULTS

local _fonts_dir_registered = false

local function interp(template, value)
    if type(template) ~= "string" then return "" end
    value = tostring(value or "")
    return (template:gsub("%%1", function() return value end))
end

local function trimStr(s)
    if type(s) ~= "string" then return "" end
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local plugin_dir = nil
local function getPluginDir()
    if plugin_dir then return plugin_dir end
    local candidates = {
        DataStorage:getDataDir() .. "/plugins/prayertimes.koplugin",
        "plugins/prayertimes.koplugin",
    }
    for _, path in ipairs(candidates) do
        local ok, attr = pcall(lfs.attributes, path)
        if ok and attr and attr.mode == "directory" then
            plugin_dir = path
            return plugin_dir
        end
    end
    plugin_dir = "."
    return plugin_dir
end

local function loadImage(filename, width, height)
    local path = getPluginDir() .. "/images/" .. filename
    local ok_attr, attr = pcall(lfs.attributes, path)
    if not ok_attr or not attr or attr.mode ~= "file" then return nil end
    local ok, widget = pcall(function()
        return ImageWidget:new{ file = path, width = width, height = height }
    end)
    if ok and widget then return widget end
    return nil
end

local StatusUtils = nil
do
    local ok, mod = pcall(function() return require("statusutils") end)
    if ok and mod then
        StatusUtils = mod
    else
        local path = getPluginDir() .. "/statusutils.lua"
        local ok_attr, attr = pcall(lfs.attributes, path)
        if ok_attr and attr and attr.mode == "file" then
            local ok2, mod2 = pcall(function() return dofile(path) end)
            if ok2 and mod2 then StatusUtils = mod2 end
        end
    end
end

local function getBatteryText(format)
    if StatusUtils and StatusUtils.getBatteryText then
        local ok, txt = pcall(StatusUtils.getBatteryText, StatusUtils, format)
        if ok and txt and txt ~= "" then return txt end
    end
    local powerd
    if Device and Device.getPowerDevice then
        local ok2, pd = pcall(Device.getPowerDevice, Device)
        if ok2 then powerd = pd end
    end
    if powerd and powerd.getCapacity then
        local ok3, cap = pcall(powerd.getCapacity, powerd)
        if ok3 and cap then return string.format("%d%%", cap) end
    end
    return nil
end

local function getWifiText()
    if StatusUtils and StatusUtils.getWifiStatusText then
        local ok, txt = pcall(StatusUtils.getWifiStatusText, StatusUtils)
        if ok and txt and txt ~= "" then return txt end
    end
    if Device and Device.isWifiOn then
        local ok, state = pcall(Device.isWifiOn, Device)
        if ok then return state and "on" or "off" end
    end
    return nil
end

local function getMemoryText()
    if StatusUtils and StatusUtils.getMemoryStatusText then
        local ok, txt = pcall(StatusUtils.getMemoryStatusText, StatusUtils)
        if ok and txt and txt ~= "" then return txt end
    end
    local ok, result = pcall(function()
        local statm = io.open("/proc/self/statm", "r")
        if not statm then return nil end
        local _, rss = statm:read("*number", "*number")
        statm:close()
        if rss then
            return string.format("%d MiB", math.floor(rss * 4096 / 1024 / 1024))
        end
        return nil
    end)
    if ok and result then return result end
    return nil
end

local function safeListDir(path)
    local results = {}
    if type(path) ~= "string" or path == "" then return results end
    local ok_attr, attr = pcall(lfs.attributes, path)
    if not ok_attr or not attr or attr.mode ~= "directory" then
        return results
    end
    local ok_iter = pcall(function()
        for entry in lfs.dir(path) do
            if entry and entry ~= "." and entry ~= ".." then
                results[#results + 1] = entry
            end
        end
    end)
    if not ok_iter then return {} end
    return results
end

local function getWritableFontsDir()
    local candidates = {}
    if Device and Device.isKindle and Device:isKindle() then
        table.insert(candidates, "/mnt/us/fonts")
    end
    if Device and Device.isKobo and Device:isKobo() then
        table.insert(candidates, "/mnt/onboard/fonts")
    end
    table.insert(candidates, DataStorage:getDataDir() .. "/fonts")
    for _, path in ipairs(candidates) do
        pcall(lfs.mkdir, path)
        local ok, attr = pcall(lfs.attributes, path)
        if ok and attr and attr.mode == "directory" then
            local test_path = path .. "/.pt_write_test"
            local ok_open, f = pcall(io.open, test_path, "w")
            if ok_open and f then
                f:close()
                pcall(os.remove, test_path)
                return path
            end
        end
    end
    return nil
end

local function installPluginFonts()
    local src_dir = getPluginDir() .. "/" .. DEFAULTS.fonts_folder_name
    local dst_dir = getWritableFontsDir()
    if not dst_dir then return nil end
    for _, entry in ipairs(safeListDir(src_dir)) do
        if entry:match("%.[tT][tT][fF]$") or entry:match("%.[oO][tT][fF]$") then
            local src = src_dir .. "/" .. entry
            local dst = dst_dir .. "/" .. entry
            local ok_a, attr = pcall(lfs.attributes, dst)
            if not ok_a or not attr then
                pcall(function()
                    local fi = io.open(src, "rb")
                    if not fi then return end
                    local data = fi:read("*a")
                    fi:close()
                    local fo = io.open(dst, "wb")
                    if not fo then return end
                    fo:write(data)
                    fo:close()
                end)
            end
        end
    end
    return dst_dir
end

local function ensureFontsDirRegistered()
    if _fonts_dir_registered then return end
    _fonts_dir_registered = true
    local dirs = {}
    local wd = getWritableFontsDir()
    if wd then dirs[#dirs+1] = wd end
    local plugin_fonts = getPluginDir() .. "/" .. DEFAULTS.fonts_folder_name
    dirs[#dirs+1] = plugin_fonts
    pcall(function()
        for _, dir in ipairs(dirs) do
            if type(Font.additional_font_dirs) == "table" then
                local exists = false
                for _, d in ipairs(Font.additional_font_dirs) do
                    if d == dir then exists = true; break end
                end
                if not exists then table.insert(Font.additional_font_dirs, dir) end
            end
            if type(Font.paths) == "table" then
                local exists = false
                for _, d in ipairs(Font.paths) do
                    if d == dir then exists = true; break end
                end
                if not exists then table.insert(Font.paths, dir) end
            end
        end
    end)
end

local _fonts_cache = nil

local function testBuiltinFont(key)
    local ok, face = pcall(function() return Font:getFace(key, 20) end)
    return ok and face ~= nil
end

local function getDeviceFonts()
    if _fonts_cache then return _fonts_cache end

    ensureFontsDirRegistered()
    installPluginFonts()

    local builtin, user = {}, {}
    local builtin_candidates = {
        "infofont", "tfont", "smallinfofont",
        "x_smallinfofont", "cfont", "smalltfont",
    }
    for _, key in ipairs(builtin_candidates) do
        if testBuiltinFont(key) then builtin[#builtin+1] = key end
    end
    if #builtin == 0 then builtin[1] = "infofont" end

    local plugin_fonts_dir = getPluginDir() .. "/" .. DEFAULTS.fonts_folder_name
    local seen = {}
    for _, entry in ipairs(safeListDir(plugin_fonts_dir)) do
        if entry:match("%.[tT][tT][fF]$") or entry:match("%.[oO][tT][fF]$") then
            local filename = entry
            if not seen[filename] then
                seen[filename] = true
                local display = filename:gsub("%.[tT][tT][fF]$", ""):gsub("%.[oO][tT][fF]$", "")
                user[display] = { filename = filename }
            end
        end
    end

    local system_dir = getWritableFontsDir()
    if system_dir then
        for _, entry in ipairs(safeListDir(system_dir)) do
            if entry:match("%.[tT][tT][fF]$") or entry:match("%.[oO][tT][fF]$") then
                local filename = entry
                if not seen[filename] then
                    seen[filename] = true
                    local display = filename:gsub("%.[tT][tT][fF]$", ""):gsub("%.[oO][tT][fF]$", "")
                    user[display] = { filename = filename }
                end
            end
        end
    end

    _fonts_cache = {
        builtin = builtin,
        user = user,
        plugin_dir = plugin_fonts_dir,
        system_dir = system_dir,
    }
    return _fonts_cache
end

local function safeFace(face_key, size)
    size = tonumber(size) or 20
    if size < 8 then size = 8 end
    if size > 120 then size = 120 end

    ensureFontsDirRegistered()

    if type(face_key) == "string" and face_key ~= "" then
        local candidates = { face_key }
        local basename = face_key:match("([^/\\]+)$")
        if basename and basename ~= face_key then
            candidates[#candidates + 1] = basename
        end
        local ref = basename or face_key
        local no_ext = ref:gsub("%.[tToO][tTfF][fF]$", "")
        if no_ext ~= ref then
            candidates[#candidates + 1] = no_ext
        end
        for _, cand in ipairs(candidates) do
            local ok, face = pcall(function() return Font:getFace(cand, size) end)
            if ok and face then return face end
        end
    end

    for _, fallback in ipairs({ DEFAULTS.default_face, "infofont", "cfont", "tfont" }) do
        local ok, face = pcall(function() return Font:getFace(fallback, size) end)
        if ok and face then return face end
    end
    return nil
end

local function makeFixedCell(text, font_size, width, height, face_key)
    if not text or text == "" then
        return HorizontalSpan:new{ width = width }
    end
    return CenterContainer:new{
        dimen = Geom:new{ w = width, h = height },
        TextWidget:new{
            text = tostring(text),
            face = safeFace(face_key, font_size),
            max_width = width,
        },
    }
end

local BD_ok, BD = pcall(function() return require("ui/bidi") end)
local function isSystemMirrored()
    if BD_ok and BD and BD.mirroredUILayout then
        local ok, result = pcall(BD.mirroredUILayout)
        if ok then return result end
    end
    return false
end

local function getActiveLayout(is_ar)
    local LAYOUT_MATRIX = defaults.LAYOUT_MATRIX
    local mirrored = isSystemMirrored()
    if mirrored then return LAYOUT_MATRIX[is_ar and "en" or "ar"], true end
    return LAYOUT_MATRIX[is_ar and "ar" or "en"], false
end

return {
    interp = interp,
    trimStr = trimStr,
    getPluginDir = getPluginDir,
    loadImage = loadImage,
    getBatteryText = getBatteryText,
    getWifiText = getWifiText,
    getMemoryText = getMemoryText,
    safeListDir = safeListDir,
    getWritableFontsDir = getWritableFontsDir,
    installPluginFonts = installPluginFonts,
    ensureFontsDirRegistered = ensureFontsDirRegistered,
    getDeviceFonts = getDeviceFonts,
    safeFace = safeFace,
    isSystemMirrored = isSystemMirrored,
    getActiveLayout = getActiveLayout,
    makeFixedCell = makeFixedCell,

    TextBoxWidget = TextBoxWidget,
    TextWidget = TextWidget,
    ImageWidget = ImageWidget,
    VerticalGroup = VerticalGroup,
    HorizontalGroup = HorizontalGroup,
    VerticalSpan = VerticalSpan,
    HorizontalSpan = HorizontalSpan,
    CenterContainer = CenterContainer,
    LeftContainer = LeftContainer,
    RightContainer = RightContainer,
    LineWidget = LineWidget,
    Font = Font,
    Geom = Geom,
    GestureRange = GestureRange,
    Blitbuffer = Blitbuffer,
    Screen = Screen,
    Menu = Menu,
    InfoMessage = InfoMessage,
    MultiInputDialog = MultiInputDialog,
    UIManager = UIManager,
    DataStorage = DataStorage,
    LuaSettings = LuaSettings,
    FrameContainer = FrameContainer,
    InputContainer = InputContainer,
    lfs = lfs,
    Device = Device,
    logger = logger,
}