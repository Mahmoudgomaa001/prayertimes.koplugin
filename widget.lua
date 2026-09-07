-- widget.lua
local utils = require("utils")
local defaults = require("defaults")
local translations = require("translations")
local calculation = require("calculation")
local fasting = require("fasting")

local DEFAULTS = defaults.DEFAULTS
local LAYOUT_MATRIX = defaults.LAYOUT_MATRIX
local translations_table = translations.translations
local arabic_day_names = translations.arabic_day_names
local arabic_month_names = translations.arabic_month_names
local calculateTimes = calculation.calculateTimes
local Hijri = calculation.Hijri
local getFastingReminders = fasting.getFastingReminders

local InputContainer = utils.InputContainer
local FrameContainer = utils.FrameContainer
local TextBoxWidget = utils.TextBoxWidget
local TextWidget = utils.TextWidget
local ImageWidget = utils.ImageWidget
local VerticalGroup = utils.VerticalGroup
local HorizontalGroup = utils.HorizontalGroup
local VerticalSpan = utils.VerticalSpan
local HorizontalSpan = utils.HorizontalSpan
local CenterContainer = utils.CenterContainer
local LeftContainer = utils.LeftContainer
local RightContainer = utils.RightContainer
local LineWidget = utils.LineWidget
local Font = utils.Font
local Geom = utils.Geom
local GestureRange = utils.GestureRange
local Blitbuffer = utils.Blitbuffer
local Screen = utils.Screen
local UIManager = utils.UIManager
local logger = utils.logger
local InfoMessage = utils.InfoMessage

local Button = require("ui/widget/button")
local OverlapGroup = require("ui/widget/overlapgroup")

local safeFace = utils.safeFace
local getBatteryText = utils.getBatteryText
local getWifiText = utils.getWifiText
local getMemoryText = utils.getMemoryText
local loadImage = utils.loadImage
local interp = utils.interp
local getActiveLayout = utils.getActiveLayout
local makeFixedCell = utils.makeFixedCell

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

local PrayerTimesWidget = InputContainer:extend{}

function PrayerTimesWidget:init()
    self.covers_fullscreen = true
    local disp = (self.props and self.props.settings and self.props.settings.display) or {}
    self.lang = disp.language or "en"
    self.is_ar = (self.lang == "ar")
    self.layout, self.is_mirrored = getActiveLayout(self.is_ar)
    self.time_format = disp.time_format or 24
    self.next_prayer_timestamp = (self.props.next_prayer and self.props.next_prayer.timestamp) or nil

    self.is_preview = (self.props.preview_font ~= nil)
    self.show_controls = self.is_preview  -- show overlay initially in preview

    if self.is_preview then
        self.body_face = self.props.preview_font
        self.font_offset = self.props.preview_offset or 0
        self.all_fonts = self.props.all_fonts or {}
        self.current_font_index = self.props.current_index or 1

        self.ges_events.Tap = {
            GestureRange:new{
                ges = "tap",
                range = Geom:new{ x = 0, y = 0, w = Screen:getWidth(), h = Screen:getHeight() },
            },
        }
        self.ges_events.Swipe = {
            GestureRange:new{
                ges = "swipe",
                range = Geom:new{ x = 0, y = 0, w = Screen:getWidth(), h = Screen:getHeight() },
                direction = "south",
            },
        }
    else
        self.ges_events.TapClose = {
            GestureRange:new{
                ges = "tap",
                range = Geom:new{ x = 0, y = 0, w = Screen:getWidth(), h = Screen:getHeight() },
            },
        }
        utils.ensureFontsDirRegistered()
        local custom = disp.custom_font_path
        if type(custom) == "string" and custom ~= "" then
            self.body_face = custom:match("([^/\\]+)$") or custom
        else
            self.body_face = disp.font_face or DEFAULTS.default_face
        end
        local font_key = getFontKey(disp)
        local saved = getSavedFontOffset(disp, font_key, self.lang)
        local default_offset = DEFAULTS.settings["font_size_offset_"..self.lang] or 0
        self.font_offset = saved or default_offset
    end

    local ok, err = pcall(function()
        self:render()
    end)
    if not ok then
        logger.warn("PrayerTimes render error:", err)
        self[1] = FrameContainer:new{
            TextBoxWidget:new{
                text = tostring(err),
                face = safeFace(nil, 18),
                width = Screen:getWidth() - Screen:scaleBySize(40),
                alignment = "center",
            },
            width = Screen:getWidth(),
            height = Screen:getHeight(),
            background = Blitbuffer.COLOR_WHITE,
            padding = Screen:scaleBySize(20),
        }
    end

    if not self.is_preview then
        pcall(function()
            UIManager:setDirty("all", "flashpartial")
            self:setupScheduling()
            self:applyWidgetBrightness()
        end)
    else
        UIManager:setDirty("all", "flashpartial")
    end
