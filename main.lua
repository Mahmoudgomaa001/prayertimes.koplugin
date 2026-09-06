
-- main.lua
local WidgetContainer = require("ui/widget/container/widgetcontainer")
local UIManager = require("ui/uimanager")
local DataStorage = require("datastorage")
local LuaSettings = require("luasettings")
local lfs = require("libs/libkoreader-lfs")
local Device = require("device")
local logger = require("logger")

local defaults = require("defaults")
local translations = require("translations")
local utils = require("utils")
local calculation = require("calculation")
local fasting = require("fasting")
local PrayerTimesWidget = require("widget")

local DEFAULTS = defaults.DEFAULTS
local translations_table = translations.translations
local calculateTimes = calculation.calculateTimes
local Hijri = calculation.Hijri
local getFastingReminders = fasting.getFastingReminders

local interp = utils.interp
local trimStr = utils.trimStr
local getPluginDir = utils.getPluginDir
local Menu = utils.Menu
local InfoMessage = utils.InfoMessage
local MultiInputDialog = utils.MultiInputDialog

local locations = {}
local country_names_ar = {}

local function loadLocations()
    local file = getPluginDir() .. "/locations.lua"
    local ok_attr, attr = pcall(lfs.attributes, file)
    if ok_attr and attr and attr.mode == "file" then
        local ok, result = pcall(function() return dofile(file) end)
        if ok and type(result) == "table" and result.locations then
            locations = result.locations
            country_names_ar = result.country_names_ar or {}
            return
        end
    end
    locations = {
        ["Egypt"] = {
            { name = "Alexandria", name_ar = "الإسكندرية", lat = 31.198,  lng = 29.9192, tz = 2 },
            { name = "Cairo",      name_ar = "القاهرة",    lat = 30.0444, lng = 31.2357, tz = 2 },
        },
        ["Saudi Arabia"] = {
            { name = "Mecca",  name_ar = "مكة المكرمة",     lat = 21.4225, lng = 39.8262, tz = 3 },
            { name = "Medina", name_ar = "المدينة المنورة", lat = 24.5247, lng = 39.5692, tz = 3 },
        },
    }
    country_names_ar = {
        ["Egypt"] = "مصر",
        ["Saudi Arabia"] = "المملكة العربية السعودية",
    }
end
loadLocations()

local function saveLocations()
    local ok, result = pcall(function()
        local file_path = getPluginDir() .. "/locations.lua"
        local f = io.open(file_path, "w")
        if not f then return false end
        f:write("local locations = {\n")
        for country, cities in pairs(locations) do
            f:write(string.format("    [%q] = {\n", country))
            for _, c in ipairs(cities) do
                f:write(string.format(
                    "        { name = %q, name_ar = %q, lat = %s, lng = %s, tz = %s },\n",
                    c.name, c.name_ar or "", tostring(c.lat), tostring(c.lng), tostring(c.tz)))
            end
            f:write("    },\n")
        end
        f:write("}\n\nlocal country_names_ar = {\n")
        for country, ar in pairs(country_names_ar) do
            f:write(string.format("    [%q] = %q,\n", country, ar))
        end
        f:write("}\n\nreturn { locations = locations, country_names_ar = country_names_ar }\n")
        f:close()
        return true
    end)
    return ok and result or false
end

local function getSuggestedMethod(country)
    if country and DEFAULTS.region_methods[country] then
        return DEFAULTS.region_methods[country]
    end
    return nil
end

local function getEffectiveUtcOffset(location)
    local base = tonumber(location.timezone) or 0
    local dst  = tonumber(location.dst) or 0
    return base + dst
end

local PrayerTimes = WidgetContainer:extend{
    name = "prayertimes",
    config_file = "prayertimes_config.lua",
    is_doc_only = false,
}

function PrayerTimes:init()
    local ok, err = pcall(function()
        utils.ensureFontsDirRegistered()
        pcall(utils.installPluginFonts)
        self:initLuaSettings()
        self:ensureSettingsComplete()
        if self.ui and self.ui.menu then
            self.ui.menu:registerToMainMenu(self)
        end
    end)
    if not ok then
        logger.warn("PrayerTimes init failed:", err)
    end
end

