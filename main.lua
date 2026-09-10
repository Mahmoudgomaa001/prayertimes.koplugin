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

local function getCustomLocationsPath()
    return DataStorage:getSettingsDir() .. "/prayertimes_custom_locations.lua"
end

-- Translates a stored English method key like "Egyptian" or "UmmAlQura"
-- into the user's current interface language for display purposes.
local method_translation_keys = {
    ["IACStandard"] = "iac_standard",
    ["MWL"]         = "mwl",
    ["Egyptian"]    = "egyptian",
    ["UmmAlQura"]   = "ummalqura",
    ["Karachi"]     = "karachi",
    ["ISNA"]        = "isna",
    ["Moroccan"]    = "moroccan",
    ["Tehran"]      = "tehran",
    ["Jafari"]      = "jafari",
}

local function getMethodDisplayName(self, method_key)
    local tkey = method_translation_keys[method_key]
    if tkey then
        return self:t(tkey)
    end
    return method_key or ""
end


local function loadLocations()
    local dist_file = getPluginDir() .. "/locations.lua"
    local ok_attr, attr = pcall(lfs.attributes, dist_file)
    if ok_attr and attr and attr.mode == "file" then
        local ok, result = pcall(function() return dofile(dist_file) end)
        if ok and type(result) == "table" and result.locations then
            locations = result.locations
            country_names_ar = result.country_names_ar or {}
        end
    end

    if not next(locations) then
        locations = {
            ["Egypt"] = {
                { name = "Alexandria", name_ar = "الإسكندرية", lat = 31.198, lng = 29.9192, tz = 2 },
                { name = "Cairo", name_ar = "القاهرة", lat = 30.0444, lng = 31.2357, tz = 2 },
            },
            ["Saudi Arabia"] = {
                { name = "Mecca", name_ar = "مكة المكرمة", lat = 21.4225, lng = 39.8262, tz = 3 },
                { name = "Medina", name_ar = "المدينة المنورة", lat = 24.5247, lng = 39.5692, tz = 3 },
            },
        }
        country_names_ar = {
            ["Egypt"] = "مصر",
            ["Saudi Arabia"] = "المملكة العربية السعودية",
        }
    end

    local custom_file = getCustomLocationsPath()
    local ok_ca, ca = pcall(lfs.attributes, custom_file)
    if ok_ca and ca and ca.mode == "file" then
        local ok, result = pcall(function() return dofile(custom_file) end)
        if ok and type(result) == "table" and result.locations then
            for country, cities in pairs(result.locations) do
                locations[country] = locations[country] or {}
                for _, new_city in ipairs(cities) do
                    local exists = false
                    for _, existing in ipairs(locations[country]) do
                        if existing.name == new_city.name then
                            exists = true
                            break
                        end
                    end
                    if not exists then
                        table.insert(locations[country], new_city)
                    end
                end
            end
            for country, ar_name in pairs(result.country_names_ar or {}) do
                if not country_names_ar[country] then
                    country_names_ar[country] = ar_name
                end
            end
        end
    end
end
loadLocations()