end

function PrayerTimesWidget:onTap()
    if self.is_preview then
        self.show_controls = not self.show_controls
        self:refresh()
        return true
    end
end

function PrayerTimesWidget:onSwipe(arg, ges)
    if self.is_preview and ges and ges.direction == "south" then
        self:closePreview()
        return true
    end
end

function PrayerTimesWidget:onTapClose()
    if self.is_preview then return end
    self:closePreview()
end
PrayerTimesWidget.onAnyKeyPressed = PrayerTimesWidget.onTapClose

function PrayerTimesWidget:closePreview()
    self.is_closing = true
    self:unscheduleTimers()
    UIManager:close(self)
    -- Force full refresh shortly after closing
    UIManager:scheduleIn(0.1, function()
        UIManager:setDirty("all", "full")
    end)
end

function PrayerTimesWidget:unscheduleTimers()
    if self.refresh_timer then
        pcall(UIManager.unschedule, UIManager, self.refresh_timer)
        self.refresh_timer = nil
    end
    if self.alert_timer then
        pcall(UIManager.unschedule, UIManager, self.alert_timer)
        self.alert_timer = nil
    end
end

function PrayerTimesWidget:t(key)
    local tbl = translations_table[self.lang] or translations_table.en
    return tbl[key] or translations_table.en[key] or key
end

function PrayerTimesWidget:formatTime(time_str)
    if type(time_str) ~= "string" then return "--:--" end
    if self.time_format == 12 then
        local h, m = time_str:match("(%d+):(%d+)")
        h = tonumber(h) or 0
        local h12 = h % 12
        if h12 == 0 then h12 = 12 end
        return string.format("%d:%02d", h12, tonumber(m) or 0)
    end
    return time_str
end

function PrayerTimesWidget:getSuffix(time_str)
    if self.time_format == 12 and type(time_str) == "string" then
        local h = tonumber(time_str:match("(%d+):")) or 0
        return (h >= 12) and self:t("pm") or self:t("am")
    end
    return ""
end

function PrayerTimesWidget:getAdjustedNow()
    local loc = self.props.settings.location or {}
    local utc_offset = (loc.timezone or 0) + (loc.dst_offset or 0)
    return os.time() + utc_offset * 3600
end

function PrayerTimesWidget:setupScheduling()
    if self.is_preview then return end
    local mode = self.props.settings.display.clock_mode

    if mode == "live" then
        local secs = tonumber(os.date("%S")) or 0
        self.refresh_timer = UIManager:scheduleIn(60 - secs, function()
            if not self.is_closing then
                self:refresh()
                self:setupScheduling()
            end
        end)
    elseif mode == "prayer" and self.next_prayer_timestamp then
        local delay = self.next_prayer_timestamp - os.time()
        if delay > 0 then
            self.refresh_timer = UIManager:scheduleIn(delay, function()
                if not self.is_closing then
                    self:refresh()
                    self:setupScheduling()
                end
            end)
        end
    end

    if self.next_prayer_timestamp then
        local delay = self.next_prayer_timestamp - os.time()
        if delay > 0 then
            self.alert_timer = UIManager:scheduleIn(delay, function()
                if not self.is_closing then
                    self:triggerAlert()
                end
            end)
        end
    end