function PrayerTimes:onResume()
    local d = self.settings and self.settings.display
    if d and d.auto_show_resume then
        UIManager:scheduleIn(0.5, function() self:showPrayerTimes() end)
    end
end

function PrayerTimes:initLuaSettings()
    self.local_storage = LuaSettings:open(
        ("%s/%s"):format(DataStorage:getSettingsDir(), self.config_file))

    if next(self.local_storage.data) == nil then
        local S = DEFAULTS.settings
        self.local_storage:reset({
            location = {
                name = "Alexandria", name_ar = "الإسكندرية",
                latitude = 31.198, longitude = 29.9192,
                timezone = 2, dst = S.dst,
            },
            calculation = {
                method = S.method,
                asr_madhhab = S.asr_madhhab,
            },
            display = {
                language              = S.language,
                show_hijri            = S.show_hijri,
                time_format           = S.time_format,
                clock_mode            = S.clock_mode,
                show_battery          = S.show_battery,
                show_wifi             = S.show_wifi,
                show_memory           = S.show_memory,
                battery_format        = S.battery_format,
                auto_show_resume      = S.auto_show_resume,
                font_size_offset      = S.font_size_offset,
                font_face             = S.font_face,
                custom_font_path      = S.custom_font_path,
                hijri_adjustment      = S.hijri_adjustment,
                show_fasting_days     = S.show_fasting_days,
                fasting_reminder_days = S.fasting_reminder_days,
                fasting_days = {
                    mondays = true, thursdays = true, white_days = true,
                    ashura = true, arafah = true, six_shawwal = true,
                },
            },
            alerts = {
                flash = false, frontlight = false,
                message = true, frontlight_duration = 5,
            },
            widget_brightness = S.widget_brightness,
        })
        self.local_storage:flush()
    end
    self.settings = self.local_storage.data
end

function PrayerTimes:ensureSettingsComplete()
    local S = DEFAULTS.settings
    self.settings = self.settings or {}

    local loc = self.settings.location or {}
    loc.name       = loc.name       or "Alexandria"
    loc.name_ar    = loc.name_ar    or "الإسكندرية"
    loc.latitude   = tonumber(loc.latitude)   or 31.198
    loc.longitude  = tonumber(loc.longitude)  or 29.9192
    loc.timezone   = tonumber(loc.timezone)   or 2
    if loc.dst_offset ~= nil then
        loc.dst = tonumber(loc.dst_offset) or 0
        loc.dst_offset = nil
    end
    loc.dst = tonumber(loc.dst) or 0
    self.settings.location = loc

    local calc = self.settings.calculation or {}
    calc.method      = calc.method      or S.method
    calc.asr_madhhab = calc.asr_madhhab or S.asr_madhhab
    self.settings.calculation = calc

    local d = self.settings.display or {}
    d.language = d.language or S.language
    if d.show_hijri == nil then d.show_hijri = S.show_hijri end
    d.time_format = tonumber(d.time_format) or S.time_format
    d.clock_mode  = d.clock_mode or S.clock_mode
    if d.show_battery == nil then d.show_battery = S.show_battery end
    if d.show_wifi    == nil then d.show_wifi    = S.show_wifi end
    if d.show_memory  == nil then d.show_memory  = S.show_memory end
    d.battery_format = d.battery_format or S.battery_format
    if d.auto_show_resume == nil then d.auto_show_resume = S.auto_show_resume end
    if d.font_size_offset == nil then d.font_size_offset = S.font_size_offset end
    d.font_face        = d.font_face        or S.font_face
    d.custom_font_path = d.custom_font_path or S.custom_font_path
    d.hijri_adjustment = tonumber(d.hijri_adjustment) or S.hijri_adjustment
    if d.show_fasting_days == nil then d.show_fasting_days = S.show_fasting_days end
    d.fasting_reminder_days = tonumber(d.fasting_reminder_days) or S.fasting_reminder_days

    d.fasting_days = d.fasting_days or {}
    local fd = d.fasting_days
    if fd.mondays     == nil then fd.mondays     = true end
    if fd.thursdays   == nil then fd.thursdays   = true end
    if fd.white_days  == nil then fd.white_days  = true end
    if fd.ashura      == nil then fd.ashura      = true end
    if fd.arafah      == nil then fd.arafah      = true end
    if fd.six_shawwal == nil then fd.six_shawwal = true end

    if type(d.custom_font_path) == "string" and d.custom_font_path ~= "" then
        local base = d.custom_font_path:match("([^/\\]+)$")
        if base and base ~= d.custom_font_path then
            d.custom_font_path = base
        end
    end

    self.settings.display = d

    local a = self.settings.alerts or {}
    if a.flash      == nil then a.flash      = false end
    if a.frontlight == nil then a.frontlight = false end
    if a.message    == nil then a.message    = true end
    a.frontlight_duration = tonumber(a.frontlight_duration) or 5
    self.settings.alerts = a

    if self.settings.widget_brightness == nil then
        self.settings.widget_brightness = S.widget_brightness
    end

    pcall(function() self.local_storage:flush() end)
