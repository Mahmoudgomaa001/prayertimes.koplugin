-- fasting.lua
local translations = require("translations")
local calculation = require("calculation")

local Hijri = calculation.Hijri
local translations_table = translations.translations
local fasting_reason_keys = translations.fasting_reason_keys

local function checkFastingForDate(hijri_date, weekday, cfg)
    local day, month = hijri_date.day, hijri_date.month
    local reasons = {}

    if cfg.mondays   and weekday == "Monday"   then reasons[#reasons+1] = "monday"   end
    if cfg.thursdays and weekday == "Thursday" then reasons[#reasons+1] = "thursday" end
    if cfg.white_days and (day == 13 or day == 14 or day == 15) then
        reasons[#reasons+1] = "white"
    end
    if cfg.ashura and month == 1  and day == 10 then reasons[#reasons+1] = "ashura"  end
    if cfg.arafah and month == 12 and day == 9  then reasons[#reasons+1] = "arafah"  end
    if cfg.six_shawwal and month == 10 and day >= 2 and day <= 7 then
        reasons[#reasons+1] = "shawwal"
    end

    if #reasons > 0 then return true, reasons end
    return false, nil
end

local function translateReasons(reason_list, lang)
    local t = translations_table[lang] or translations_table.en
    local out = {}
    for _, key in ipairs(reason_list) do
        local tkey = fasting_reason_keys[key]
        out[#out+1] = (tkey and t[tkey]) or key
    end
    return table.concat(out, ", ")
end

local function getFastingReminders(settings, lang)
    local disp = settings and settings.display
    if not disp or not disp.show_fasting_days then return {} end

    local cfg = disp.fasting_days or {}
    local advance = tonumber(disp.fasting_reminder_days) or 1
    if advance < 0 then advance = 0 end
    if advance > 2 then advance = 2 end
    local hijri_adj = disp.hijri_adjustment or 0

    -- Determine local time offset (timezone + dst_offset)
    local loc = settings.location or {}
    local base_tz = tonumber(loc.timezone) or 0
    local dst = tonumber(loc.dst_offset) or 0
    local utc_offset = base_tz + dst

    local now = os.time()
    local local_now = now + utc_offset * 3600

    local reminders = {}

    for ahead = 0, advance do
        local check_time = local_now + (ahead * 86400)
        local d = os.date("*t", check_time)
        local weekday = os.date("%A", check_time)
        local h = Hijri:gregorianToHijri(d.year, d.month, d.day, hijri_adj)
        local is_fasting, reason_list = checkFastingForDate(h, weekday, cfg)
        if is_fasting then
            reminders[#reminders+1] = {
                days_ahead = ahead,
                reason = translateReasons(reason_list, lang),
            }
        end
    end

    return reminders
end

return {
    getFastingReminders = getFastingReminders,
    checkFastingForDate = checkFastingForDate,
    translateReasons = translateReasons,
}