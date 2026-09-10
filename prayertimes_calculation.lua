-- prayertimes_calculation.lua
--
-- Offline prayer-time calculation engine.
--
-- Astronomical basis:
--   Lightweight solar-position equations informed by commonly published
--   astronomical algorithms, including those described by Mohammad
--   Shawkat Odeh / International Astronomical Center (IAC).

local methods = {
    -- IAC Standard profile
    IACStandard = {
        fajr = {
            type = "angle",
            value = 18.0,
        },
        isha = {
            type = "latitude_angle",
            below_45 = 18.0,
            at_or_above_45 = 17.0,
        },
        verification = "documented_by_iac_accurate_times",
    },

    -- Muslim World League
    MWL = {
        fajr = {
            type = "angle",
            value = 18.0,
        },
        isha = {
            type = "angle",
            value = 17.0,
        },
        verification = "documented_by_iac_accurate_times",
    },

    -- Egyptian General Authority of Survey
    Egyptian = {
        fajr = {
            type = "angle",
            value = 19.5,
        },
        isha = {
            type = "angle",
            value = 17.5,
        },
        verification = "documented_by_iac_accurate_times",
    },

    -- Umm al-Qura
    UmmAlQura = {
        fajr = {
            type = "angle",
            value = 18.5,
        },
        isha = {
            type = "interval",
            normal_minutes = 90,
            ramadan_minutes = 120,
        },
        verification = "documented_by_iac_accurate_times",
    },

    -- University of Islamic Sciences, Karachi
    Karachi = {
        fajr = {
            type = "angle",
            value = 18.0,
        },
        isha = {
            type = "angle",
            value = 18.0,
        },
        verification = "documented_by_iac_accurate_times",
    },

    -- Islamic Society of North America
    ISNA = {
        fajr = {
            type = "angle",
            value = 15.0,
        },
        isha = {
            type = "angle",
            value = 15.0,
        },
        verification = "documented_by_iac_accurate_times",
    },

    -- Moroccan 19°/17° profile
    Moroccan = {
        fajr = {
            type = "angle",
            value = 19.0,
        },
        isha = {
            type = "angle",
            value = 17.0,
        },
        verification = "pending_primary_source_validation",
    },

    -- Tehran profile
    Tehran = {
        fajr = {
            type = "angle",
            value = 17.7,
        },
        maghrib = {
            type = "angle",
            value = 4.5,
        },
        isha = {
            type = "angle",
            value = 14.0,
        },
        verification = "commonly_published_parameters",
    },

    -- Jafari profile
    Jafari = {
        fajr = {
            type = "angle",
            value = 16.0,
        },
        maghrib = {
            type = "angle",
            value = 4.0,
        },
        isha = {
            type = "angle",
            value = 14.0,
        },
        verification = "commonly_published_parameters",
    },
}

local function deg2rad(degrees)
    return degrees * math.pi / 180
end

local function rad2deg(radians)
    return radians * 180 / math.pi
end

local function clamp(value, minimum, maximum)
    if value < minimum then
        return minimum
    end
    if value > maximum then
        return maximum
    end
    return value
end

local function isGregorianLeapYear(year)
    if year % 400 == 0 then
        return true
    end
    if year % 100 == 0 then
        return false
    end
    return year % 4 == 0
end

local function getGregorianMonthLength(year, month)
    local month_lengths = {
        31, 28, 31, 30, 31, 30,
        31, 31, 30, 31, 30, 31,
    }
    if month == 2 and isGregorianLeapYear(year) then
        return 29
    end
    return month_lengths[month]
end

local function validateGregorianDate(year, month, day)
    year = tonumber(year)
    month = tonumber(month)
    day = tonumber(day)

    if not year or not month or not day then
        return nil, nil, nil, "Invalid Gregorian date"
    end

    year = math.floor(year)
    month = math.floor(month)
    day = math.floor(day)

    if year < 1583 or year > 9999 then
        return nil, nil, nil, "Year must be between 1583 and 9999"
    end
    if month < 1 or month > 12 then
        return nil, nil, nil, "Month must be between 1 and 12"
    end

    local month_length = getGregorianMonthLength(year, month)
    if not month_length or day < 1 or day > month_length then
        return nil, nil, nil, "Day is invalid for the selected month"
    end

    return year, month, day, nil
end