end

function PrayerTimes:t(key)
    local lang = (self.settings and self.settings.display
                  and self.settings.display.language) or "en"
    local tbl = translations_table[lang] or translations_table.en
    return tbl[key] or translations_table.en[key] or key
end

function PrayerTimes:flushSettings()
    pcall(function() self.local_storage:flush() end)
end

function PrayerTimes:addToMainMenu(menu_items)
    menu_items.prayer_times = {
        text = self:t("prayer_times"),
        sorting_hint = "tools",
        sub_item_table = {
            {
                text = self:t("launch"),
                callback = function() self:showPrayerTimes() end,
            },
            {
                text = self:t("set_location"),
                sub_item_table = self:getLocationSubmenu(),
            },
            {
                text = self:t("calculation_settings"),
                sub_item_table = self:getCalculationSubmenu(),
            },
            {
                text = self:t("hijri_and_fasting"),
                sub_item_table = self:getHijriAndFastingSubmenu(),
            },
            {
                text = self:t("display_and_appearance"),
                sub_item_table = self:getDisplaySubmenu(),
            },
            {
                text = self:t("alerts"),
                sub_item_table = self:getAlertsSubmenu(),
            },
            {
                text = self:t("about"),
                callback = function()
                    UIManager:show(InfoMessage:new{
                        text = self:t("about_text"), timeout = 15 })
                end,
            },
        },
    }
end

function PrayerTimes:getLocationSubmenu()
    return {
        {
            text = self:t("choose_from_list"),
            callback = function() self:showLocationList() end,
        },
        {
            text = self:t("add_location"),
            callback = function() self:showAddLocationInput() end,
        },
        {
            text = self:t("dst_adjustment"),
            sub_item_table = {
                {
                    text = self:t("no_dst"),
                    checked_func = function() return self.settings.location.dst == 0 end,
                    callback = function()
                        self.settings.location.dst = 0; self:flushSettings() end,
                },
                {
                    text = self:t("add_1_hour"),
                    checked_func = function() return self.settings.location.dst == 1 end,
                    callback = function()
                        self.settings.location.dst = 1; self:flushSettings() end,
                },
                {
                    text = self:t("add_2_hours"),
                    checked_func = function() return self.settings.location.dst == 2 end,
                    callback = function()
                        self.settings.location.dst = 2; self:flushSettings() end,
                },
                {
                    text = self:t("subtract_1_hour"),
                    checked_func = function() return self.settings.location.dst == -1 end,
                    callback = function()
                        self.settings.location.dst = -1; self:flushSettings() end,
                },
            },
        },
    }
end

function PrayerTimes:getCalculationSubmenu()
    local method_list = {
        { key = "MWL",       tkey = "mwl" },
        { key = "Egyptian",  tkey = "egyptian" },
        { key = "UmmAlQura", tkey = "ummalqura" },
        { key = "Karachi",   tkey = "karachi" },
        { key = "ISNA",      tkey = "isna" },
        { key = "Jafari",    tkey = "jafari" },
        { key = "Tehran",    tkey = "tehran" },
    }
    local method_items = {}
    for _, m in ipairs(method_list) do
        method_items[#method_items+1] = {
            text = self:t(m.tkey),
            checked_func = function()
                return self.settings.calculation.method == m.key
            end,
            callback = function()
                self.settings.calculation.method = m.key
                self:flushSettings()
            end,
        }
    end

    return {
        {
            text = self:t("calculation_method"),
            sub_item_table = method_items,
        },
        {
            text = self:t("asr_madhhab"),
            sub_item_table = {
                {
                    text = self:t("shafi"),
                    checked_func = function()
                        return self.settings.calculation.asr_madhhab == "Shafi" end,
                    callback = function()
                        self.settings.calculation.asr_madhhab = "Shafi"
                        self:flushSettings()
                    end,
                },
                {
                    text = self:t("hanafi"),
                    checked_func = function()
                        return self.settings.calculation.asr_madhhab == "Hanafi" end,
                    callback = function()
                        self.settings.calculation.asr_madhhab = "Hanafi"
                        self:flushSettings()
                    end,
                },
            },
        },
    }