end

function PrayerTimesWidget:refresh()
    local ok, err = pcall(function()
        self:render()
        UIManager:setDirty("all", "ui")
    end)
    if not ok then logger.warn("PrayerTimes refresh error:", err) end
end

function PrayerTimesWidget:triggerAlert()
    pcall(function()
        local alerts = self.props.settings.alerts or {}
        local np = self.props.next_prayer
        if alerts.flash then
            UIManager:setDirty("all", "flashui")
            UIManager:scheduleIn(1, function() UIManager:setDirty("all", "flashui") end)
        end
        if alerts.message and np then
            UIManager:show(InfoMessage:new{
                text = self:t("next_prayer_label") .. " " .. tostring(np.name),
                timeout = 5,
            })
        end
        self:refresh()
    end)
end

function PrayerTimesWidget:applyWidgetBrightness()
    if self.is_preview then return end
    local level = self.props.settings.widget_brightness
    if type(level) == "number" and level >= 0 then
        local ok, powerd = pcall(Device.getPowerDevice, Device)
        if ok and powerd and powerd.setIntensity then
            if powerd.getIntensity then
                local ok2, cur = pcall(powerd.getIntensity, powerd)
                if ok2 then self.original_brightness = cur end
            end
            pcall(powerd.setIntensity, powerd, level)
        end
    end
end

function PrayerTimesWidget:restoreWidgetBrightness()
    if self.is_preview then return end
    if self.original_brightness then
        local ok, powerd = pcall(Device.getPowerDevice, Device)
        if ok and powerd and powerd.setIntensity then
            pcall(powerd.setIntensity, powerd, self.original_brightness)
        end
        self.original_brightness = nil
    end
end