local function gregorianToJulian(year, month, day)
    local y = year
    local m = month
    if m <= 2 then
        y = y - 1
        m = m + 12
    end
    local A = math.floor(y / 100)
    local B = 2 - A + math.floor(A / 4)
    return math.floor(365.25 * (y + 4716)) + math.floor(30.6001 * (m + 1)) + day + B - 1524.5
end

local function isLeapHijriYear(year)
    local remainder = year % 30
    return remainder == 2
        or remainder == 5
        or remainder == 7
        or remainder == 10
        or remainder == 13
        or remainder == 16
        or remainder == 18
        or remainder == 21
        or remainder == 24
        or remainder == 26
        or remainder == 29
end

local function islamicToJulian(year, month, day)
    return day
        + math.ceil(29.5 * (month - 1))
        + 354 * (year - 1)
        + math.floor((3 + 11 * year) / 30)
        + 1948439.5
        - 1
end

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

local Hijri = {}

function Hijri:gregorianToJulian(year, month, day)
    local valid_year, valid_month, valid_day, err = validateGregorianDate(year, month, day)
    if err then
        return nil, err
    end
    return gregorianToJulian(valid_year, valid_month, valid_day)
end

function Hijri:isLeapHijri(year)
    year = tonumber(year)
    if not year then
        return false
    end
    return isLeapHijriYear(math.floor(year))
end

function Hijri:gregorianToHijri(year, month, day, adjustment)
    local valid_year, valid_month, valid_day, err = validateGregorianDate(year, month, day)
    if err then
        return nil, err
    end

    adjustment = math.floor(tonumber(adjustment) or 0)
    local julian_day = gregorianToJulian(valid_year, valid_month, valid_day) + adjustment
    julian_day = math.floor(julian_day) + 0.5

    local hijri_year = math.floor((30 * (julian_day - 1948439.5) + 10646) / 10631)
    if hijri_year < 1 then
        hijri_year = 1
    end

    while hijri_year > 1 and julian_day < islamicToJulian(hijri_year, 1, 1) do
        hijri_year = hijri_year - 1
    end
    while julian_day >= islamicToJulian(hijri_year + 1, 1, 1) do
        hijri_year = hijri_year + 1
    end

    local hijri_month = 1
    while hijri_month < 12 and julian_day >= islamicToJulian(hijri_year, hijri_month + 1, 1) do
        hijri_month = hijri_month + 1
    end

    local hijri_day = math.floor(julian_day - islamicToJulian(hijri_year, hijri_month, 1)) + 1
    local maximum_day = 30
    if hijri_month % 2 == 0 then
        maximum_day = 29
    end
    if hijri_month == 12 and isLeapHijriYear(hijri_year) then
        maximum_day = 30
    end

    hijri_day = clamp(hijri_day, 1, maximum_day)

    return {
        year = hijri_year,
        month = hijri_month,
        day = hijri_day,
        month_name_en = hijri_month_names_en[hijri_month],
        month_name_ar = hijri_month_names_ar[hijri_month],
        calendar_type = "civil_tabular",
    }
end

local function sunPosition(julian_day)
    local D = julian_day - 2451545.0
    local mean_anomaly = deg2rad((357.529 + 0.98560028 * D) % 360)
    local mean_longitude_degrees = (280.459 + 0.98564736 * D) % 360
    local mean_longitude = deg2rad(mean_longitude_degrees)
    local ecliptic_longitude = deg2rad((mean_longitude_degrees + 1.915 * math.sin(mean_anomaly) + 0.020 * math.sin(2 * mean_anomaly)) % 360)
    local obliquity = deg2rad(23.439 - 0.00000036 * D)
    local right_ascension = rad2deg(math.atan2(math.cos(obliquity) * math.sin(ecliptic_longitude), math.cos(ecliptic_longitude))) / 15
    right_ascension = right_ascension % 24
    local declination = rad2deg(math.asin(math.sin(obliquity) * math.sin(ecliptic_longitude)))
    local equation_of_time = rad2deg(mean_longitude) / 15 - right_ascension
    equation_of_time = ((equation_of_time + 12) % 24) - 12
    return declination, equation_of_time
end

