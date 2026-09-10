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
        apply_dst_to_clock = "Apply DST to plugin clock",
        apply_dst_to_clock_info =
            "Enabled: plugin clock = Kindle clock + DST.\n"
            .. "Disabled: plugin clock = Kindle clock.",

        mwl          = "MWL (Muslim World League)",
        egyptian     = "Egyptian General Authority",
        iac_standard = "IAC Standard (18/18 or 18/17)",
        ummalqura    = "Umm al-Qura (Saudi Arabia)",
        karachi      = "Karachi (South Asia)",
        isna         = "ISNA (North America)",
        moroccan     = "Moroccan (19°/17°)",
        tehran       = "Tehran (Iran)",
        jafari       = "Jafari",
        shafi        = "Shafi (shadow equals object)",
        hanafi       = "Hanafi (shadow twice object)",

        high_latitude_title = "Northern Regions (High Latitude)",
        high_latitude_none = "Show real times only (--:-- if unavailable)",
        high_latitude_seventh = "One-seventh of the night",
        high_latitude_middle = "Middle of the night",
        high_latitude_angle = "Angle-based portion of night",
        high_latitude_fixed = "Fixed minutes from sunrise/sunset",
        high_latitude_minutes = "Fixed minutes value",
        high_latitude_what_is_this = "What is this?",
        high_latitude_explanation =
            "In some far northern countries (e.g., Norway, Sweden, Iceland)\n"
            .. "twilight may not end in summer, or the sun may not rise in winter.\n\n"
            .. "In those cases, Fajr or Isha cannot be calculated astronomically.\n\n"
            .. "This setting decides how to estimate the times:\n\n"
            .. "- Real times only: no estimation (shows --:--)\n"
            .. "- One-seventh of night: Fajr = Sunrise - 1/7 of night\n"
            .. "- Middle of night: Fajr = Sunrise - 1/2 of night\n"
            .. "- Angle-based: portion of night based on prayer angle\n"
            .. "- Fixed minutes: fixed minutes before sunrise / after sunset\n\n"
            .. "If you live in a normal Arab or Islamic country,\n"
            .. "you do NOT need to change this.",
        high_latitude_auto_enabled =
            "Your location is at a high latitude (%1°).\n"
            .. "'One-seventh of night' has been enabled automatically "
            .. "to estimate Fajr and Isha when astronomical signs are absent.\n\n"
            .. "You can change this in:\n"
            .. "Calculation Settings > Northern Regions (High Latitude)",

        prayer_adjustments = "Per-Prayer Corrections (minutes)",
        fajr_adjustment = "Fajr correction",
        sunrise_adjustment = "Sunrise correction",
        dhuhr_adjustment = "Dhuhr correction",
        asr_adjustment = "Asr correction",
        maghrib_adjustment = "Maghrib correction",
        isha_adjustment = "Isha correction",

        force_ramadan_title = "Ramadan Mode (Umm al-Qura)",
        force_ramadan_auto = "Automatic (calculated Hijri)",
        force_ramadan_yes = "Force Ramadan (120 min Isha)",
        force_ramadan_no = "Force Normal (90 min Isha)",

        flash_screen        = "Flash screen",
        frontlight_pulse    = "Frontlight pulse",
        show_message        = "Show message",
        frontlight_duration = "Frontlight duration (seconds)",

        cancel = "Cancel", save = "Save",
        preview = "Preview", apply = "Apply",

        country_hint    = "e.g., Egypt",
        country_ar_hint = "e.g., مصر",
        city_hint       = "e.g., Cairo",
        city_ar_hint    = "e.g., القاهرة",
        latitude_hint   = "e.g., 30.0444",
        longitude_hint  = "e.g., 31.2357",

        location_help_title = "Need coordinates?",
        location_help_text = "See 'How to Find Your Coordinates' for a step-by-step guide.",

        invalid_input   = "Invalid input",
        invalid_lat     = "Latitude must be between -90 and 90",
        invalid_lng     = "Longitude must be between -180 and 180",
        location_set    = "Location set to %1",
        location_added  = "Location added: %1",
        method_auto_set = "Calculation method set to %1",

        screen_brightness      = "Screen brightness",
        screen_brightness_hint = "Choose 0–24, or -1 to keep current.",

        font_size = "Font size adjustment",
        font_face = "Font style",
        font_face_builtin = "Built in fonts",
        font_face_device  = "My fonts",
        font_face_folder_hint =
            "To add fonts:\n\n"
            .. "1. Connect Kindle to PC via USB\n"
            .. "2. Open the Kindle drive\n"
            .. "3. Create/open 'fonts' folder at root\n"
            .. "4. Copy .ttf or .otf files there\n"
            .. "5. Safely eject\n"
            .. "6. Restart KOReader completely\n"
            .. "7. Fonts appear under: My fonts",
        font_applied = "Font changed. Reopen Prayer Times to see it.",
        font_how_to_add = "How to add fonts",

        auto_show_resume      = "Show automatically on wake",
        auto_show_resume_info = "Prayer Times opens when device wakes.",

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
        wifi_on = "On", wifi_off = "Off", na = "N/A",

        hijri_adjustment      = "Hijri date adjustment",
        show_fasting_days     = "Show fasting reminders",
        fasting_days          = "Fasting types",
        fasting_reminder_days = "Remind me in advance",
        fasting_reminder_0    = "On the fasting day only",
        fasting_reminder_1    = "One day before and the day",
        fasting_reminder_2    = "Two days, one day, and the day",

        monday_thursday_fasting = "Mondays and Thursdays",
        white_days_fasting      = "White days (13, 14, 15 Hijri)",
        ashura_fasting          = "Ashura (10 Muharram)",
        arafah_fasting          = "Arafah (9 Dhul Hijjah)",
        six_shawwal_fasting     = "Six days of Shawwal",

        days = "days", day = "day", default_val = "default",

        fasting_today     = "Fasting today: %1",
        fasting_tomorrow  = "Fasting tomorrow: %1",
        fasting_in_2_days = "Fasting in two days: %1",

        fasting_monday = "Monday", fasting_thursday = "Thursday",
        fasting_white = "White days", fasting_ashura = "Ashura",
        fasting_arafah = "Arafah", fasting_shawwal = "Shawwal",

        calc_error = "Calculation error: %1",
        unavailable = "--:--",

        search_menu_label = "Search for a city...",
        search_title = "Search for a city",
        search_hint = "Type city or country name...",
        search_button = "Search",
        search_new = "New search...",
        search_results_title = "Results",
        search_no_results = "No results found",
        search_city = "Search",
        show_all_cities = "Show All",

        add_location_guide_title = "How to Find Your Coordinates",
        add_location_guide_text =
            "You can easily find your latitude and longitude using this website:\n\n"
            .. "1. Open your browser and go to:\n"
            .. "   https://timesprayer.com/\n\n"
            .. "2. Click the 'My Location' button.\n"
            .. "   The site will ask permission to access your location.\n\n"
            .. "3. Allow access. The site will detect your\n"
            .. "   coordinates, timezone, and calculation method.\n\n"
            .. "4. The page will show:\n"
            .. "   - Your city name\n"
            .. "   - Latitude and Longitude\n"
            .. "   - Recommended calculation method\n"
            .. "   - Asr madhhab\n\n"
            .. "5. Use those values here:\n"
            .. "   - Enter latitude and longitude below\n"
            .. "   - The plugin will auto-select the method\n"
            .. "     based on your country (you can change it)\n\n"
            .. "6. If you prefer not to share your location,\n"
            .. "   search for your city manually on the site.",

        method_recommended_info =
            "Location saved: %1\n\n"
            .. "Recommended method: %2\n"
            .. "Recommended Asr school: %3\n\n"
            .. "These were chosen automatically based on your country. "
            .. "You can change them anytime from:\n"
            .. "Calculation Settings",

        method_no_recommendation =
            "Location saved: %1\n\n"
            .. "Current method: %2\n"
            .. "Current Asr school: %3\n\n"
            .. "You can change them anytime from:\n"
            .. "Calculation Settings",

        about_text =
            "Prayer Times\nVersion 1.2.0\n\n"
            .. "Offline astronomical calculation\n"
            .. "9 methods incl. IAC Standard & Moroccan\n"
            .. "Hijri calendar with adjustment\n"
            .. "Fasting reminders\n"
            .. "High-latitude support\n"
            .. "Per-prayer corrections\n"
            .. "Arabic & English\n\n"
            .. "Astronomical basis: M. Shawkat Odeh / IAC",
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
        apply_dst_to_clock = "تطبيق التوقيت الصيفي على الساعة",
        apply_dst_to_clock_info =
            "عند التفعيل: ساعة الإضافة = ساعة الكيندل + التوقيت الصيفي.\n"
            .. "عند التعطيل: ساعة الإضافة = ساعة الكيندل.",

        mwl          = "رابطة العالم الإسلامي",
        egyptian     = "الهيئة المصرية العامة للمساحة",
        iac_standard = "المركز الفلكي الدولي (18/18 أو 18/17)",
        ummalqura    = "أم القرى (السعودية)",
        karachi      = "كراتشي (جنوب آسيا)",
        isna         = "إسنا (أمريكا الشمالية)",
        moroccan     = "المغربية (19°/17°)",
        tehran       = "طهران (إيران)",
        jafari       = "جعفري",
        shafi        = "الشافعي (ظل المثل)",
        hanafi       = "الحنفي (ظل المثلين)",

        high_latitude_title = "المناطق الشمالية (خطوط العرض العليا)",
        high_latitude_none = "الأوقات الحقيقية فقط (--:-- إن لم تتوفر)",
        high_latitude_seventh = "سُبع الليل",
        high_latitude_middle = "منتصف الليل",
        high_latitude_angle = "جزء من الليل حسب الزاوية",
        high_latitude_fixed = "دقائق ثابتة من الشروق/الغروب",
        high_latitude_minutes = "عدد الدقائق الثابتة",
        high_latitude_what_is_this = "ما هذا الخيار؟",
        high_latitude_explanation =
            "في بعض الدول الشمالية (مثل النرويج، السويد، آيسلندا)\n"
            .. "قد لا يغيب الشفق في الصيف، أو لا تشرق الشمس في الشتاء.\n\n"
            .. "في هذه الحالة لا يمكن حساب الفجر أو العشاء فلكياً.\n\n"
            .. "هذا الخيار يحدد كيف يتم تقدير الأوقات:\n\n"
            .. "- الأوقات الحقيقية فقط: لا يتم التقدير (يظهر --:--)\n"
            .. "- سُبع الليل: الفجر = الشروق - سُبع الليل\n"
            .. "- منتصف الليل: الفجر = الشروق - نصف الليل\n"
            .. "- حسب الزاوية: جزء من الليل بناء على زاوية الصلاة\n"
            .. "- دقائق ثابتة: فترة ثابتة قبل الشروق أو بعد الغروب\n\n"
            .. "إذا كنت في منطقة عربية أو إسلامية عادية،\n"
            .. "لا تحتاج لتغيير هذا الخيار.",
        high_latitude_auto_enabled =
            "موقعك في منطقة شمالية (خط عرض %1°).\n"
            .. "تم تفعيل 'سُبع الليل' تلقائياً "
            .. "لتقدير الفجر والعشاء عند غياب العلامة الفلكية.\n\n"
            .. "يمكنك تغيير ذلك من:\n"
            .. "إعدادات الحساب > المناطق الشمالية (خطوط العرض العليا)",

        prayer_adjustments = "تصحيحات كل صلاة (بالدقائق)",
        fajr_adjustment = "تصحيح الفجر",
        sunrise_adjustment = "تصحيح الشروق",
        dhuhr_adjustment = "تصحيح الظهر",
        asr_adjustment = "تصحيح العصر",
        maghrib_adjustment = "تصحيح المغرب",
        isha_adjustment = "تصحيح العشاء",

        force_ramadan_title = "وضع رمضان (أم القرى)",
        force_ramadan_auto = "تلقائي (حساب هجري)",
        force_ramadan_yes = "فرض رمضان (العشاء 120 دقيقة)",
        force_ramadan_no = "فرض عادي (العشاء 90 دقيقة)",

        flash_screen        = "وميض الشاشة",
        frontlight_pulse    = "نبض الإضاءة",
        show_message        = "إظهار رسالة",
        frontlight_duration = "مدة الإضاءة (بالثواني)",

        cancel = "إلغاء", save = "حفظ",
        preview = "معاينة", apply = "تطبيق",

        country_hint    = "e.g., Egypt",
        country_ar_hint = "مثال: مصر",
        city_hint       = "e.g., Cairo",
        city_ar_hint    = "مثال: القاهرة",
        latitude_hint   = "مثال: 30.0444",
        longitude_hint  = "مثال: 31.2357",

        location_help_title = "تحتاج الإحداثيات؟",
        location_help_text = "راجع 'كيف تحصل على إحداثيات موقعك' للتعليمات الكاملة.",

        invalid_input   = "إدخال غير صالح",
        invalid_lat     = "خط العرض بين -90 و 90",
        invalid_lng     = "خط الطول بين -180 و 180",
        location_set    = "تم تحديد الموقع: %1",
        location_added  = "تمت إضافة الموقع: %1",
        method_auto_set = "تم ضبط طريقة الحساب على %1",

        screen_brightness      = "سطوع الشاشة",
        screen_brightness_hint = "اختر 0–24 أو -1 للإبقاء على الحالي.",

        font_size = "تعديل حجم الخط",
        font_face = "نوع الخط",
        font_face_builtin = "الخطوط المدمجة",
        font_face_device  = "خطوطي",
        font_face_folder_hint =
            "لإضافة خطوط:\n\n"
            .. "1. وصّل الكيندل بالكمبيوتر\n"
            .. "2. افتح قرص الكيندل\n"
            .. "3. أنشئ مجلد fonts في الجذر\n"
            .. "4. انسخ ملفات ttf أو otf\n"
            .. "5. افصل الكيندل بأمان\n"
            .. "6. أعد تشغيل كورييدر\n"
            .. "7. ستظهر خطوطك تحت: خطوطي",
        font_applied = "تم تغيير الخط. أعد فتح مواقيت الصلاة.",
        font_how_to_add = "كيفية إضافة الخطوط",

        auto_show_resume      = "العرض تلقائيا عند الاستيقاظ",
        auto_show_resume_info = "ستفتح مواقيت الصلاة عند استيقاظ الجهاز.",

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
        wifi_on = "متصل", wifi_off = "غير متصل", na = "غير متاح",

        hijri_adjustment      = "تعديل التاريخ الهجري",
        show_fasting_days     = "إظهار تذكيرات الصيام",
        fasting_days          = "أنواع الصيام",
        fasting_reminder_days = "التذكير المسبق",
        fasting_reminder_0    = "يوم الصيام فقط",
        fasting_reminder_1    = "قبله بيوم ويوم الصيام",
        fasting_reminder_2    = "قبله بيومين ويوم ويوم الصيام",

        monday_thursday_fasting = "الاثنين والخميس",
        white_days_fasting      = "الأيام البيض (13 و14 و15)",
        ashura_fasting          = "عاشوراء (10 محرم)",
        arafah_fasting          = "عرفة (9 ذو الحجة)",
        six_shawwal_fasting     = "ست من شوال",

        days = "أيام", day = "يوم", default_val = "الافتراضي",

        fasting_today     = "صيام اليوم: %1",
        fasting_tomorrow  = "صيام غدا: %1",
        fasting_in_2_days = "صيام بعد يومين: %1",

        fasting_monday = "الاثنين", fasting_thursday = "الخميس",
        fasting_white = "الأيام البيض", fasting_ashura = "عاشوراء",
        fasting_arafah = "عرفة", fasting_shawwal = "شوال",

        calc_error = "خطأ في الحساب: %1",
        unavailable = "--:--",

        search_menu_label = "بحث عن مدينة...",
        search_title = "بحث عن مدينة",
        search_hint = "اكتب اسم المدينة أو الدولة...",
        search_button = "بحث",
        search_new = "بحث جديد...",
        search_results_title = "نتائج البحث",
        search_no_results = "لا توجد نتائج",
        search_city = "بحث",
        show_all_cities = "عرض الكل",

        add_location_guide_title = "كيف تحصل على إحداثيات موقعك",
        add_location_guide_text =
            "يمكنك بسهولة الحصول على خطي العرض والطول من هذا الموقع:\n\n"
            .. "1. افتح المتصفح واذهب إلى:\n"
            .. "   https://timesprayer.com/\n\n"
            .. "2. اضغط زر 'جد مكاني' (My Location).\n"
            .. "   سيطلب الموقع إذن الوصول إلى موقعك.\n\n"
            .. "3. اسمح بالوصول. سيكتشف الموقع تلقائياً:\n"
            .. "   الإحداثيات والمنطقة الزمنية والطريقة.\n\n"
            .. "4. ستعرض الصفحة:\n"
            .. "   - اسم مدينتك\n"
            .. "   - خط العرض وخط الطول\n"
            .. "   - طريقة الحساب المقترحة\n"
            .. "   - مذهب العصر\n\n"
            .. "5. استخدم هذه القيم هنا:\n"
            .. "   - أدخل خط العرض وخط الطول أدناه\n"
            .. "   - ستختار الإضافة الطريقة تلقائياً\n"
            .. "     حسب دولتك (يمكنك تغييرها)\n\n"
            .. "6. إذا كنت لا تريد مشاركة موقعك،\n"
            .. "   ابحث عن مدينتك يدوياً في الموقع.",

        method_recommended_info =
            "تم حفظ الموقع: %1\n\n"
            .. "الطريقة المقترحة: %2\n"
            .. "مذهب العصر المقترح: %3\n\n"
            .. "تم اختيارهما تلقائياً حسب دولتك. "
            .. "يمكنك تغييرهما في أي وقت من:\n"
            .. "إعدادات الحساب",

        method_no_recommendation =
            "تم حفظ الموقع: %1\n\n"
            .. "الطريقة الحالية: %2\n"
            .. "مذهب العصر الحالي: %3\n\n"
            .. "يمكنك تغييرهما في أي وقت من:\n"
            .. "إعدادات الحساب",

        about_text =
            "مواقيت الصلاة\nالإصدار 1.2.0\n\n"
            .. "حساب فلكي محلي بدون إنترنت\n"
            .. "9 طرق منها المركز الفلكي والمغربية\n"
            .. "تقويم هجري مع تعديل\n"
            .. "تذكيرات الصيام\n"
            .. "دعم خطوط العرض العليا\n"
            .. "تصحيحات لكل صلاة\n"
            .. "عربي وإنجليزي\n\n"
            .. "الأساس الفلكي: م. محمد شوكت عودة / IAC",
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