end

function PrayerTimes:getHijriAndFastingSubmenu()
    local function adjItem(value, label)
        return {
            text = label,
            checked_func = function()
                return self.settings.display.hijri_adjustment == value
            end,
            callback = function()
                self.settings.display.hijri_adjustment = value
                self:flushSettings()
            end,
        }
    end

    return {
        {
            text = self:t("show_hijri"),
            checked_func = function() return self.settings.display.show_hijri end,
            callback = function()
                self.settings.display.show_hijri = not self.settings.display.show_hijri
                self:flushSettings()
            end,
        },
        {
            text = self:t("hijri_adjustment"),
            sub_item_table = {
                adjItem(-2, "-2 " .. self:t("days")),
                adjItem(-1, "-1 " .. self:t("day")),
                adjItem( 0, "0 (" .. self:t("default_val") .. ")"),
                adjItem( 1, "+1 " .. self:t("day")),
                adjItem( 2, "+2 " .. self:t("days")),
            },
        },
        {
            text = self:t("show_fasting_days"),
            checked_func = function() return self.settings.display.show_fasting_days end,
            callback = function()
                self.settings.display.show_fasting_days =
                    not self.settings.display.show_fasting_days
                self:flushSettings()
            end,
        },
        {
            text = self:t("fasting_reminder_days"),
            sub_item_table = {
                {
                    text = self:t("fasting_reminder_0"),
                    checked_func = function()
                        return (self.settings.display.fasting_reminder_days or 1) == 0 end,
                    callback = function()
                        self.settings.display.fasting_reminder_days = 0
                        self:flushSettings()
                    end,
                },
                {
                    text = self:t("fasting_reminder_1"),
                    checked_func = function()
                        return (self.settings.display.fasting_reminder_days or 1) == 1 end,
                    callback = function()
                        self.settings.display.fasting_reminder_days = 1
                        self:flushSettings()
                    end,
                },
                {
                    text = self:t("fasting_reminder_2"),
                    checked_func = function()
                        return (self.settings.display.fasting_reminder_days or 1) == 2 end,
                    callback = function()
                        self.settings.display.fasting_reminder_days = 2
                        self:flushSettings()
                    end,
                },
            },
        },
        {
            text = self:t("fasting_days"),
            sub_item_table = {
                {
                    text = self:t("monday_thursday_fasting"),
                    checked_func = function()
                        local fd = self.settings.display.fasting_days
                        return fd.mondays and fd.thursdays
                    end,
                    callback = function()
                        local fd = self.settings.display.fasting_days
                        local on = not (fd.mondays and fd.thursdays)
                        fd.mondays, fd.thursdays = on, on
                        self:flushSettings()
                    end,
                },
                {
                    text = self:t("white_days_fasting"),
                    checked_func = function()
                        return self.settings.display.fasting_days.white_days end,
                    callback = function()
                        local fd = self.settings.display.fasting_days
                        fd.white_days = not fd.white_days
                        self:flushSettings()
                    end,
                },
                {
                    text = self:t("ashura_fasting"),
                    checked_func = function()
                        return self.settings.display.fasting_days.ashura end,
                    callback = function()
                        local fd = self.settings.display.fasting_days
                        fd.ashura = not fd.ashura
                        self:flushSettings()
                    end,
                },
                {
                    text = self:t("arafah_fasting"),
                    checked_func = function()
                        return self.settings.display.fasting_days.arafah end,
                    callback = function()
                        local fd = self.settings.display.fasting_days
                        fd.arafah = not fd.arafah
                        self:flushSettings()
                    end,
                },
                {
                    text = self:t("six_shawwal_fasting"),
                    checked_func = function()
                        return self.settings.display.fasting_days.six_shawwal end,
                    callback = function()
                        local fd = self.settings.display.fasting_days
                        fd.six_shawwal = not fd.six_shawwal
                        self:flushSettings()
                    end,
                },
            },
        },
    }