function PrayerTimesWidget:render()
    local L    = self.layout
    local t    = translations_table[self.lang] or translations_table.en
    local disp = self.props.settings.display or {}
    local times = self.props.times or {}
    local next_prayer = self.props.next_prayer
    local hijri = self.props.hijri
    local location_name = self.props.location_name or ""
    local off = self.font_offset
    local bf  = self.body_face

    local screen_size   = Screen:getSize()
    local margin        = Screen:scaleBySize(DEFAULTS.spacing.margin)
    local content_width = screen_size.w - (margin * 2)
    local adjusted_now  = self:getAdjustedNow()

    local function alignOf(name) return L[name .. "_align"] or "center" end

    local next_key = next_prayer and next_prayer.key or nil

    local banner_h = Screen:scaleBySize(DEFAULTS.spacing.banner_height)
    local top_w    = loadImage("top.png", content_width, banner_h)
    local bottom_w = loadImage("bottom.png", content_width, banner_h)

    local title_text = t.prayer_times
    if location_name ~= "" then
        title_text = string.format("%s (%s)", t.prayer_times, location_name)
    end
    local title_w = TextBoxWidget:new{
        text = title_text,
        face = safeFace(bf, DEFAULTS.fonts.title + off),
        width = content_width,
        alignment = alignOf("title"),
        para_direction_rtl = self.is_ar,
        auto_para_direction = true,
    }

    local clock_w
    do
        local raw = os.date("%H:%M", adjusted_now)
        local txt = self:formatTime(raw)
        local suf = self:getSuffix(raw)
        if suf ~= "" then txt = txt .. " " .. suf end
        clock_w = TextBoxWidget:new{
            text = txt,
            face = safeFace(bf, DEFAULTS.fonts.clock + off),
            width = content_width,
            alignment = alignOf("clock"),
            para_direction_rtl = self.is_ar,
            auto_para_direction = true,
        }
    end

    local combined_date_w
    do
        local en_day   = os.date("%A", adjusted_now)
        local en_month = os.date("%B", adjusted_now)
        local day_name  = en_day
        local greg_month = en_month
        if self.is_ar then
            day_name   = arabic_day_names[en_day] or en_day
            greg_month = arabic_month_names[en_month] or en_month
        end
        local greg_day  = os.date("%d", adjusted_now)
        local greg_year = os.date("%Y", adjusted_now)
        local dsep = L.dsep_text or ","

        local greg_str = string.format("%s%s %s %s %s",
            day_name, dsep, greg_day, greg_month, greg_year)

        local combined = greg_str
        if hijri then
            local hname = self.is_ar
                and (hijri.month_name_ar or tostring(hijri.month))
                or  (hijri.month_name_en or tostring(hijri.month))
            local suffix = self.is_ar and "هـ" or "AH"
            local hijri_str = string.format("%d %s %d %s",
                hijri.day, hname, hijri.year, suffix)
            combined = greg_str .. (L.date_divider_text or " | ") .. hijri_str
        end

        combined_date_w = TextBoxWidget:new{
            text = combined,
            face = safeFace(bf, DEFAULTS.fonts.date + off),
            width = content_width,
            alignment = alignOf("combined_date"),
            para_direction_rtl = self.is_ar,
            auto_para_direction = true,
        }
    end

    local fasting_w
    do
        local reminders = getFastingReminders(self.props.settings, self.lang)
        if #reminders > 0 then
            local lines = {}
            for _, r in ipairs(reminders) do
                local key
                if r.days_ahead == 0 then key = "fasting_today"
                elseif r.days_ahead == 1 then key = "fasting_tomorrow"
                elseif r.days_ahead == 2 then key = "fasting_in_2_days" end
                if key then
                    lines[#lines+1] = interp(self:t(key), r.reason)
                end
            end
            if #lines > 0 then
                fasting_w = TextBoxWidget:new{
                    text = table.concat(lines, "\n"),
                    face = safeFace(bf, DEFAULTS.fonts.fasting + off),
                    width = content_width,
                    alignment = "center",
                    para_direction_rtl = self.is_ar,
                    auto_para_direction = true,
                }
            end
        end
    end

    local countdown_w
    if next_prayer and next_prayer.timestamp then
        local remaining = next_prayer.timestamp - os.time()
        if remaining > 0 then
            local hours = math.floor(remaining / 3600)
            local minutes = math.floor((remaining % 3600) / 60)
            local parts = {}
            if hours > 0 then
                parts[#parts+1] = string.format("%d %s", hours, t.hours_short)
            end
            if minutes > 0 or hours == 0 then
                parts[#parts+1] = string.format("%d %s", minutes, t.minutes_short)
            end
            local cd_text = string.format("%s %s %s %s",
                t.next_prayer_label, next_prayer.name, t.in_word, table.concat(parts, " "))
            countdown_w = TextBoxWidget:new{
                text = cd_text,
                face = safeFace(bf, DEFAULTS.fonts.countdown + off),
                width = content_width,
                alignment = alignOf("countdown"),
                para_direction_rtl = self.is_ar,
                auto_para_direction = true,
            }
        end
    end

    local status_w
    do
        local show = {
            battery = disp.show_battery,
            wifi    = disp.show_wifi,
            memory  = disp.show_memory,
        }
        if show.battery or show.wifi or show.memory then
            local cell_width = math.floor(content_width / 3)
            local cell_h     = Screen:scaleBySize(24 + off)
            local status_font = DEFAULTS.fonts.status + off

            local wifi_raw = getWifiText()
            local wifi_text = t.na
            if wifi_raw == "on" then
                wifi_text = t.wifi_on
            elseif wifi_raw == "off" then
                wifi_text = t.wifi_off
            elseif wifi_raw and wifi_raw ~= "" then
                wifi_text = wifi_raw
            end

            local values = {
                battery = getBatteryText(disp.battery_format or "both") or t.na,
                wifi    = wifi_text,
                memory  = getMemoryText() or t.na,
            }

            local function buildCell(key)
                local label = t["status_" .. key] or key
                local value = values[key] or t.na
                local label_w = math.floor(cell_width * 0.48)
                local sep_w   = math.floor(cell_width * 0.06)
                local val_w   = math.floor(cell_width * 0.42)

                local map = {
                    label = makeFixedCell(label, status_font, label_w, cell_h, bf),
                    value = makeFixedCell(value, status_font, val_w,   cell_h, bf),
                }

                local children = {}
                for _, tok in ipairs(L.status_cell_order) do
                    if tok == "label" then
                        children[#children+1] = map.label
                    elseif tok == "value" then
                        children[#children+1] = map.value
                    elseif tok == "ssep" then
                        local s = L.ssep_text
                        if s and s ~= "" then
                            children[#children+1] =
                                makeFixedCell(s, status_font, sep_w, cell_h, bf)
                        end
                    end
                end

                return CenterContainer:new{
                    dimen = Geom:new{ w = cell_width, h = cell_h },
                    HorizontalGroup:new(children),
                }
            end

            local visible_cells = {}
            for _, key in ipairs(L.status_row) do
                if show[key] then
                    visible_cells[#visible_cells+1] = buildCell(key)
                end
            end

            if #visible_cells > 0 then
                local row = HorizontalGroup:new(visible_cells)
                status_w = CenterContainer:new{
                    dimen = Geom:new{ w = content_width, h = cell_h },
                    row,
                }
            end
        end
    end

    local function buildPrayerRow(label, time_str, icon_file, row_width, is_next)
        local icon_size = Screen:scaleBySize(DEFAULTS.icon_size)
        local row_gap   = Screen:scaleBySize(DEFAULTS.spacing.prayer_row_gap)

        local prayer_font = DEFAULTS.fonts.prayer + off
        if is_next then
            prayer_font = prayer_font + DEFAULTS.fonts.prayer_next_extra
        end
        local suffix_font = DEFAULTS.fonts.suffix + off

        local text_h = Screen:scaleBySize(prayer_font + 8)
        local row_h  = math.max(icon_size, text_h)
                     + Screen:scaleBySize(DEFAULTS.spacing.prayer_row_pad)

        local col_icon   = icon_size
        local col_label  = math.floor(row_width * DEFAULTS.prayer_columns.label_ratio)
        local col_time   = math.floor(row_width * DEFAULTS.prayer_columns.time_ratio)
        local col_suffix = math.floor(row_width * DEFAULTS.prayer_columns.suffix_ratio)
        local col_sep    = Screen:scaleBySize(DEFAULTS.spacing.separator_width)

        local icon_img = loadImage(icon_file, icon_size, icon_size)

        local map = {
            icon = icon_img
                and CenterContainer:new{
                        dimen = Geom:new{ w = col_icon, h = row_h },
                        icon_img,
                    }
                or HorizontalSpan:new{ width = col_icon },
            plabel = makeFixedCell(label, prayer_font, col_label, row_h, bf),
            ptime  = makeFixedCell(self:formatTime(time_str), prayer_font, col_time, row_h, bf),
        }

        local suf = self:getSuffix(time_str)
        if suf ~= "" then
            map.psuffix = makeFixedCell(suf, suffix_font, col_suffix, row_h, bf)
        end

        local children = {}
        for _, tok in ipairs(L.prayer_row) do
            if map[tok] then
                if #children > 0 then
                    children[#children+1] = HorizontalSpan:new{ width = row_gap }
                end
                children[#children+1] = map[tok]
            else
                local sep_text = L[tok .. "_text"]
                if sep_text and sep_text ~= "" then
                    children[#children+1] = HorizontalSpan:new{ width = col_sep }
                end
            end
        end

        local hg  = HorizontalGroup:new(children)
        local dim = Geom:new{ w = row_width, h = row_h }
        local a   = alignOf("prayer")

        if a == "left" then
            return LeftContainer:new{ dimen = dim, hg }
        elseif a == "right" then
            return RightContainer:new{ dimen = dim, hg }
        end
        return CenterContainer:new{ dimen = dim, hg }
    end

    local vgroup = VerticalGroup:new{}

    local function addBlock(w, is_divider)
        if not w then return end
        if #vgroup > 0 and not is_divider then
            vgroup[#vgroup+1] =
                VerticalSpan:new{ width = Screen:scaleBySize(DEFAULTS.spacing.row_gap) }
        end
        vgroup[#vgroup+1] = w
    end

    local function addDivider()
        addBlock(LineWidget:new{
            background = Blitbuffer.COLOR_LIGHT_GRAY,
            dimen = Geom:new{ w = content_width, h = 1 },
        }, true)
    end

    local prayer_defs = {
        { key = "fajr",    file = "fajr.png" },
        { key = "sunrise", file = "sunrise.png" },
        { key = "dhuhr",   file = "dhuhr.png" },
        { key = "asr",     file = "asr.png" },
        { key = "maghrib", file = "maghrib.png" },
        { key = "isha",    file = "isha.png" },
    }

    if top_w then
        vgroup[#vgroup+1] = top_w
        vgroup[#vgroup+1] =
            VerticalSpan:new{ width = Screen:scaleBySize(DEFAULTS.spacing.banner_spacing) }
    end

    for _, el in ipairs(L.header_order) do
        if el == "title" then
            addBlock(title_w)
        elseif el == "clockline" then
            addBlock(clock_w)
        elseif el == "combined_date_line" then
            addBlock(combined_date_w)
        elseif el == "fastingline" then
            addBlock(fasting_w)
        elseif el == "statusline" then
            addBlock(status_w)
        elseif el == "divider" then
            addDivider()
        elseif el == "prayers" then
            for i, p in ipairs(prayer_defs) do
                addBlock(buildPrayerRow(
                    t[p.key] or p.key,
                    times[p.key] or "--:--",
                    p.file,
                    content_width,
                    p.key == next_key))
                if i < #prayer_defs then addDivider() end
            end
        elseif el == "countdownline" then
            addBlock(countdown_w)
        end
    end

    if bottom_w then
        vgroup[#vgroup+1] =
            VerticalSpan:new{ width = Screen:scaleBySize(DEFAULTS.spacing.banner_spacing) }
        vgroup[#vgroup+1] = bottom_w
    end

    -- Build the main frame
    local main_frame = FrameContainer:new{
        vgroup,
        width = screen_size.w,
        height = screen_size.h,
        background = Blitbuffer.COLOR_WHITE,
        padding = margin,
    }

    if self.is_preview then
        if self.show_controls then
            local parent_widget = self

            local btn_prev = Button:new{
                text = "◀",
                width = Screen:scaleBySize(60),
                callback = function()
                    if #parent_widget.all_fonts > 0 then
                        parent_widget.current_font_index = parent_widget.current_font_index - 1
                        if parent_widget.current_font_index < 1 then
                            parent_widget.current_font_index = #parent_widget.all_fonts
                        end
                        local f = parent_widget.all_fonts[parent_widget.current_font_index]
                        parent_widget.body_face = f.key
                        local saved = getSavedFontOffset(parent_widget.props.settings.display, f.key, parent_widget.lang)
                        parent_widget.font_offset = saved or DEFAULTS.settings["font_size_offset_"..parent_widget.lang]
                        parent_widget:refresh()
                    end
                end,
            }
            local btn_next = Button:new{
                text = "▶",
                width = Screen:scaleBySize(60),
                callback = function()
                    if #parent_widget.all_fonts > 0 then
                        parent_widget.current_font_index = parent_widget.current_font_index + 1
                        if parent_widget.current_font_index > #parent_widget.all_fonts then
                            parent_widget.current_font_index = 1
                        end
                        local f = parent_widget.all_fonts[parent_widget.current_font_index]
                        parent_widget.body_face = f.key
                        local saved = getSavedFontOffset(parent_widget.props.settings.display, f.key, parent_widget.lang)
                        parent_widget.font_offset = saved or DEFAULTS.settings["font_size_offset_"..parent_widget.lang]
                        parent_widget:refresh()
                    end
                end,
            }
            local btn_minus = Button:new{
                text = "−",
                width = Screen:scaleBySize(60),
                callback = function()
                    parent_widget.font_offset = parent_widget.font_offset - 1
                    parent_widget:refresh()
                end,
            }
            local offset_text = TextWidget:new{
                text = tostring(parent_widget.font_offset),
                face = safeFace(nil, 20),
            }
            local btn_plus = Button:new{
                text = "+",
                width = Screen:scaleBySize(60),
                callback = function()
                    parent_widget.font_offset = parent_widget.font_offset + 1
                    parent_widget:refresh()
                end,
            }
            local btn_apply = Button:new{
                text = self:t("apply"),
                width = Screen:scaleBySize(120),
                callback = function()
                    if parent_widget.props.on_apply_font then
                        local f = parent_widget.all_fonts[parent_widget.current_font_index]
                        parent_widget.props.on_apply_font(parent_widget.font_offset, f.key, f.is_builtin, parent_widget.lang)
                    end
                    UIManager:show(InfoMessage:new{
                        text = self:t("font_applied"),
                        timeout = 1,
                    })
                end,
            }
            local btn_cancel = Button:new{
                text = self:t("cancel"),
                width = Screen:scaleBySize(120),
                callback = function()
                    parent_widget:closePreview()
                end,
            }
            local btn_hide = Button:new{
                text = "✕",
                width = Screen:scaleBySize(40),
                callback = function()
                    parent_widget.show_controls = false
                    parent_widget:refresh()
                end,
            }

            local current_font_name = ""
            if parent_widget.all_fonts[parent_widget.current_font_index] then
                current_font_name = parent_widget.all_fonts[parent_widget.current_font_index].display
            end
            local font_name_text = TextWidget:new{
                text = current_font_name,
                face = safeFace(nil, 18),
                max_width = content_width,
            }

            local font_name_bg = FrameContainer:new{
                background = Blitbuffer.COLOR_WHITE,
                dimen = Geom:new{ w = content_width, h = Screen:scaleBySize(30) },
                font_name_text,
            }

            local controls = HorizontalGroup:new{
                btn_prev,
                HorizontalSpan:new{ width = Screen:scaleBySize(5) },
                btn_next,
                HorizontalSpan:new{ width = Screen:scaleBySize(10) },
                btn_minus,
                HorizontalSpan:new{ width = Screen:scaleBySize(5) },
                offset_text,
                HorizontalSpan:new{ width = Screen:scaleBySize(5) },
                btn_plus,
                HorizontalSpan:new{ width = Screen:scaleBySize(15) },
                btn_apply,
                HorizontalSpan:new{ width = Screen:scaleBySize(5) },
                btn_cancel,
                HorizontalSpan:new{ width = Screen:scaleBySize(5) },
                btn_hide,
            }

            local overlay_content = VerticalGroup:new{
                font_name_bg,
                CenterContainer:new{
                    dimen = Geom:new{ w = content_width, h = Screen:scaleBySize(60) },
                    controls,
                },
            }

            local controls_overlay = InputContainer:new{
                dimen = Geom:new{ w = screen_size.w, h = screen_size.h },
                VerticalGroup:new{
                    VerticalSpan:new{ width = screen_size.h - Screen:scaleBySize(110) },
                    overlay_content,
                },
            }
            controls_overlay.ges_events.Tap = {
                GestureRange:new{
                    ges = "tap",
                    range = Geom:new{ x = 0, y = 0, w = screen_size.w, h = screen_size.h },
                },
            }
            function controls_overlay:onTap()
                parent_widget:onTap()
            end

            self[1] = OverlapGroup:new{
                dimen = Geom:new{ w = screen_size.w, h = screen_size.h },
                main_frame,
                controls_overlay,
            }
        else
            self[1] = main_frame
        end
    else
        self[1] = main_frame
    end
end

return PrayerTimesWidget