local function saveLocations()
    local ok, result = pcall(function()
        local file_path = getCustomLocationsPath()
        local f = io.open(file_path, "w")
        if not f then return false end
        f:write("-- Prayer Times: Persistent user locations\n\n")
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

local function getFontKey(display)
    if display.custom_font_path and display.custom_font_path ~= "" then
        return display.custom_font_path
    else
        return display.font_face or "infofont"
    end
end

local function getSavedFontOffset(display, font_key, lang)
    local fs = display.font_sizes and display.font_sizes[lang]
    return tonumber(fs and fs[font_key]) or nil
end

local function setFont(display, font_key, is_builtin)
    if is_builtin then
        display.font_face = font_key
        display.custom_font_path = ""
    else
        display.custom_font_path = font_key
    end
end

local function getAllFonts()
    local ok_fonts, fonts = pcall(utils.getDeviceFonts)
    if not ok_fonts or type(fonts) ~= "table" then
        fonts = { builtin = { "infofont" }, user = {} }
    end
    local all = {}
    for _, name in ipairs(fonts.builtin or {}) do
        all[#all+1] = { key = name, is_builtin = true, display = name }
    end
    for display, info in pairs(fonts.user or {}) do
        all[#all+1] = { key = info.filename, is_builtin = false, display = display }
    end
    table.sort(all, function(a, b) return a.display < b.display end)
    return all
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
                timezone = 2, dst_offset = S.dst_offset,
            },
            calculation = {
                method = S.method,
                asr_madhhab = S.asr_madhhab,
                high_latitude_rule = S.high_latitude_rule,
                high_latitude_minutes = S.high_latitude_minutes,
                force_ramadan = S.force_ramadan,
                adjustments = S.adjustments,
            },
            display = {
                language = S.language,
                show_hijri = S.show_hijri,
                time_format = S.time_format,
                clock_mode = S.clock_mode,
                apply_dst_to_clock = S.apply_dst_to_clock,
                show_battery = S.show_battery,
                show_wifi = S.show_wifi,
                show_memory = S.show_memory,
                battery_format = S.battery_format,
                auto_show_resume = S.auto_show_resume,
                font_face = S.font_face,
                custom_font_path = S.custom_font_path,
                hijri_adjustment = S.hijri_adjustment,
                show_fasting_days = S.show_fasting_days,
                fasting_reminder_days = S.fasting_reminder_days,
                fasting_days = {
                    mondays = true, thursdays = true, white_days = true,
                    ashura = true, arafah = true, six_shawwal = true,
                },
                font_size_offset_ar = S.font_size_offset_ar,
                font_size_offset_en = S.font_size_offset_en,
                font_sizes = { ar = {}, en = {} },
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
    loc.dst_offset = tonumber(loc.dst_offset) or 0
    self.settings.location = loc

    local calc = self.settings.calculation or {}
    calc.method      = calc.method      or S.method
    calc.asr_madhhab = calc.asr_madhhab or S.asr_madhhab
    calc.high_latitude_rule = calc.high_latitude_rule or S.high_latitude_rule or "none"
    calc.high_latitude_minutes = tonumber(calc.high_latitude_minutes) or S.high_latitude_minutes or 90
    if calc.force_ramadan == nil then calc.force_ramadan = S.force_ramadan end
    calc.adjustments = calc.adjustments or S.adjustments or {}
    local adj = calc.adjustments
    adj.fajr    = tonumber(adj.fajr)    or 0
    adj.sunrise = tonumber(adj.sunrise) or 0
    adj.dhuhr   = tonumber(adj.dhuhr)   or 0
    adj.asr     = tonumber(adj.asr)     or 0
    adj.maghrib = tonumber(adj.maghrib) or 0
    adj.isha    = tonumber(adj.isha)    or 0
    self.settings.calculation = calc

    local d = self.settings.display or {}
    d.language = d.language or S.language
    if d.show_hijri == nil then d.show_hijri = S.show_hijri end
    d.time_format = tonumber(d.time_format) or S.time_format
    d.clock_mode  = d.clock_mode or S.clock_mode
    if d.apply_dst_to_clock == nil then d.apply_dst_to_clock = S.apply_dst_to_clock or false end
    if d.show_battery == nil then d.show_battery = S.show_battery end
    if d.show_wifi    == nil then d.show_wifi    = S.show_wifi end
    if d.show_memory  == nil then d.show_memory  = S.show_memory end
    d.battery_format = d.battery_format or S.battery_format
    if d.auto_show_resume == nil then d.auto_show_resume = S.auto_show_resume end
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

    d.font_size_offset_ar = tonumber(d.font_size_offset_ar) or S.font_size_offset_ar
    d.font_size_offset_en = tonumber(d.font_size_offset_en) or S.font_size_offset_en
    d.font_sizes = d.font_sizes or { ar = {}, en = {} }
    d.font_sizes.ar = d.font_sizes.ar or {}
    d.font_sizes.en = d.font_sizes.en or {}

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

function PrayerTimes:getCalculationOptions()
    local calc = self.settings.calculation or {}
    local disp = self.settings.display or {}
    return {
        hijri_adjustment = disp.hijri_adjustment or 0,
        force_ramadan = calc.force_ramadan,
        high_latitude_rule = calc.high_latitude_rule or "none",
        high_latitude_minutes = calc.high_latitude_minutes or 90,
        adjustments = calc.adjustments or {},
    }
end

function PrayerTimes:previewFont(font_key, is_builtin)
    local display = self.settings.display
    local lang = display.language or "en"
    local default_offset = DEFAULTS.settings["font_size_offset_"..lang] or 0
    local preview_offset = getSavedFontOffset(display, font_key, lang) or default_offset

    local all_fonts = getAllFonts()
    local current_index = 1
    for i, font in ipairs(all_fonts) do
        if font.key == font_key and font.is_builtin == is_builtin then
            current_index = i
            break
        end
    end

    local now = os.time()
    local display_now = self:getDisplayNow(now)
    local today = os.date("*t", display_now)
    local loc = self.settings.location
    local dst = loc.dst_offset or 0
    local tz  = (loc.timezone or 0) + dst

    local times, calc_err = calculateTimes(
        today.year, today.month, today.day,
        loc.latitude, loc.longitude, tz,
        self.settings.calculation.method,
        self.settings.calculation.asr_madhhab,
        self:getCalculationOptions()
    )

    if not times then
        UIManager:show(InfoMessage:new{
            text = interp(self:t("calc_error"), tostring(calc_err)),
            timeout = 6,
        })
        return
    end

    local hijri_date
    if display.show_hijri then
        hijri_date = Hijri:gregorianToHijri(
            today.year, today.month, today.day,
            display.hijri_adjustment or 0
        )
    end

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
            settings = self.settings,
            preview_font = font_key,
            preview_offset = preview_offset,
            all_fonts = all_fonts,
            current_index = current_index,
            times = times,
            next_prayer = next_prayer,
            hijri = hijri_date,
            location_name = display_name,
            on_apply_font = function(offset, fkey, fbuiltin, flang)
                display.font_sizes = display.font_sizes or { ar = {}, en = {} }
                display.font_sizes[flang] = display.font_sizes[flang] or {}
                display.font_sizes[flang][fkey] = offset
                setFont(display, fkey, fbuiltin)
                self:flushSettings()
            end,
        },
    })