end

function PrayerTimes:getFontSubmenu()
    local ok_fonts, fonts = pcall(utils.getDeviceFonts)
    if not ok_fonts or type(fonts) ~= "table" then
        fonts = { builtin = { "infofont" }, user = {}, plugin_dir = "" }
    end

    local items = {}

    local builtin_items = {}
    for _, name in ipairs(fonts.builtin or {}) do
        builtin_items[#builtin_items+1] = {
            text = name,
            checked_func = function()
                local d = self.settings.display
                return (d.custom_font_path or "") == ""
                   and (d.font_face or DEFAULTS.default_face) == name
            end,
            callback = function()
                local d = self.settings.display
                d.font_face = name
                d.custom_font_path = ""
                self:flushSettings()
                UIManager:show(InfoMessage:new{
                    text = self:t("font_applied"), timeout = 3 })
            end,
        }
    end
    items[#items+1] = {
        text = self:t("font_face_builtin"),
        sub_item_table = builtin_items,
    }

    local user_items = {}
    local count = 0
    for display, info in pairs(fonts.user or {}) do
        count = count + 1
        local filename = info.filename
        user_items[#user_items+1] = {
            text = display,
            checked_func = function()
                return (self.settings.display.custom_font_path or "") == filename
            end,
            callback = function()
                self.settings.display.custom_font_path = filename
                self:flushSettings()
                UIManager:show(InfoMessage:new{
                    text = self:t("font_applied"), timeout = 3 })
            end,
        }
    end
    table.sort(user_items, function(a, b) return a.text < b.text end)

    if count > 0 then
        items[#items+1] = {
            text = self:t("font_face_device") .. " (" .. count .. ")",
            sub_item_table = user_items,
        }
    else
        items[#items+1] = {
            text = self:t("font_face_device") .. " (0)",
            callback = function()
                UIManager:show(InfoMessage:new{
                    text = self:t("font_face_folder_hint"),
                    timeout = 30,
                })
            end,
        }
    end

    items[#items+1] = {
        text = self:t("font_how_to_add"),
        callback = function()
            UIManager:show(InfoMessage:new{
                text = self:t("font_face_folder_hint"),
                timeout = 30,
            })
        end,
    }

    return items
end

