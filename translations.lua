-- translations.lua
local translations = {
    en = {
        prayer_times = "Prayer Times",
        fajr = "Fajr", sunrise = "Sunrise", dhuhr = "Dhuhr",
        asr = "Asr", maghrib = "Maghrib", isha = "Isha",
        next_prayer_label = "Next:", in_word = "in",
        hours_short = "h", minutes_short = "m",
        am = "AM", pm = "PM",

        launch = "Launch",
        language = "Language",
        set_location = "Set Location",
        choose_from_list = "Choose from list",
        add_location = "Add new location",

        calculation_settings = "Calculation Settings",
        calculation_method   = "Calculation Method",
        asr_madhhab          = "Asr Jurisprudence",

        display_and_appearance = "Display and Appearance",
        hijri_and_fasting      = "Hijri Date and Fasting",
        alerts                 = "Alerts",
        about                  = "About",

        show_hijri  = "Show Hijri date",
        time_format = "Time format",
        clock_mode  = "Clock mode",
        static_mode = "Static",
        live_mode   = "Live",
        prayer_only = "Prayer time only",

        dst_adjustment  = "Daylight Saving Time",
        no_dst          = "No change (0)",
        add_1_hour      = "Add 1 hour (+1)",
        add_2_hours     = "Add 2 hours (+2)",
        subtract_1_hour = "Subtract 1 hour (-1)",

        mwl       = "MWL (Muslim World League)",
        egyptian  = "Egyptian General Authority",
        ummalqura = "Umm al-Qura (Saudi Arabia)",
        karachi   = "Karachi (South Asia)",
        isna      = "ISNA (North America)",
        jafari    = "Jafari (Shia)",
        tehran    = "Tehran (Iran)",
        shafi     = "Shafi (shadow equals object)",
        hanafi    = "Hanafi (shadow twice object)",

        flash_screen        = "Flash screen",
        frontlight_pulse    = "Frontlight pulse",
        show_message        = "Show message",
        frontlight_duration = "Frontlight duration (seconds)",

        cancel = "Cancel",
        save   = "Save",

        country_name    = "Country name (English)",
        country_name_ar = "Country name (Arabic)",
        city_name       = "City name (English)",
        city_name_ar    = "City name (Arabic)",
        latitude        = "Latitude",
        longitude       = "Longitude",

        location_help_title = "Need coordinates?",
        location_help_text =
            "Search online for your city name + 'latitude longitude'.\n"
            .. "Example: 'Cairo latitude longitude'.\n\n"
            .. "You can also use Google Maps:\n"
            .. "Right-click on your city, the first number is latitude,\n"
            .. "the second is longitude.\n\n"
            .. "The timezone is calculated automatically.",

        country_hint    = "e.g., Egypt",
        country_ar_hint = "مثال: مصر",
        city_hint       = "e.g., Cairo",
        city_ar_hint    = "مثال: القاهرة",
        latitude_hint   = "e.g., 30.0444",
        longitude_hint  = "e.g., 31.2357",

        invalid_input   = "Invalid input",
        invalid_lat     = "Latitude must be a number between -90 and 90",
        invalid_lng     = "Longitude must be a number between -180 and 180",
        location_set    = "Location set to %1",
        location_added  = "Location added: %1",
        method_auto_set = "Calculation method set automatically to %1",

        screen_brightness      = "Screen brightness",
        screen_brightness_hint =
            "Choose a brightness level from 0 to 24.\n\n"
            .. "Set -1 to keep your current brightness unchanged.",

        font_size = "Font size adjustment",
        font_face = "Font style",
        font_face_builtin = "Built in fonts",
        font_face_device  = "My fonts",
        font_face_folder_hint =
            "To add your own fonts:\n\n"
            .. "1. Connect your Kindle to a PC by USB\n\n"
            .. "2. Open the Kindle drive (usually E:)\n"
            .. "3. Create or open the 'fonts' folder at the root\n"
            .. "   (E:\\fonts)\n\n"
            .. "4. Copy your .ttf or .otf font files there\n\n"
            .. "5. Safely eject the Kindle\n\n"
            .. "6. Restart KOReader completely\n"
            .. "   (exit and reopen, not just close the widget)\n\n"
            .. "7. Your fonts will appear under: My fonts\n\n"
            .. "Note: KOReader also uses this folder for system fonts.",
        font_applied = "Font changed. Reopen Prayer Times to see it.",
        font_how_to_add = "How to add fonts",

        auto_show_resume      = "Show automatically on wake",
        auto_show_resume_info = "Prayer Times will open automatically when the device wakes up.",

        status_widgets  = "Status bar items",
        battery_widget  = "Show battery",
        wifi_widget     = "Show WiFi",
        memory_widget   = "Show memory",
        battery_format  = "Battery format",
        battery_icon    = "Icon only",
        battery_percent = "Percent only",
        battery_both    = "Icon and percent",
        status_battery  = "Battery",
        status_wifi     = "WiFi",
        status_memory   = "Memory",
        wifi_on         = "On",
        wifi_off        = "Off",
        na              = "N/A",

        hijri_adjustment      = "Hijri date adjustment",
        show_fasting_days     = "Show fasting reminders",
        fasting_days          = "Fasting types",
        fasting_reminder_days = "Remind me in advance",
        fasting_reminder_0    = "On the fasting day only",
        fasting_reminder_1    = "One day before and the day itself",
        fasting_reminder_2    = "Two days before, one day before and the day itself",

        monday_thursday_fasting = "Mondays and Thursdays",
        white_days_fasting      = "White days (13, 14, 15 Hijri)",
        ashura_fasting          = "Ashura (10 Muharram)",
        arafah_fasting          = "Arafah (9 Dhul Hijjah)",
        six_shawwal_fasting     = "Six days of Shawwal",

        days = "days",
        day  = "day",
        default_val = "default",

        fasting_today     = "Fasting today: %1",
        fasting_tomorrow  = "Fasting tomorrow: %1",
        fasting_in_2_days = "Fasting in two days: %1",

        fasting_monday   = "Monday",
        fasting_thursday = "Thursday",
        fasting_white    = "White days",
        fasting_ashura   = "Ashura",
        fasting_arafah   = "Arafah",
        fasting_shawwal  = "Shawwal",

        about_text =
            "Prayer Times\nVersion 15.2\n\n"
            .. "Accurate prayer time calculation\n"
            .. "Seven calculation methods\n"
            .. "Hijri calendar with manual adjustment\n"
            .. "Fasting day reminders\n"
            .. "Custom fonts and sizes\n"
            .. "Full Arabic and English support",
    },

    ar = {
        prayer_times = "مواقيت الصلاة",
        fajr = "الفجر", sunrise = "الشروق", dhuhr = "الظهر",
        asr = "العصر", maghrib = "المغرب", isha = "العشاء",
        next_prayer_label = "التالي:", in_word = "بعد",
        hours_short = "س", minutes_short = "د",
        am = "ص", pm = "م",

        launch = "تشغيل",
        language = "اللغة",
        set_location = "تحديد الموقع",
        choose_from_list = "اختر من القائمة",
        add_location = "إضافة موقع جديد",

        calculation_settings = "إعدادات الحساب",
        calculation_method   = "طريقة الحساب",
        asr_madhhab          = "مذهب العصر",

        display_and_appearance = "العرض والمظهر",
        hijri_and_fasting      = "التاريخ الهجري والصيام",
        alerts                 = "التنبيهات",
        about                  = "حول",

        show_hijri  = "إظهار التاريخ الهجري",
        time_format = "صيغة الوقت",
        clock_mode  = "وضع الساعة",
        static_mode = "ثابت",
        live_mode   = "مباشر",
        prayer_only = "عند وقت الصلاة فقط",

        dst_adjustment  = "التوقيت الصيفي",
        no_dst          = "بدون تغيير (0)",
        add_1_hour      = "إضافة ساعة (+1)",
        add_2_hours     = "إضافة ساعتين (+2)",
        subtract_1_hour = "طرح ساعة (-1)",

        mwl       = "رابطة العالم الإسلامي",
        egyptian  = "الهيئة المصرية العامة للمساحة",
        ummalqura = "أم القرى (السعودية)",
        karachi   = "كراتشي (جنوب آسيا)",
        isna      = "إسنا (أمريكا الشمالية)",
        jafari    = "جعفري (شيعي)",
        tehran    = "طهران (إيران)",
        shafi     = "الشافعي (ظل المثل)",
        hanafi    = "الحنفي (ظل المثلين)",

        flash_screen        = "وميض الشاشة",
        frontlight_pulse    = "نبض الإضاءة",
        show_message        = "إظهار رسالة",
        frontlight_duration = "مدة الإضاءة (بالثواني)",

        cancel = "إلغاء",
        save   = "حفظ",

        country_name    = "اسم الدولة (إنجليزي)",
        country_name_ar = "اسم الدولة (عربي)",
        city_name       = "اسم المدينة (إنجليزي)",
        city_name_ar    = "اسم المدينة (عربي)",
        latitude        = "خط العرض",
        longitude       = "خط الطول",

        location_help_title = "تحتاج الإحداثيات؟",
        location_help_text =
            "ابحث في الإنترنت عن اسم مدينتك مع 'خط العرض خط الطول'.\n"
            .. "مثال: 'القاهرة خط العرض خط الطول'.\n\n"
            .. "يمكنك أيضًا استخدام خرائط جوجل:\n"
            .. "انقر بزر الماوس الأيمن على مدينتك، الرقم الأول هو خط العرض\n"
            .. "والثاني هو خط الطول.\n\n"
            .. "يتم حساب المنطقة الزمنية تلقائيًا.",

        country_hint    = "مثال: مصر",
        country_ar_hint = "مثال: مصر",
        city_hint       = "مثال: القاهرة",
        city_ar_hint    = "مثال: القاهرة",
        latitude_hint   = "مثال: 30.0444",
        longitude_hint  = "مثال: 31.2357",

        invalid_input   = "إدخال غير صالح",
        invalid_lat     = "خط العرض يجب أن يكون رقما بين -90 و 90",
        invalid_lng     = "خط الطول يجب أن يكون رقما بين -180 و 180",
        location_set    = "تم تحديد الموقع: %1",
        location_added  = "تمت إضافة الموقع: %1",
        method_auto_set = "تم ضبط طريقة الحساب تلقائيا على %1",

        screen_brightness      = "سطوع الشاشة",
        screen_brightness_hint =
            "اختر مستوى السطوع من 0 إلى 24.\n\n"
            .. "اختر -1 للإبقاء على السطوع الحالي دون تغيير.",

        font_size = "تعديل حجم الخط",
        font_face = "نوع الخط",
        font_face_builtin = "الخطوط المدمجة",
        font_face_device  = "خطوطي",
        font_face_folder_hint =
            "لإضافة خطوطك الخاصة:\n\n"
            .. "1. وصّل الكيندل بالكمبيوتر عبر USB\n\n"
            .. "2. افتح قرص الكيندل (عادة E:)\n"
            .. "3. أنشئ أو افتح مجلد fonts في الجذر\n"
            .. "   (E:\\fonts)\n\n"
            .. "4. انسخ ملفات ttf أو otf إلى داخله\n\n"
            .. "5. افصل الكيندل بأمان\n\n"
            .. "6. أعد تشغيل كورييدر بالكامل\n"
            .. "   (اخرج ثم افتحه من جديد)\n\n"
            .. "7. ستظهر خطوطك تحت قائمة: خطوطي\n\n"
            .. "ملاحظة: يستخدم كورييدر هذا المجلد للخطوط النظامية أيضًا.",
        font_applied = "تم تغيير الخط. أعد فتح مواقيت الصلاة لرؤيته.",
        font_how_to_add = "كيفية إضافة الخطوط",

        auto_show_resume      = "العرض تلقائيا عند الاستيقاظ",
        auto_show_resume_info = "ستفتح مواقيت الصلاة تلقائيا عند استيقاظ الجهاز.",

        status_widgets  = "عناصر شريط الحالة",
        battery_widget  = "إظهار البطارية",
        wifi_widget     = "إظهار الواي فاي",
        memory_widget   = "إظهار الذاكرة",
        battery_format  = "شكل البطارية",
        battery_icon    = "أيقونة فقط",
        battery_percent = "نسبة فقط",
        battery_both    = "أيقونة ونسبة",
        status_battery  = "البطارية",
        status_wifi     = "الواي فاي",
        status_memory   = "الذاكرة",
        wifi_on         = "متصل",
        wifi_off        = "غير متصل",
        na              = "غير متاح",

        hijri_adjustment      = "تعديل التاريخ الهجري",
        show_fasting_days     = "إظهار تذكيرات الصيام",
        fasting_days          = "أنواع الصيام",
        fasting_reminder_days = "التذكير المسبق",
        fasting_reminder_0    = "يوم الصيام فقط",
        fasting_reminder_1    = "قبله بيوم ويوم الصيام",
        fasting_reminder_2    = "قبله بيومين وقبله بيوم ويوم الصيام",

        monday_thursday_fasting = "الاثنين والخميس",
        white_days_fasting      = "الأيام البيض (13 و14 و15 هجري)",
        ashura_fasting          = "عاشوراء (10 محرم)",
        arafah_fasting          = "عرفة (9 ذو الحجة)",
        six_shawwal_fasting     = "ست من شوال",

        days = "أيام",
        day  = "يوم",
        default_val = "الافتراضي",

        fasting_today     = "صيام اليوم: %1",
        fasting_tomorrow  = "صيام غدا: %1",
        fasting_in_2_days = "صيام بعد يومين: %1",

        fasting_monday   = "الاثنين",
        fasting_thursday = "الخميس",
        fasting_white    = "الأيام البيض",
        fasting_ashura   = "عاشوراء",
        fasting_arafah   = "عرفة",
        fasting_shawwal  = "شوال",

        about_text =
            "مواقيت الصلاة\nالإصدار 15.2\n\n"
            .. "حساب دقيق لأوقات الصلاة\n"
            .. "سبع طرق للحساب\n"
            .. "تقويم هجري مع تعديل يدوي\n"
            .. "تذكيرات بأيام الصيام\n"
            .. "خطوط وأحجام قابلة للتخصيص\n"
            .. "دعم كامل للعربية والإنجليزية",
    },
}

local arabic_day_names = {
    Sunday = "الأحد", Monday = "الاثنين", Tuesday = "الثلاثاء",
    Wednesday = "الأربعاء", Thursday = "الخميس",
    Friday = "الجمعة", Saturday = "السبت",
}

local arabic_month_names = {
    January = "يناير", February = "فبراير", March = "مارس", April = "أبريل",
    May = "مايو", June = "يونيو", July = "يوليو", August = "أغسطس",
    September = "سبتمبر", October = "أكتوبر", November = "نوفمبر", December = "ديسمبر",
}

local fasting_reason_keys = {
    monday   = "fasting_monday",
    thursday = "fasting_thursday",
    white    = "fasting_white",
    ashura   = "fasting_ashura",
    arafah   = "fasting_arafah",
    shawwal  = "fasting_shawwal",
}

return {
    translations = translations,
    arabic_day_names = arabic_day_names,
    arabic_month_names = arabic_month_names,
    fasting_reason_keys = fasting_reason_keys,
}