local function resolveEventAngle(event_definition, latitude)
    if type(event_definition) ~= "table" then
        return nil
    end
    if event_definition.type == "angle" then
        return tonumber(event_definition.value)
    end
    if event_definition.type == "latitude_angle" then
        if math.abs(latitude) >= 45 then
            return tonumber(event_definition.at_or_above_45)
        end
        return tonumber(event_definition.below_45)
    end
    return nil
end

local function calculateHourAngle(declination, latitude, depression_angle, horizon_drop_elevation)
    depression_angle = tonumber(depression_angle)
    if not depression_angle then
        return nil
    end

    local effective_elevation = math.max(0, tonumber(horizon_drop_elevation) or 0)
    local elevation_correction = 0.0347 * math.sqrt(effective_elevation)
    local actual_depression = depression_angle + elevation_correction

    local latitude_radians = deg2rad(latitude)
    local declination_radians = deg2rad(declination)
    local denominator = math.cos(latitude_radians) * math.cos(declination_radians)

    if math.abs(denominator) < 0.0000001 then
        return nil
    end

    local numerator = math.sin(deg2rad(-actual_depression)) - math.sin(latitude_radians) * math.sin(declination_radians)
    local cosine_hour_angle = numerator / denominator

    if cosine_hour_angle < -1 or cosine_hour_angle > 1 then
        return nil
    end
    return rad2deg(math.acos(cosine_hour_angle)) / 15
end

local function calculateSolarNoon(julian_day, longitude, timezone)
    local solar_noon = 12
    for _ = 1, 2 do
        local event_julian_day = julian_day + ((solar_noon - timezone) / 24)
        local _, equation_of_time = sunPosition(event_julian_day)
        if math.abs(equation_of_time) > 1 then
            return nil
        end
        solar_noon = 12 + timezone - longitude / 15 - equation_of_time
    end
    return solar_noon
end

local function calculateDepressionEvent(julian_day, latitude, longitude, timezone, depression_angle, is_morning, horizon_drop_elevation)
    local event_time = nil
    local solar_noon = calculateSolarNoon(julian_day, longitude, timezone)
    if not solar_noon then
        return nil
    end

    for _ = 1, 2 do
        local sample_time = event_time or solar_noon
        local event_julian_day = julian_day + ((sample_time - timezone) / 24)
        local declination, equation_of_time = sunPosition(event_julian_day)
        if math.abs(equation_of_time) > 1 then
            return nil
        end
        local event_solar_noon = 12 + timezone - longitude / 15 - equation_of_time
        local hour_angle = calculateHourAngle(declination, latitude, depression_angle, horizon_drop_elevation)
        if not hour_angle then
            return nil
        end
        if is_morning then
            event_time = event_solar_noon - hour_angle
        else
            event_time = event_solar_noon + hour_angle
        end
    end
    return event_time
end

local function calculateAsrTime(julian_day, latitude, longitude, timezone, shadow_factor)
    local solar_noon = calculateSolarNoon(julian_day, longitude, timezone)
    if not solar_noon then
        return nil
    end

    local asr_time = solar_noon + 3
    for _ = 1, 2 do
        local event_julian_day = julian_day + ((asr_time - timezone) / 24)
        local declination, equation_of_time = sunPosition(event_julian_day)
        if math.abs(equation_of_time) > 1 then
            return nil
        end
        local event_solar_noon = 12 + timezone - longitude / 15 - equation_of_time
        local altitude_angle = math.atan(1 / (shadow_factor + math.tan(deg2rad(math.abs(latitude - declination)))))
        local latitude_radians = deg2rad(latitude)
        local declination_radians = deg2rad(declination)
        local denominator = math.cos(latitude_radians) * math.cos(declination_radians)

        if math.abs(denominator) < 0.0000001 then
            return nil
        end

        local cosine_hour_angle = (math.sin(altitude_angle) - math.sin(latitude_radians) * math.sin(declination_radians)) / denominator
        if cosine_hour_angle < -1 or cosine_hour_angle > 1 then
            return nil
        end
        asr_time = event_solar_noon + rad2deg(math.acos(cosine_hour_angle)) / 15
    end
    return asr_time
end

local function normalizeAdjustments(adjustments)
    if type(adjustments) ~= "table" then
        adjustments = {}
    end
    return {
        fajr = tonumber(adjustments.fajr) or 0,
        sunrise = tonumber(adjustments.sunrise) or 0,
        dhuhr = tonumber(adjustments.dhuhr) or 0,
        asr = tonumber(adjustments.asr) or 0,
        maghrib = tonumber(adjustments.maghrib) or 0,
        isha = tonumber(adjustments.isha) or 0,
    }