function PrayerTimes:getDisplaySubmenu()
    return {
        {
            text = self:t("language"),
            sub_item_table = {
                {
                    text = "English",
                    checked_func = function()
                        return self.settings.display.language == "en" end,
                    callback = function()
                        self.settings.display.language = "en"; self:flushSettings() end,
                },
                {
                    text = "العربية",
                    checked_func = function()
                        return self.settings.display.language == "ar" end,
                    callback = function()
                        self.settings.display.language = "ar"; self:flushSettings() end,
                },
            },
        },
        {
            text = self:t("time_format"),
            sub_item_table = {
                {
                    text = "24",
                    checked_func = function()
                        return self.settings.display.time_format == 24 end,
                    callback = function()
                        self.settings.display.time_format = 24; self:flushSettings() end,
                },
                {
                    text = "12",
                    checked_func = function()
                        return self.settings.display.time_format == 12 end,
                    callback = function()
                        self.settings.display.time_format = 12; self:flushSettings() end,
                },
            },
        },
        {
            text = self:t("clock_mode"),
            sub_item_table = {
                {
                    text = self:t("static_mode"),
                    checked_func = function()
                        return self.settings.display.clock_mode == "static" end,
                    callback = function()
                        self.settings.display.clock_mode = "static"; self:flushSettings() end,
                },
                {
                    text = self:t("live_mode"),
                    checked_func = function()
                        return self.settings.display.clock_mode == "live" end,
                    callback = function()
                        self.settings.display.clock_mode = "live"; self:flushSettings() end,
                },
                {
                    text = self:t("prayer_only"),
                    checked_func = function()
                        return self.settings.display.clock_mode == "prayer" end,
                    callback = function()
                        self.settings.display.clock_mode = "prayer"; self:flushSettings() end,
                },
            },
        },
        {
            text = self:t("font_face"),
            sub_item_table = self:getFontSubmenu(),
        },
        {
            text = self:t("font_size"),
            callback = function()
                local SpinWidget = require("ui/widget/spinwidget")
                UIManager:show(SpinWidget:new{
                    value = self.settings.display.font_size_offset
                            or DEFAULTS.settings.font_size_offset,
                    value_min = -15, value_max = 20, value_step = 1,
                    ok_text = self:t("save"),
                    title_text = self:t("font_size"),
                    callback = function(spin)
                        self.settings.display.font_size_offset = spin.value
                        self:flushSettings()
                    end,
                })
            end,
        },
        {
            text = self:t("screen_brightness"),
            callback = function()
                local SpinWidget = require("ui/widget/spinwidget")
                UIManager:show(SpinWidget:new{
                    value = self.settings.widget_brightness or -1,
                    value_min = -1, value_max = 24, value_step = 1,
                    ok_text = self:t("save"),
                    title_text = self:t("screen_brightness"),
                    info_text = self:t("screen_brightness_hint"),
                    callback = function(spin)
                        self.settings.widget_brightness = spin.value
                        self:flushSettings()
                    end,
                })
            end,
        },
        {
            text = self:t("status_widgets"),
            sub_item_table = {
                {
                    text = self:t("battery_widget"),
                    checked_func = function()
                        return self.settings.display.show_battery end,
                    callback = function()
                        local d = self.settings.display
                        d.show_battery = not d.show_battery
                        self:flushSettings()
                    end,
                },
                {
                    text = self:t("battery_format"),
                    sub_item_table = {
                        {
                            text = self:t("battery_icon"),
                            checked_func = function()
                                return self.settings.display.battery_format == "icon" end,
                            callback = function()
                                self.settings.display.battery_format = "icon"
                                self:flushSettings()
                            end,
                        },
                        {
                            text = self:t("battery_percent"),
                            checked_func = function()
                                return self.settings.display.battery_format == "percent" end,
                            callback = function()
                                self.settings.display.battery_format = "percent"
                                self:flushSettings()
                            end,
                        },
                        {
                            text = self:t("battery_both"),
                            checked_func = function()
                                return self.settings.display.battery_format == "both" end,
                            callback = function()
                                self.settings.display.battery_format = "both"
                                self:flushSettings()
                            end,
                        },
                    },
                },
                {
                    text = self:t("wifi_widget"),
                    checked_func = function() return self.settings.display.show_wifi end,
                    callback = function()
                        local d = self.settings.display
                        d.show_wifi = not d.show_wifi
                        self:flushSettings()
                    end,
                },
                {
                    text = self:t("memory_widget"),
                    checked_func = function() return self.settings.display.show_memory end,
                    callback = function()
                        local d = self.settings.display
                        d.show_memory = not d.show_memory
                        self:flushSettings()
                    end,
                },
            },
        },
        {
            text = self:t("auto_show_resume"),
            checked_func = function() return self.settings.display.auto_show_resume end,
            callback = function()
                local d = self.settings.display
                d.auto_show_resume = not d.auto_show_resume
                self:flushSettings()
                if d.auto_show_resume then
                    UIManager:show(InfoMessage:new{
                        text = self:t("auto_show_resume_info") })
                end
            end,
        },
    }
end

function PrayerTimes:getAlertsSubmenu()
    return {
        {
            text = self:t("flash_screen"),
            checked_func = function() return self.settings.alerts.flash end,
            callback = function()
                local a = self.settings.alerts
                a.flash = not a.flash
                self:flushSettings()
            end,
        },
        {
            text = self:t("frontlight_pulse"),
            checked_func = function() return self.settings.alerts.frontlight end,
            callback = function()
                local a = self.settings.alerts
                a.frontlight = not a.frontlight
                self:flushSettings()
            end,
        },
        {
            text = self:t("show_message"),
            checked_func = function() return self.settings.alerts.message end,
            callback = function()
                local a = self.settings.alerts
                a.message = not a.message
                self:flushSettings()
            end,
        },
        {
            text = self:t("frontlight_duration"),
            callback = function()
                local SpinWidget = require("ui/widget/spinwidget")
                UIManager:show(SpinWidget:new{
                    value = self.settings.alerts.frontlight_duration or 5,
                    value_min = 1, value_max = 30, value_step = 1,
                    ok_text = self:t("save"),
                    title_text = self:t("frontlight_duration"),
                    callback = function(spin)
                        self.settings.alerts.frontlight_duration = spin.value
                        self:flushSettings()
                    end,
                })
            end,
        },
    }