end

function PrayerTimes:applyFont(font_key, is_builtin)
    local display = self.settings.display
    setFont(display, font_key, is_builtin)
    self:flushSettings()
    UIManager:show(InfoMessage:new{
        text = self:t("font_applied"), timeout = 3
    })
end

function PrayerTimes:getDisplayNow(system_now)
    system_now = tonumber(system_now) or os.time()
    local display = self.settings.display or {}
    if display.apply_dst_to_clock then
        local loc = self.settings.location or {}
        local dst = tonumber(loc.dst_offset) or 0
        return system_now + dst * 3600
    end
    return system_now
end

function PrayerTimes:addToMainMenu(menu_items)
    menu_items.prayer_times = {
        text = self:t("prayer_times"),
        sorting_hint = "tools",
        sub_item_table = {
            { text = self:t("launch"), callback = function() self:showPrayerTimes() end },
            { text = self:t("set_location"), sub_item_table = self:getLocationSubmenu() },
            { text = self:t("calculation_settings"), sub_item_table = self:getCalculationSubmenu() },
            { text = self:t("hijri_and_fasting"), sub_item_table = self:getHijriAndFastingSubmenu() },
            { text = self:t("display_and_appearance"), sub_item_table = self:getDisplaySubmenu() },
            { text = self:t("alerts"), sub_item_table = self:getAlertsSubmenu() },
            {
                text = self:t("about"),
                callback = function() UIManager:show(InfoMessage:new{ text = self:t("about_text"), timeout = 15 }) end,
            },
        },
    }
end

function PrayerTimes:getLocationSubmenu()
    return {
        { text = self:t("choose_from_list"), callback = function() self:showLocationList() end },
        { text = self:t("add_location"), callback = function() self:showAddLocationInput() end },
        {
            text = self:t("dst_adjustment"),
            sub_item_table = {
                { text = self:t("no_dst"), checked_func = function() return self.settings.location.dst_offset == 0 end, callback = function() self.settings.location.dst_offset = 0; self:flushSettings() end },
                { text = self:t("add_1_hour"), checked_func = function() return self.settings.location.dst_offset == 1 end, callback = function() self.settings.location.dst_offset = 1; self:flushSettings() end },
                { text = self:t("add_2_hours"), checked_func = function() return self.settings.location.dst_offset == 2 end, callback = function() self.settings.location.dst_offset = 2; self:flushSettings() end },
                { text = self:t("subtract_1_hour"), checked_func = function() return self.settings.location.dst_offset == -1 end, callback = function() self.settings.location.dst_offset = -1; self:flushSettings() end },
                { text = self:t("apply_dst_to_clock"), checked_func = function() return self.settings.display.apply_dst_to_clock == true end, callback = function() self.settings.display.apply_dst_to_clock = not self.settings.display.apply_dst_to_clock; self:flushSettings(); UIManager:show(InfoMessage:new{ text = self:t("apply_dst_to_clock_info"), timeout = 6 }) end },
            },
        },
    }
end