end

local function getHighLatitudeEstimate(event_type, anchor_time, night_duration, rule, angle, fixed_minutes)
    if type(anchor_time) ~= "number" then
        return nil
    end

    local duration = nil
    if rule == "fixed_minutes" then
        duration = math.max(0, tonumber(fixed_minutes) or 90) / 60
    elseif type(night_duration) == "number" then
        if rule == "seventh" then
            duration = night_duration / 7
        elseif rule == "middle" then
            duration = night_duration / 2
        elseif rule == "angle_based" then
            local portion = clamp((tonumber(angle) or 18) / 60, 0, 1)
            duration = night_duration * portion
        end
    end

    if not duration then
        return nil
    end
    if event_type == "morning" then
        return anchor_time - duration
    end
    return anchor_time + duration
end

local function formatTime(decimal_time, adjustment_minutes)
    if type(decimal_time) ~= "number" then
        return "--:--"
    end

    local adjusted_time = decimal_time + (tonumber(adjustment_minutes) or 0) / 60
    adjusted_time = adjusted_time % 24
    if adjusted_time < 0 then
        adjusted_time = adjusted_time + 24
    end

    local hour = math.floor(adjusted_time)
    local minute = math.floor((adjusted_time - hour) * 60 + 0.5)
    if minute >= 60 then
        minute = minute - 60
        hour = hour + 1
    end
    if hour >= 24 then
        hour = hour - 24
    end

    return string.format("%02d:%02d", hour, minute)
end