end

function PrayerTimes:showPrayerTimes()
    local ok, err = pcall(function()
        local now = os.time()
        local today = os.date("*t", now)
        local loc = self.settings.location
        local utc_offset = getEffectiveUtcOffset(loc)

        local times = calculateTimes(
            today.year, today.month, today.day,
            loc.latitude, loc.longitude, utc_offset,
            self.settings.calculation.method,
            self.settings.calculation.asr_madhhab)

        local hijri_date
        if self.settings.display.show_hijri then
            hijri_date = Hijri:gregorianToHijri(
                today.year, today.month, today.day,
                self.settings.display.hijri_adjustment or 0)
        end

        local lang = self.settings.display.language or "en"
        local next_prayer = self:getNextPrayer(times, now)
        if next_prayer and next_prayer.key then
            local tbl = translations_table[lang] or translations_table.en
            next_prayer.name = tbl[next_prayer.key]
                            or translations_table.en[next_prayer.key]
                            or next_prayer.key
        end

        local display_name = loc.name
        if lang == "ar" then
            if loc.name_ar and loc.name_ar ~= "" then
                display_name = loc.name_ar
            else
                for _, cities in pairs(locations) do
                    for _, c in ipairs(cities) do
                        if c.name == loc.name and c.name_ar and c.name_ar ~= "" then
                            display_name = c.name_ar
                            break
                        end
                    end
                end
            end
        end

        UIManager:show(PrayerTimesWidget:new{
            props = {
                times = times,
                next_prayer = next_prayer,
                hijri = hijri_date,
                location_name = display_name,
                settings = self.settings,
            },
        })
    end)

    if not ok then
        UIManager:show(InfoMessage:new{
            text = tostring(err),
            timeout = 8,
        })
    end
end

function PrayerTimes:getNextPrayer(times, system_now)
    local order = {
        { key = "fajr",    time = times.fajr },
        { key = "sunrise", time = times.sunrise },
        { key = "dhuhr",   time = times.dhuhr },
        { key = "asr",     time = times.asr },
        { key = "maghrib", time = times.maghrib },
        { key = "isha",    time = times.isha },
    }

        h = (tonumber(h) or 0) - utc_offset

    local function toSystemTime(hhmm, date_table)
        local h, m = hhmm:match("(%d+):(%d+)")
        h = (tonumber(h) or 0) - utc_offset
        m = tonumber(m) or 0
        local midnight = os.time{
            year = date_table.year, month = date_table.month,
            day = date_table.day, hour = 0, min = 0, sec = 0,
        }
        return midnight + h * 3600 + m * 60
    end

    for _, p in ipairs(order) do
        local ts = toSystemTime(p.time, today)
        if ts > system_now then
            return { key = p.key, name = p.key, timestamp = ts }
        end
    end

    local tomorrow = os.date("*t", system_now + 86400)
    local tt = calculateTimes(
        tomorrow.year, tomorrow.month, tomorrow.day,
        self.settings.location.latitude,
        self.settings.location.longitude,
        utc_offset,
        self.settings.calculation.method,
        self.settings.calculation.asr_madhhab)

    return {
        key = "fajr",
        name = "fajr",
        timestamp = toSystemTime(tt.fajr, tomorrow),
    }
end