function PrayerTimes:getCalculationSubmenu()
    local method_list = {
        { key = "IACStandard", tkey = "iac_standard" },
        { key = "MWL",         tkey = "mwl" },
        { key = "Egyptian",    tkey = "egyptian" },
        { key = "Moroccan",    tkey = "moroccan" },
        { key = "UmmAlQura",   tkey = "ummalqura" },
        { key = "Karachi",     tkey = "karachi" },
        { key = "ISNA",        tkey = "isna" },
        { key = "Tehran",      tkey = "tehran" },
        { key = "Jafari",      tkey = "jafari" },
    }
    local method_items = {}
    for _, m in ipairs(method_list) do
        method_items[#method_items+1] = {
            text = self:t(m.tkey),
            checked_func = function() return self.settings.calculation.method == m.key end,
            callback = function() self.settings.calculation.method = m.key; self:flushSettings() end,
        }
    end

    local hl_items = {
        { text = self:t("high_latitude_none"), checked_func = function() return self.settings.calculation.high_latitude_rule == "none" end, callback = function() self.settings.calculation.high_latitude_rule = "none"; self:flushSettings() end },
        { text = self:t("high_latitude_seventh"), checked_func = function() return self.settings.calculation.high_latitude_rule == "seventh" end, callback = function() self.settings.calculation.high_latitude_rule = "seventh"; self:flushSettings() end },
        { text = self:t("high_latitude_middle"), checked_func = function() return self.settings.calculation.high_latitude_rule == "middle" end, callback = function() self.settings.calculation.high_latitude_rule = "middle"; self:flushSettings() end },
        { text = self:t("high_latitude_angle"), checked_func = function() return self.settings.calculation.high_latitude_rule == "angle_based" end, callback = function() self.settings.calculation.high_latitude_rule = "angle_based"; self:flushSettings() end },
        { text = self:t("high_latitude_fixed"), checked_func = function() return self.settings.calculation.high_latitude_rule == "fixed_minutes" end, callback = function() self.settings.calculation.high_latitude_rule = "fixed_minutes"; self:flushSettings() end },
    }

    local adj = self.settings.calculation.adjustments or {}
    local adj_items = {}
    local prayer_keys = { "fajr", "sunrise", "dhuhr", "asr", "maghrib", "isha" }
    for _, pk in ipairs(prayer_keys) do
        local tkey = pk .. "_adjustment"
        adj_items[#adj_items+1] = {
            text = self:t(tkey) .. ": " .. tostring(adj[pk] or 0),
            callback = function()
                local SpinWidget = require("ui/widget/spinwidget")
                UIManager:show(SpinWidget:new{
                    value = adj[pk] or 0,
                    value_min = -30,
                    value_max = 30,
                    value_step = 1,
                    ok_text = self:t("save"),
                    title_text = self:t(tkey),
                    callback = function(spin)
                        adj[pk] = spin.value
                        self.settings.calculation.adjustments = adj
                        self:flushSettings()
                    end,
                })
            end,
        }
    end

    return {
        { text = self:t("calculation_method"), sub_item_table = method_items },
        { text = self:t("asr_madhhab"), sub_item_table = {
            { text = self:t("shafi"), checked_func = function() return self.settings.calculation.asr_madhhab == "Shafi" end, callback = function() self.settings.calculation.asr_madhhab = "Shafi"; self:flushSettings() end },
            { text = self:t("hanafi"), checked_func = function() return self.settings.calculation.asr_madhhab == "Hanafi" end, callback = function() self.settings.calculation.asr_madhhab = "Hanafi"; self:flushSettings() end },
        }},
        { text = self:t("high_latitude_title"), sub_item_table = hl_items },
        { text = self:t("prayer_adjustments"), sub_item_table = adj_items },
    }
end