local function calculateTimes(year, month, day, latitude, longitude, timezone, method_key, asr_madhhab, options)
    local valid_year, valid_month, valid_day, date_error = validateGregorianDate(year, month, day)
    if date_error then
        return nil, date_error
    end

    latitude = tonumber(latitude)
    longitude = tonumber(longitude)
    timezone = tonumber(timezone)

    if not latitude or not longitude or not timezone then
        return nil, "Invalid physical location parameters"
    end
    if latitude < -90 or latitude > 90 or longitude < -180 or longitude > 180 or timezone < -14 or timezone > 14 then
        return nil, "Parameters are outside physical range"
    end

    method_key = method_key or "Egyptian"
    local method = methods[method_key]
    if not method then
        return nil, "Unknown calculation method: " .. tostring(method_key)
    end

    if type(options) ~= "table" then
        options = {}
    end

    local adjustments = normalizeAdjustments(options.adjustments)
    local high_latitude_rule = options.high_latitude_rule or "none"
    local allowed_high_latitude_rules = {
        none = true, seventh = true, middle = true, angle_based = true, fixed_minutes = true,
    }
    if not allowed_high_latitude_rules[high_latitude_rule] then
        high_latitude_rule = "none"
    end

    local high_latitude_minutes = math.max(0, tonumber(options.high_latitude_minutes) or 90)
    local apply_elevation = options.apply_elevation == true
    local horizon_drop_elevation = 0
    if apply_elevation then
        horizon_drop_elevation = math.max(0, tonumber(options.horizon_drop_elevation) or 0)
    end

    local julian_day = gregorianToJulian(valid_year, valid_month, valid_day)
    local solar_noon = calculateSolarNoon(julian_day, longitude, timezone)
    if not solar_noon then
        return nil, "Unable to calculate solar noon"
    end

    local sunrise = calculateDepressionEvent(julian_day, latitude, longitude, timezone, 0.833, true, horizon_drop_elevation)
    local ordinary_sunset = calculateDepressionEvent(julian_day, latitude, longitude, timezone, 0.833, false, horizon_drop_elevation)

    local night_duration = nil
    if sunrise and ordinary_sunset then
        night_duration = 24 - (ordinary_sunset - sunrise)
        if night_duration <= 0 or night_duration > 24 then
            night_duration = nil
        end
    end

    local metadata = {
        method = method_key,
        verification = method.verification,
        high_latitude_rule = high_latitude_rule,
        elevation_applied = apply_elevation,
        horizon_drop_elevation = horizon_drop_elevation,
        events = {
            fajr = { status = "unavailable" },
            sunrise = { status = sunrise and "real" or "unavailable" },
            dhuhr = { status = "real" },
            asr = { status = "unavailable" },
            maghrib = { status = ordinary_sunset and "real" or "unavailable" },
            isha = { status = "unavailable" },
        },
    }

    local fajr_angle = resolveEventAngle(method.fajr, latitude)
    local fajr = nil
    if fajr_angle then
        fajr = calculateDepressionEvent(julian_day, latitude, longitude, timezone, fajr_angle, true, 0)
    end

    if fajr then
        metadata.events.fajr.status = "real"
        metadata.events.fajr.angle = fajr_angle
    elseif high_latitude_rule ~= "none" then
        fajr = getHighLatitudeEstimate("morning", sunrise, night_duration, high_latitude_rule, fajr_angle, high_latitude_minutes)
        if fajr then
            metadata.events.fajr.status = "estimated"
            metadata.events.fajr.estimation = high_latitude_rule
        end
    end

    local maghrib = ordinary_sunset
    if method.maghrib and method.maghrib.type == "angle" then
        local maghrib_angle = tonumber(method.maghrib.value)
        maghrib = calculateDepressionEvent(julian_day, latitude, longitude, timezone, maghrib_angle, false, 0)
        metadata.events.maghrib.status = maghrib and "real" or "unavailable"
        metadata.events.maghrib.angle = maghrib_angle
    end

    local isha = nil
    local isha_angle = nil

    if method.isha.type == "interval" then
        if maghrib then
            local is_ramadan = false
            local ramadan_detection
            if options.force_ramadan ~= nil then
                is_ramadan = options.force_ramadan == true
                ramadan_detection = "manual"
            else
                local hijri_date = Hijri:gregorianToHijri(valid_year, valid_month, valid_day, tonumber(options.hijri_adjustment) or 0)
                if hijri_date then
                    is_ramadan = hijri_date.month == 9
                end
                ramadan_detection = "civil_tabular_hijri"
            end

            local interval_minutes = is_ramadan and method.isha.ramadan_minutes or method.isha.normal_minutes
            interval_minutes = interval_minutes or 90
            isha = maghrib + interval_minutes / 60

            metadata.events.isha.status = "calculated_interval"
            metadata.events.isha.interval_minutes = interval_minutes
            metadata.events.isha.ramadan = is_ramadan
            metadata.ramadan_detection = ramadan_detection
        end
    else
        isha_angle = resolveEventAngle(method.isha, latitude)
        if isha_angle then
            isha = calculateDepressionEvent(julian_day, latitude, longitude, timezone, isha_angle, false, 0)
        end

        if isha then
            metadata.events.isha.status = "real"
            metadata.events.isha.angle = isha_angle
        elseif high_latitude_rule ~= "none" then
            isha = getHighLatitudeEstimate("evening", maghrib, night_duration, high_latitude_rule, isha_angle, high_latitude_minutes)
            if isha then
                metadata.events.isha.status = "estimated"
                metadata.events.isha.estimation = high_latitude_rule
            end
        end
    end

    local shadow_factor = asr_madhhab == "Hanafi" and 2 or 1
    local asr = calculateAsrTime(julian_day, latitude, longitude, timezone, shadow_factor)
    if asr then
        metadata.events.asr.status = "real"
    end
    metadata.events.asr.shadow_factor = shadow_factor

    if not sunrise and not ordinary_sunset then
        local declination = select(1, sunPosition(julian_day + 0.5))
        local solar_altitude_at_noon = 90 - math.abs(latitude - declination)
        if solar_altitude_at_noon > 0 then
            metadata.solar_condition = "sun_always_up"
        else
            metadata.solar_condition = "sun_always_down"
        end
    elseif not fajr or not isha then
        metadata.solar_condition = "twilight_event_unavailable"
    else
        metadata.solar_condition = "normal"
    end

    return {
        fajr = formatTime(fajr, adjustments.fajr),
        sunrise = formatTime(sunrise, adjustments.sunrise),
        dhuhr = formatTime(solar_noon, adjustments.dhuhr),
        asr = formatTime(asr, adjustments.asr),
        maghrib = formatTime(maghrib, adjustments.maghrib),
        isha = formatTime(isha, adjustments.isha),
        _meta = metadata,
    }
end

return {
    calculateTimes = calculateTimes,
    Hijri = Hijri,
    methods = methods,
}