-- calculation.lua
local methods = {
    MWL       = { fajr = 18,   isha = 17 },
    Egyptian  = { fajr = 19.5, isha = 17.5 },
    UmmAlQura = { fajr = 18.5, isha = "90min" },
    Karachi   = { fajr = 18,   isha = 18 },
    ISNA      = { fajr = 15,   isha = 15 },
    Jafari    = { fajr = 16,   isha = 14 },
    Tehran    = { fajr = 17.7, isha = 14 },
}

local function deg2rad(d) return d * math.pi / 180 end
local function rad2deg(r) return r * 180 / math.pi end

local function julian(year, month, day)
    if month <= 2 then year = year - 1; month = month + 12 end
    local A = math.floor(year / 100)
    local B = 2 - A + math.floor(A / 4)
    return math.floor(365.25 * (year + 4716))
         + math.floor(30.6001 * (month + 1)) + day + B - 1524.5
end

local function sunPosition(jd)
    local D = jd - 2451545.0
    local g = deg2rad((357.529 + 0.98560028 * D) % 360)
    local q = deg2rad((280.459 + 0.98564736 * D) % 360)
    local L = deg2rad((rad2deg(q) + 1.915 * math.sin(g) + 0.020 * math.sin(2 * g)) % 360)
    local e = deg2rad(23.439 - 0.00000036 * D)
    local RA = rad2deg(math.atan2(math.cos(e) * math.sin(L), math.cos(L))) / 15
    RA = RA % 24
    local decl = rad2deg(math.asin(math.sin(e) * math.sin(L)))
    local EqT = rad2deg(q) / 15 - RA
    return decl, EqT
end

local function hourAngleDepression(decl, lat, angle)
    local latRad, declRad = deg2rad(lat), deg2rad(decl)
    local cosHA = (math.sin(deg2rad(-angle)) - math.sin(latRad) * math.sin(declRad))
                / (math.cos(latRad) * math.cos(declRad))
    cosHA = math.max(-1, math.min(1, cosHA))
    return rad2deg(math.acos(cosHA)) / 15
end

local function hourAngleElevation(decl, lat, angle)
    local latRad, declRad = deg2rad(lat), deg2rad(decl)
    local cosHA = (math.sin(deg2rad(angle)) - math.sin(latRad) * math.sin(declRad))
                / (math.cos(latRad) * math.cos(declRad))
    cosHA = math.max(-1, math.min(1, cosHA))
    return rad2deg(math.acos(cosHA)) / 15
end

local function calculateTimes(year, month, day, lat, lng, tz, method_key, asr_madhhab)
    local jd = julian(year, month, day)
    local decl, eqT = sunPosition(jd)
    local method = methods[method_key] or methods.Egyptian

    local dhuhr   = 12 + tz - lng / 15 - eqT
    local sunrise = dhuhr - hourAngleDepression(decl, lat, 0.833)
    local maghrib = dhuhr + hourAngleDepression(decl, lat, 0.833)

    local fajr_val, isha_val
    if method.isha == "90min" then
        isha_val = maghrib + 1.5
        fajr_val = dhuhr - hourAngleDepression(decl, lat, method.fajr)
    else
        fajr_val = dhuhr - hourAngleDepression(decl, lat, method.fajr)
        isha_val = dhuhr + hourAngleDepression(decl, lat, method.isha)
    end

    local asr_factor = (asr_madhhab == "Hanafi") and 2 or 1
    local A_rad = math.atan(1 / (math.tan(deg2rad(math.abs(lat - decl))) + asr_factor))
    local asr_val = dhuhr + hourAngleElevation(decl, lat, rad2deg(A_rad))

    local function fmt(time)
        time = time % 24
        if time < 0 then time = time + 24 end
        local h = math.floor(time)
        local m = math.floor((time - h) * 60 + 0.5)
        if m == 60 then m = 0; h = h + 1 end
        if h >= 24 then h = h - 24 end
        return string.format("%02d:%02d", h, m)
    end

    return {
        fajr    = fmt(fajr_val),
        sunrise = fmt(sunrise),
        dhuhr   = fmt(dhuhr),
        asr     = fmt(asr_val),
        maghrib = fmt(maghrib),
        isha    = fmt(isha_val),
    }
end

local Hijri = {}

local hijri_month_names_en = {
    "Muharram", "Safar", "Rabi al Awwal", "Rabi al Thani",
    "Jumada al Awwal", "Jumada al Thani", "Rajab", "Shaban",
    "Ramadan", "Shawwal", "Dhu al Qidah", "Dhu al Hijjah",
}

local hijri_month_names_ar = {
    "محرم", "صفر", "ربيع الأول", "ربيع الثاني",
    "جمادى الأولى", "جمادى الآخرة", "رجب", "شعبان",
    "رمضان", "شوال", "ذو القعدة", "ذو الحجة",
}

function Hijri:gregorianToJulian(year, month, day)
    if month <= 2 then year = year - 1; month = month + 12 end
    local A = math.floor(year / 100)
    local B = 2 - A + math.floor(A / 4)
    return math.floor(365.25 * (year + 4716))
         + math.floor(30.6001 * (month + 1)) + day + B - 1524.5
end

function Hijri:isLeapHijri(year)
    local leap = { 2, 5, 7, 10, 13, 16, 18, 21, 24, 26, 29 }
    local r = year % 30
    for _, v in ipairs(leap) do
        if r == v then return true end
    end
    return false
end

function Hijri:gregorianToHijri(g_year, g_month, g_day, adjustment)
    adjustment = tonumber(adjustment) or 0
    local jd = self:gregorianToJulian(g_year, g_month, g_day) + adjustment
    local days_since_epoch = jd - 1948439.5
    local hijri_year = math.floor(days_since_epoch / 354.3667) + 1
    local remainder = days_since_epoch - math.floor((hijri_year - 1) * 354.3667)

    local month_lengths = { 30, 29, 30, 29, 30, 29, 30, 29, 30, 29, 30, 29 }
    if self:isLeapHijri(hijri_year) then month_lengths[12] = 30 end

    local hijri_month = 1
    while hijri_month <= 12 and remainder > month_lengths[hijri_month] do
        remainder = remainder - month_lengths[hijri_month]
        hijri_month = hijri_month + 1
    end
    if hijri_month > 12 then hijri_month = 12 end

    local hijri_day = math.floor(remainder) + 1
    if hijri_day < 1 then hijri_day = 1 end

    return {
        year  = hijri_year,
        month = hijri_month,
        day   = hijri_day,
        month_name_en = hijri_month_names_en[hijri_month],
        month_name_ar = hijri_month_names_ar[hijri_month],
    }
end

return {
    calculateTimes = calculateTimes,
    Hijri = Hijri,
    methods = methods,
}