function PrayerTimes:getHijriAndFastingSubmenu()
    local function adjItem(value, label)
        return { text = label, checked_func = function() return self.settings.display.hijri_adjustment == value end, callback = function() self.settings.display.hijri_adjustment = value; self:flushSettings() end }
    end
    return {
        { text = self:t("show_hijri"), checked_func = function() return self.settings.display.show_hijri end, callback = function() self.settings.display.show_hijri = not self.settings.display.show_hijri; self:flushSettings() end },
        { text = self:t("hijri_adjustment"), sub_item_table = { adjItem(-3, "-3 " .. self:t("days")), adjItem(-2, "-2 " .. self:t("days")), adjItem(-1, "-1 " .. self:t("day")), adjItem(0, "0 (" .. self:t("default_val") .. ")"), adjItem(1, "+1 " .. self:t("day")), adjItem(2, "+2 " .. self:t("days")), adjItem(3, "+3 " .. self:t("days")) } },
        { text = self:t("force_ramadan_title"), sub_item_table = {
            { text = self:t("force_ramadan_auto"), checked_func = function() return self.settings.calculation.force_ramadan == nil end, callback = function() self.settings.calculation.force_ramadan = nil; self:flushSettings() end },
            { text = self:t("force_ramadan_yes"), checked_func = function() return self.settings.calculation.force_ramadan == true end, callback = function() self.settings.calculation.force_ramadan = true; self:flushSettings() end },
            { text = self:t("force_ramadan_no"), checked_func = function() return self.settings.calculation.force_ramadan == false end, callback = function() self.settings.calculation.force_ramadan = false; self:flushSettings() end },
        }},
        { text = self:t("show_fasting_days"), checked_func = function() return self.settings.display.show_fasting_days end, callback = function() self.settings.display.show_fasting_days = not self.settings.display.show_fasting_days; self:flushSettings() end },
        { text = self:t("fasting_reminder_days"), sub_item_table = {
            { text = self:t("fasting_reminder_0"), checked_func = function() return (self.settings.display.fasting_reminder_days or 1) == 0 end, callback = function() self.settings.display.fasting_reminder_days = 0; self:flushSettings() end },
            { text = self:t("fasting_reminder_1"), checked_func = function() return (self.settings.display.fasting_reminder_days or 1) == 1 end, callback = function() self.settings.display.fasting_reminder_days = 1; self:flushSettings() end },
            { text = self:t("fasting_reminder_2"), checked_func = function() return (self.settings.display.fasting_reminder_days or 1) == 2 end, callback = function() self.settings.display.fasting_reminder_days = 2; self:flushSettings() end },
        }},
        { text = self:t("fasting_days"), sub_item_table = {
            { text = self:t("monday_thursday_fasting"), checked_func = function() local fd = self.settings.display.fasting_days; return fd.mondays and fd.thursdays end, callback = function() local fd = self.settings.display.fasting_days; local on = not (fd.mondays and fd.thursdays); fd.mondays, fd.thursdays = on, on; self:flushSettings() end },
            { text = self:t("white_days_fasting"), checked_func = function() return self.settings.display.fasting_days.white_days end, callback = function() self.settings.display.fasting_days.white_days = not self.settings.display.fasting_days.white_days; self:flushSettings() end },
            { text = self:t("ashura_fasting"), checked_func = function() return self.settings.display.fasting_days.ashura end, callback = function() self.settings.display.fasting_days.ashura = not self.settings.display.fasting_days.ashura; self:flushSettings() end },
            { text = self:t("arafah_fasting"), checked_func = function() return self.settings.display.fasting_days.arafah end, callback = function() self.settings.display.fasting_days.arafah = not self.settings.display.fasting_days.arafah; self:flushSettings() end },
            { text = self:t("six_shawwal_fasting"), checked_func = function() return self.settings.display.fasting_days.six_shawwal end, callback = function() self.settings.display.fasting_days.six_shawwal = not self.settings.display.fasting_days.six_shawwal; self:flushSettings() end },
        }},
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
                return (d.custom_font_path or "") == "" and (d.font_face or DEFAULTS.default_face) == name
            end,
            callback = function() self:previewFont(name, true) end,
        }
    end
    items[#items+1] = { text = self:t("font_face_builtin"), sub_item_table = builtin_items }

    local user_items = {}
    local count = 0
    for display, info in pairs(fonts.user or {}) do
        count = count + 1
        local filename = info.filename
        user_items[#user_items+1] = {
            text = display,
            checked_func = function() return (self.settings.display.custom_font_path or "") == filename end,
            callback = function() self:previewFont(filename, false) end,
        }
    end
    table.sort(user_items, function(a, b) return a.text < b.text end)

    if count > 0 then
        items[#items+1] = { text = self:t("font_face_device") .. " (" .. count .. ")", sub_item_table = user_items }
    else
        items[#items+1] = { text = self:t("font_face_device") .. " (0)", callback = function() UIManager:show(InfoMessage:new{ text = self:t("font_face_folder_hint"), timeout = 30 }) end }
    end

    items[#items+1] = { text = self:t("font_how_to_add"), callback = function() UIManager:show(InfoMessage:new{ text = self:t("font_face_folder_hint"), timeout = 30 }) end }

    return items
end

function PrayerTimes:getDisplaySubmenu()
    return {
        { text = self:t("language"), sub_item_table = {
            { text = "English", checked_func = function() return self.settings.display.language == "en" end, callback = function() self.settings.display.language = "en"; self:flushSettings() end },
            { text = "العربية", checked_func = function() return self.settings.display.language == "ar" end, callback = function() self.settings.display.language = "ar"; self:flushSettings() end },
        }},
        { text = self:t("time_format"), sub_item_table = {
            { text = "24", checked_func = function() return self.settings.display.time_format == 24 end, callback = function() self.settings.display.time_format = 24; self:flushSettings() end },
            { text = "12", checked_func = function() return self.settings.display.time_format == 12 end, callback = function() self.settings.display.time_format = 12; self:flushSettings() end },
        }},
        { text = self:t("clock_mode"), sub_item_table = {
            { text = self:t("static_mode"), checked_func = function() return self.settings.display.clock_mode == "static" end, callback = function() self.settings.display.clock_mode = "static"; self:flushSettings() end },
            { text = self:t("live_mode"), checked_func = function() return self.settings.display.clock_mode == "live" end, callback = function() self.settings.display.clock_mode = "live"; self:flushSettings() end },
            { text = self:t("prayer_only"), checked_func = function() return self.settings.display.clock_mode == "prayer" end, callback = function() self.settings.display.clock_mode = "prayer"; self:flushSettings() end },
        }},
        { text = self:t("font_face"), sub_item_table = self:getFontSubmenu() },
        { text = self:t("screen_brightness"), callback = function() local SpinWidget = require("ui/widget/spinwidget"); UIManager:show(SpinWidget:new{ value = self.settings.widget_brightness or -1, value_min = -1, value_max = 24, value_step = 1, ok_text = self:t("save"), title_text = self:t("screen_brightness"), info_text = self:t("screen_brightness_hint"), callback = function(spin) self.settings.widget_brightness = spin.value; self:flushSettings() end }) end },
        { text = self:t("status_widgets"), sub_item_table = {
            { text = self:t("battery_widget"), checked_func = function() return self.settings.display.show_battery end, callback = function() self.settings.display.show_battery = not self.settings.display.show_battery; self:flushSettings() end },
            { text = self:t("battery_format"), sub_item_table = {
                { text = self:t("battery_icon"), checked_func = function() return self.settings.display.battery_format == "icon" end, callback = function() self.settings.display.battery_format = "icon"; self:flushSettings() end },
                { text = self:t("battery_percent"), checked_func = function() return self.settings.display.battery_format == "percent" end, callback = function() self.settings.display.battery_format = "percent"; self:flushSettings() end },
                { text = self:t("battery_both"), checked_func = function() return self.settings.display.battery_format == "both" end, callback = function() self.settings.display.battery_format = "both"; self:flushSettings() end },
            }},
            { text = self:t("wifi_widget"), checked_func = function() return self.settings.display.show_wifi end, callback = function() self.settings.display.show_wifi = not self.settings.display.show_wifi; self:flushSettings() end },
            { text = self:t("memory_widget"), checked_func = function() return self.settings.display.show_memory end, callback = function() self.settings.display.show_memory = not self.settings.display.show_memory; self:flushSettings() end },
        }},
        { text = self:t("auto_show_resume"), checked_func = function() return self.settings.display.auto_show_resume end, callback = function() self.settings.display.auto_show_resume = not self.settings.display.auto_show_resume; self:flushSettings(); if self.settings.display.auto_show_resume then UIManager:show(InfoMessage:new{ text = self:t("auto_show_resume_info") }) end end },
    }
end

function PrayerTimes:getAlertsSubmenu()
    return {
        { text = self:t("flash_screen"), checked_func = function() return self.settings.alerts.flash end, callback = function() self.settings.alerts.flash = not self.settings.alerts.flash; self:flushSettings() end },
        { text = self:t("frontlight_pulse"), checked_func = function() return self.settings.alerts.frontlight end, callback = function() self.settings.alerts.frontlight = not self.settings.alerts.frontlight; self:flushSettings() end },
        { text = self:t("show_message"), checked_func = function() return self.settings.alerts.message end, callback = function() self.settings.alerts.message = not self.settings.alerts.message; self:flushSettings() end },
        { text = self:t("frontlight_duration"), callback = function() local SpinWidget = require("ui/widget/spinwidget"); UIManager:show(SpinWidget:new{ value = self.settings.alerts.frontlight_duration or 5, value_min = 1, value_max = 30, value_step = 1, ok_text = self:t("save"), title_text = self:t("frontlight_duration"), callback = function(spin) self.settings.alerts.frontlight_duration = spin.value; self:flushSettings() end }) end },
    }
end

function PrayerTimes:showPrayerTimes()
    local ok, err = pcall(function()
        local now = os.time()
        local display_now = self:getDisplayNow(now)
        local today = os.date("*t", display_now)
        local loc = self.settings.location
        local dst = loc.dst_offset or 0
        local tz  = (loc.timezone or 0) + dst

        local times, calc_err = calculateTimes(
            today.year, today.month, today.day,
            loc.latitude, loc.longitude, tz,
            self.settings.calculation.method,
            self.settings.calculation.asr_madhhab,
            self:getCalculationOptions()
        )

        if not times then
            UIManager:show(InfoMessage:new{
                text = interp(self:t("calc_error"), tostring(calc_err)),
                timeout = 8,
            })
            return
        end

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
    system_now = tonumber(system_now) or os.time()
    if type(times) ~= "table" then return nil end

    local order = {
        { key = "fajr",    time = times.fajr },
        { key = "sunrise", time = times.sunrise },
        { key = "dhuhr",   time = times.dhuhr },
        { key = "asr",     time = times.asr },
        { key = "maghrib", time = times.maghrib },
        { key = "isha",    time = times.isha },
    }

    local loc = self.settings.location or {}
    local calc = self.settings.calculation or {}
    local display = self.settings.display or {}
    local dst = tonumber(loc.dst_offset) or 0
    local apply_dst = display.apply_dst_to_clock == true

    local display_now = system_now
    if apply_dst then
        display_now = display_now + dst * 3600
    end

    local today = os.date("*t", display_now)

    local function toSystemTime(hhmm, date_table)
        if type(hhmm) ~= "string" or type(date_table) ~= "table" then
            return nil
        end
        local h, m = hhmm:match("^(%d%d?):(%d%d)$")
        h = tonumber(h)
        m = tonumber(m)
        if not h or not m or h < 0 or h > 23 or m < 0 or m > 59 then
            return nil
        end
        local midnight = os.time{
            year = date_table.year, month = date_table.month,
            day = date_table.day, hour = 0, min = 0, sec = 0,
        }
        local timestamp = midnight + h * 3600 + m * 60
        if apply_dst then
            timestamp = timestamp - dst * 3600
        end
        return timestamp
    end

    for _, p in ipairs(order) do
        local ts = toSystemTime(p.time, today)
        if ts and ts > system_now then
            return { key = p.key, name = p.key, timestamp = ts }
        end
    end

    local tomorrow_noon = os.time{
        year = today.year, month = today.month,
        day = today.day + 1, hour = 12, min = 0, sec = 0,
    }
    local tomorrow = os.date("*t", tomorrow_noon)

    local tomorrow_times, _ = calculateTimes(
        tomorrow.year, tomorrow.month, tomorrow.day,
        tonumber(loc.latitude) or 31.198,
        tonumber(loc.longitude) or 29.9192,
        (tonumber(loc.timezone) or 0) + dst,
        calc.method or DEFAULTS.settings.method,
        calc.asr_madhhab or DEFAULTS.settings.asr_madhhab,
        self:getCalculationOptions()
    )

    if not tomorrow_times then
        return nil
    end

    return {
        key = "fajr",
        name = "fajr",
        timestamp = toSystemTime(tomorrow_times.fajr, tomorrow),
    }
end

function PrayerTimes:showLocationList()
    local lang = self.settings.display.language or "en"

    -- Build a flat searchable list of all cities
    local flat_list = {}

    local country_keys = {}
    for country in pairs(locations) do
        country_keys[#country_keys+1] = country
    end
    table.sort(country_keys)

    for _, country in ipairs(country_keys) do
        local cities = locations[country]
        local country_label = country
        if lang == "ar" and country_names_ar[country] then
            country_label = country_names_ar[country]
        end

        for _, c in ipairs(cities) do
            local city_label = c.name
            if lang == "ar" and c.name_ar and c.name_ar ~= "" then
                city_label = c.name_ar
            end

            -- Display: "City — Country"
            local display_text = city_label .. " — " .. country_label

            -- Searchable text includes all names for both languages
            local search_text = string.lower(
                (c.name or "")
                .. " "
                .. (c.name_ar or "")
                .. " "
                .. country
                .. " "
                .. (country_names_ar[country] or "")
            )

            flat_list[#flat_list+1] = {
                text = display_text,
                search_text = search_text,
                city = c,
                country = country,
            }
        end
    end

    -- Sort alphabetically by display text
    table.sort(flat_list, function(a, b)
        return a.text < b.text
    end)

    local function showFilteredList(filter_text)
        filter_text = string.lower(
            trimStr(filter_text or "")
        )

        local items = {}

        for _, entry in ipairs(flat_list) do
            local show = true

            if filter_text ~= "" then
                show = entry.search_text:find(
                    filter_text,
                    1,
                    true -- plain text search
                ) ~= nil
            end

            if show then
                items[#items+1] = {
                    text = entry.text,
                    callback = function()
                        local c = entry.city
                        self:setLocation(
                            c.name,
                            c.name_ar,
                            c.lat,
                            c.lng,
                            c.tz,
                            entry.country
                        )

                        if self.location_menu then
                            UIManager:close(
                                self.location_menu
                            )
                            self.location_menu = nil
                        end

                        if self.search_dialog then
                            UIManager:close(
                                self.search_dialog
                            )
                            self.search_dialog = nil
                        end
                    end,
                }
            end
        end

        if #items == 0 then
            items[#items+1] = {
                text = self:t("na"),
            }
        end

        if self.location_menu then
            UIManager:close(self.location_menu)
        end

        self.location_menu = Menu:new{
            title = self:t("choose_from_list")
                .. " (" .. #items .. ")",
            item_table = items,
            width = Screen:getWidth()
                - Screen:scaleBySize(20),
            height = Screen:getHeight()
                - Screen:scaleBySize(80),
        }

        UIManager:show(self.location_menu)
    end

    -- Show search input first
    local InputDialog = require("ui/widget/inputdialog")

    self.search_dialog = InputDialog:new{
        title = self:t("choose_from_list"),
        input = "",
        input_hint = lang == "ar"
            and "ابحث: القاهرة، مكة، Casablanca..."
            or "Search: Cairo, Mecca, الرياض...",
        buttons = {{
            {
                text = self:t("cancel"),
                id = "close",
                callback = function()
                    UIManager:close(self.search_dialog)
                    self.search_dialog = nil
                end,
            },
            {
                text = lang == "ar"
                    and "عرض الكل"
                    or "Show All",
                callback = function()
                    UIManager:close(self.search_dialog)
                    self.search_dialog = nil
                    showFilteredList("")
                end,
            },
            {
                text = lang == "ar"
                    and "بحث"
                    or "Search",
                is_enter_default = true,
                callback = function()
                    local query =
                        self.search_dialog:getInputText()

                    UIManager:close(self.search_dialog)
                    self.search_dialog = nil
                    showFilteredList(query)
                end,
            },
        }},
    }

    UIManager:show(self.search_dialog)
end

function PrayerTimes:showAddLocationInput()
    -- Show the friendly step-by-step guide first
    UIManager:show(InfoMessage:new{
        text = self:t("add_location_guide_text"),
        timeout = 25,
    })

    UIManager:scheduleIn(0.5, function()
        local lang = self.settings.display.language or "en"

        local fields
        if lang == "ar" then
            fields = {
                { hint = "Egypt",   text = "" },
                { hint = "مصر",     text = "" },
                { hint = "Cairo",   text = "" },
                { hint = "القاهرة", text = "" },
                { hint = "30.0444", text = "" },
                { hint = "31.2357", text = "" },
            }
        else
            fields = {
                { hint = "e.g., Egypt",    text = "" },
                { hint = "e.g., مصر",      text = "" },
                { hint = "e.g., Cairo",    text = "" },
                { hint = "e.g., القاهرة",  text = "" },
                { hint = "e.g., 30.0444",  text = "" },
                { hint = "e.g., 31.2357",  text = "" },
            }
        end

        local dialog
        dialog = MultiInputDialog:new{
            title = self:t("add_location"),
            fields = fields,
            buttons = {{
                {
                    text = self:t("cancel"),
                    id = "close",
                    callback = function()
                        UIManager:close(dialog)
                    end,
                },
                {
                    text = self:t("add_location_guide_title"),
                    callback = function()
                        UIManager:show(InfoMessage:new{
                            text = self:t(
                                "add_location_guide_text"
                            ),
                            timeout = 25,
                        })
                    end,
                },
                {
                    text = self:t("save"),
                    is_enter_default = true,
                    callback = function()
                        local function num(s)
                            if type(s) ~= "string"
                                    or s == "" then
                                return nil
                            end
                            s = s:gsub("%s+", "")
                                 :gsub(",", ".")
                            return tonumber(s)
                        end

                        local values = dialog:getFields()

                        local country_en = trimStr(values[1] or "")
                        local country_ar = trimStr(values[2] or "")
                        local city_en    = trimStr(values[3] or "")
                        local city_ar    = trimStr(values[4] or "")
                        local lat        = num(values[5])
                        local lng        = num(values[6])

                        if not lat
                                or lat < -90
                                or lat > 90 then
                            UIManager:show(InfoMessage:new{
                                text = self:t("invalid_lat"),
                            })
                            return
                        end

                        if not lng
                                or lng < -180
                                or lng > 180 then
                            UIManager:show(InfoMessage:new{
                                text = self:t("invalid_lng"),
                            })
                            return
                        end

                        if country_en == "" then
                            country_en = "Custom"
                        end
                        if country_ar == "" then
                            country_ar = country_en
                        end
                        if city_en == "" then
                            city_en = "Custom City"
                        end
                        if city_ar == "" then
                            city_ar = city_en
                        end

                        local tz = math.floor(
                            lng / 15 + 0.5
                        )

                        locations[country_en] =
                            locations[country_en] or {}

                        country_names_ar[country_en] =
                            country_ar

                        table.insert(
                            locations[country_en],
                            {
                                name = city_en,
                                name_ar = city_ar,
                                lat = lat,
                                lng = lng,
                                tz = tz,
                            }
                        )

                        local saved = saveLocations()

                        -- Determine which name to show in the message
                        local city_display = city_en
                        if lang == "ar"
                                and city_ar ~= "" then
                            city_display = city_ar
                        end

                        local suggested =
                            getSuggestedMethod(country_en)

                        local method_name

                        if suggested then
                            self.settings.calculation.method =
                                suggested

                            method_name =
                                getMethodDisplayName(
                                    self,
                                    suggested
                                )

                            UIManager:show(InfoMessage:new{
                                text = interp(
                                    self:t(
                                        "method_recommended_info"
                                    ):gsub(
                                        "%%1",
                                        city_display
                                    ),
                                    method_name
                                ),
                                timeout = 10,
                            })
                        else
                            method_name =
                                getMethodDisplayName(
                                    self,
                                    self.settings
                                        .calculation.method
                                )

                            UIManager:show(InfoMessage:new{
                                text = interp(
                                    self:t(
                                        "method_no_recommendation"
                                    ):gsub(
                                        "%%1",
                                        city_display
                                    ),
                                    method_name
                                ),
                                timeout = 10,
                            })
                        end

                        if not saved then
                            UIManager:show(InfoMessage:new{
                                text = self:t("invalid_input"),
                                timeout = 4,
                            })
                        end

                        self:setLocation(
                            city_en,
                            city_ar,
                            lat,
                            lng,
                            tz,
                            country_en,
                            true -- silent: skip the small "Location set" popup
                        )

                        UIManager:close(dialog)
                    end,
                },
            }},
        }

        UIManager:show(dialog)
    end)
end

function PrayerTimes:setLocation(
    name,
    name_ar,
    lat,
    lng,
    tz,
    country,
    silent
)
    self.settings.location = {
        name       = name,
        name_ar    = name_ar or name,
        latitude   = lat,
        longitude  = lng,
        timezone   = tz,
        dst_offset =
            (self.settings.location
                and self.settings.location.dst_offset)
            or 0,
    }

    local suggested_applied = false

    if country then
        local suggested = getSuggestedMethod(country)
        if suggested
                and self.settings.calculation.method
                    ~= suggested then
            self.settings.calculation.method = suggested
            suggested_applied = true
        end
    end

    self:flushSettings()

    if silent then
        return
    end

    -- Choose the correct name to display based on current language
    local lang = self.settings.display.language or "en"
    local display_name = name
    if lang == "ar"
            and name_ar
            and name_ar ~= "" then
        display_name = name_ar
    end

    if suggested_applied then
        local method_name = getMethodDisplayName(
            self,
            self.settings.calculation.method
        )

        UIManager:show(InfoMessage:new{
            text = interp(
                self:t("method_recommended_info")
                    :gsub("%%1", display_name),
                method_name
            ),
            timeout = 8,
        })
    else
        UIManager:show(InfoMessage:new{
            text = interp(
                self:t("location_set"),
                display_name
            ),
            timeout = 3,
        })
    end
end

return PrayerTimes