function PrayerTimes:showLocationList()
    local lang = self.settings.display.language or "en"
    local items = {}

    local keys = {}
    for country in pairs(locations) do keys[#keys+1] = country end
    table.sort(keys)

    for _, country in ipairs(keys) do
        local cities = locations[country]
        local label = country
        if lang == "ar" and country_names_ar[country] then
            label = country_names_ar[country]
        end

        local city_items = {}
        for _, c in ipairs(cities) do
            local cname = c.name
            if lang == "ar" and c.name_ar and c.name_ar ~= "" then
                cname = c.name_ar
            end
            city_items[#city_items+1] = {
                text = cname,
                callback = function()
                    self:setLocation(c.name, c.name_ar, c.lat, c.lng, c.tz, country)
                    if self.location_menu then
                        UIManager:close(self.location_menu)
                        self.location_menu = nil
                    end
                end,
            }
        end

        items[#items+1] = { text = label, sub_item_table = city_items }
    end

    self.location_menu = Menu:new{
        title = self:t("choose_from_list"),
        item_table = items,
    }
    UIManager:show(self.location_menu)
end

function PrayerTimes:showAddLocationInput()
    UIManager:show(InfoMessage:new{
        text = self:t("location_help_text"),
        timeout = 8,
    })

    UIManager:scheduleIn(0.3, function()
        local fields = {
            { hint = self:t("country_hint"),    text = "" },
            { hint = self:t("country_ar_hint"), text = "" },
            { hint = self:t("city_hint"),       text = "" },
            { hint = self:t("city_ar_hint"),    text = "" },
            { hint = self:t("latitude_hint"),   text = "" },
            { hint = self:t("longitude_hint"),  text = "" },
        }

        local dialog
        dialog = MultiInputDialog:new{
            title = self:t("add_location"),
            fields = fields,
            buttons = {{
                {
                    text = self:t("cancel"),
                    callback = function() UIManager:close(dialog) end,
                },
                {
                    text = self:t("location_help_title"),
                    callback = function()
                        UIManager:show(InfoMessage:new{
                            text = self:t("location_help_text"), timeout = 20 })
                    end,
                },
                {
                    text = self:t("save"),
                    callback = function()
                        local function num(s)
                            if type(s) ~= "string" or s == "" then return nil end
                            s = s:gsub("%s+", ""):gsub(",", ".")
                            return tonumber(s)
                        end

                        local country_en = trimStr(fields[1].text)
                        local country_ar = trimStr(fields[2].text)
                        local city_en    = trimStr(fields[3].text)
                        local city_ar    = trimStr(fields[4].text)
                        local lat        = num(fields[5].text)
                        local lng        = num(fields[6].text)

                        if not lat or lat < -90 or lat > 90 then
                            UIManager:show(InfoMessage:new{ text = self:t("invalid_lat") })
                            return
                        end
                        if not lng or lng < -180 or lng > 180 then
                            UIManager:show(InfoMessage:new{ text = self:t("invalid_lng") })
                            return
                        end

                        if country_en == "" then country_en = "Custom" end
                        if country_ar == "" then country_ar = country_en end
                        if city_en    == "" then city_en    = "Custom City" end
                        if city_ar    == "" then city_ar    = city_en end

                        local tz = math.floor(lng / 15 + 0.5)

                        locations[country_en] = locations[country_en] or {}
                        country_names_ar[country_en] = country_ar
                        table.insert(locations[country_en], {
                            name = city_en, name_ar = city_ar,
                            lat = lat, lng = lng, tz = tz,
                        })

                        local saved = saveLocations()
                        local msg = interp(self:t("location_added"), city_en)

                        local suggested = getSuggestedMethod(country_en)
                        if suggested then
                            self.settings.calculation.method = suggested
                            msg = msg .. "\n" .. interp(self:t("method_auto_set"), suggested)
                        end

                        if not saved then
                            msg = msg .. "\n" .. self:t("invalid_input")
                        end

                        UIManager:show(InfoMessage:new{ text = msg, timeout = 6 })
                        self:setLocation(city_en, city_ar, lat, lng, tz, country_en, true)
                        UIManager:close(dialog)
                    end,
                },
            }},
        }
        UIManager:show(dialog)
    end)
end

function PrayerTimes:setLocation(name, name_ar, lat, lng, tz, country, silent)
    self.settings.location = {
        name       = name,
        name_ar    = name_ar or name,
        latitude   = lat,
        longitude  = lng,
        timezone   = tz,
        dst = (self.settings.location and self.settings.location.dst) or 0,
    }

    if country then
        local suggested = getSuggestedMethod(country)
        if suggested then
            self.settings.calculation.method = suggested
        end
    end

    self:flushSettings()

    if not silent then
        UIManager:show(InfoMessage:new{
            text = interp(self:t("location_set"), name),
            timeout = 3,
        })
    end
end

return PrayerTimes