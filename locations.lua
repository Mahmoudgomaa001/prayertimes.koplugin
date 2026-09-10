--locations.lua
local locations = {
    -- Saudi Arabia
    ["Saudi Arabia"] = {
        { name = "Riyadh", name_ar = "الرياض", lat = 24.7136, lng = 46.6753, tz = 3 },
        { name = "Mecca", name_ar = "مكة المكرمة", lat = 21.4225, lng = 39.8262, tz = 3 },
        { name = "Medina", name_ar = "المدينة المنورة", lat = 24.5247, lng = 39.5692, tz = 3 },
        { name = "Jeddah", name_ar = "جدة", lat = 21.5433, lng = 39.1728, tz = 3 },
        { name = "Taif", name_ar = "الطائف", lat = 21.2854, lng = 40.4167, tz = 3 },
        { name = "Al-Ahsa", name_ar = "الأحساء", lat = 25.3646, lng = 49.5911, tz = 3 },
        { name = "Dammam", name_ar = "الدمام", lat = 26.4207, lng = 50.0888, tz = 3 },
        { name = "Khobar", name_ar = "الخبر", lat = 26.2731, lng = 50.2081, tz = 3 },
        { name = "Dhahran", name_ar = "الظهران", lat = 26.2731, lng = 50.1114, tz = 3 },
        { name = "Qatif", name_ar = "القطيف", lat = 26.5244, lng = 50.0233, tz = 3 },
        { name = "Jubail", name_ar = "الجبيل", lat = 27.0112, lng = 49.6583, tz = 3 },
        { name = "Hafar Al-Batin", name_ar = "حفر الباطن", lat = 28.4343, lng = 45.9636, tz = 3 },
        { name = "Buraidah", name_ar = "بريدة", lat = 26.3260, lng = 43.9750, tz = 3 },
        { name = "Unaizah", name_ar = "عنيزة", lat = 26.0858, lng = 43.9911, tz = 3 },
        { name = "Kharj", name_ar = "الخرج", lat = 24.1510, lng = 47.3120, tz = 3 },
        { name = "Abha", name_ar = "أبها", lat = 18.2164, lng = 42.5053, tz = 3 },
        { name = "Khamis Mushait", name_ar = "خميس مشيط", lat = 18.3064, lng = 42.7292, tz = 3 },
        { name = "Tabuk", name_ar = "تبوك", lat = 28.3835, lng = 36.5662, tz = 3 },
        { name = "Hail", name_ar = "حائل", lat = 27.5219, lng = 41.6961, tz = 3 },
        { name = "Najran", name_ar = "نجران", lat = 17.4933, lng = 44.1277, tz = 3 },
        { name = "Jazan", name_ar = "جازان", lat = 16.8892, lng = 42.5511, tz = 3 },
        { name = "Al-Bahah", name_ar = "الباحة", lat = 20.0129, lng = 41.4677, tz = 3 },
        { name = "Sakaka", name_ar = "سكاكا", lat = 29.9697, lng = 40.2064, tz = 3 },
        { name = "Arar", name_ar = "عرعر", lat = 30.9753, lng = 41.0381, tz = 3 },
        { name = "Yanbu", name_ar = "ينبع", lat = 24.0891, lng = 38.0637, tz = 3 },
        { name = "Quriat", name_ar = "القريات", lat = 31.3314, lng = 37.3424, tz = 3 }
    },

    -- Egypt
    ["Egypt"] = {
        { name = "Cairo", name_ar = "القاهرة", lat = 30.0444, lng = 31.2357, tz = 2 },
        { name = "Alexandria", name_ar = "الإسكندرية", lat = 31.2001, lng = 29.9187, tz = 2 },
        { name = "Giza", name_ar = "الجيزة", lat = 30.0131, lng = 31.2089, tz = 2 },
        { name = "Shubra El-Kheima", name_ar = "القليوبية", lat = 30.4591, lng = 31.1825, tz = 2 }, -- بنها العاصمة الادارية
        { name = "Mansoura", name_ar = "الدقهلية", lat = 31.0409, lng = 31.3785, tz = 2 },
        { name = "Zagazig", name_ar = "الشرقية", lat = 30.5877, lng = 31.5020, tz = 2 },
        { name = "Tanta", name_ar = "الغربية", lat = 30.7865, lng = 31.0004, tz = 2 },
        { name = "Damanhour", name_ar = "البحيرة", lat = 31.0414, lng = 30.4703, tz = 2 },
        { name = "Asyut", name_ar = "أسيوط", lat = 27.1810, lng = 31.1837, tz = 2 },
        { name = "Fayoum", name_ar = "الفيوم", lat = 29.3084, lng = 30.8428, tz = 2 },
        { name = "Zagazig", name_ar = "المنوفية", lat = 30.5510, lng = 31.0114, tz = 2 }, -- شبين الكوم
        { name = "Minya", name_ar = "المنيا", lat = 28.1099, lng = 30.7503, tz = 2 },
        { name = "Sohag", name_ar = "سوهاج", lat = 26.5570, lng = 31.6948, tz = 2 },
        { name = "Qena", name_ar = "قنا", lat = 26.1551, lng = 32.7160, tz = 2 },
        { name = "Beni Suef", name_ar = "بني سويف", lat = 29.0744, lng = 31.0979, tz = 2 },
        { name = "Suez", name_ar = "السويس", lat = 29.9668, lng = 32.5498, tz = 2 },
        { name = "Hurghada", name_ar = "البحر الأحمر", lat = 27.2579, lng = 33.8116, tz = 2 },
        { name = "Aswan", name_ar = "أسوان", lat = 24.0889, lng = 32.8998, tz = 2 },
        { name = "Ismaília", name_ar = "الإسماعيلية", lat = 30.6043, lng = 32.2723, tz = 2 },
        { name = "Port Said", name_ar = "بورسعيد", lat = 31.2653, lng = 32.3019, tz = 2 },
        { name = "Damietta", name_ar = "دمياط", lat = 31.4175, lng = 31.8144, tz = 2 },
        { name = "Luxor", name_ar = "الأقصر", lat = 25.6872, lng = 32.6396, tz = 2 },
        { name = "Matrouh", name_ar = "مطروح", lat = 31.3543, lng = 27.2373, tz = 2 },
        { name = "Kharga", name_ar = "الوادي الجديد", lat = 25.4390, lng = 30.5486, tz = 2 },
        { name = "Kafr El-Sheikh", name_ar = "كفر الشيخ", lat = 31.1107, lng = 30.9388, tz = 2 },
        { name = "Arish", name_ar = "شمال سيناء", lat = 31.1321, lng = 33.8034, tz = 2 },
        { name = "Tor", name_ar = "جنوب سيناء", lat = 28.2364, lng = 33.6254, tz = 2 }
    },

    -- UAE
    ["UAE"] = {
        { name = "Abu Dhabi", name_ar = "أبوظبي", lat = 24.4539, lng = 54.3773, tz = 4 },
        { name = "Dubai", name_ar = "دبي", lat = 25.2048, lng = 55.2708, tz = 4 },
        { name = "Sharjah", name_ar = "الشارقة", lat = 25.3463, lng = 55.4209, tz = 4 },
        { name = "Ajman", name_ar = "عجمان", lat = 25.4111, lng = 55.4350, tz = 4 },
        { name = "Umm Al Quwain", name_ar = "أم القيوين", lat = 25.5647, lng = 55.5534, tz = 4 },
        { name = "Ras Al Khaimah", name_ar = "رأس الخيمة", lat = 25.7895, lng = 55.9432, tz = 4 },
        { name = "Fujairah", name_ar = "الفجيرة", lat = 25.1288, lng = 56.3265, tz = 4 },
        -- مدن ومناطق رئيسية أخرى لأهميتها في فروق التوقيت
        { name = "Al Ain", name_ar = "العين", lat = 24.1302, lng = 55.8023, tz = 4 },
        { name = "Khor Fakkan", name_ar = "خورفكان", lat = 25.3374, lng = 56.3414, tz = 4 },
        { name = "Kalba", name_ar = "كلباء", lat = 25.0744, lng = 56.3563, tz = 4 },
        { name = "Zayed City", name_ar = "مدينة زايد (الظفرة)", lat = 23.6542, lng = 53.7053, tz = 4 }
    },

    -- Qatar
    ["Qatar"] = {
        { name = "Doha", name_ar = "الدوحة", lat = 25.2854, lng = 51.5310, tz = 3 },
        { name = "Al Rayyan", name_ar = "الريان", lat = 25.2974, lng = 51.4244, tz = 3 },
        { name = "Al Wakrah", name_ar = "الوكرة", lat = 25.1768, lng = 51.6048, tz = 3 },
        { name = "Al Khor", name_ar = "الخور", lat = 25.6839, lng = 51.5058, tz = 3 },
        { name = "Umm Salal", name_ar = "أم صلال", lat = 25.4206, lng = 51.4083, tz = 3 },
        { name = "Al Daayen", name_ar = "الضعاين", lat = 25.5864, lng = 51.4722, tz = 3 },
        { name = "Al Shahaniya", name_ar = "الشحانية", lat = 25.3694, lng = 51.2289, tz = 3 },
        { name = "Al Shamal", name_ar = "الشمال", lat = 26.1155, lng = 51.2241, tz = 3 },
        -- مناطق حيوية إضافية لفروق التوقيت
        { name = "Mesaieed", name_ar = "مسيعيد", lat = 24.9902, lng = 51.5512, tz = 3 },
        { name = "Dukhan", name_ar = "دخان", lat = 25.4286, lng = 50.7844, tz = 3 }
    },

    -- Kuwait
    ["Kuwait"] = {
        { name = "Kuwait City", name_ar = "العاصمة", lat = 29.3759, lng = 47.9774, tz = 3 },
        { name = "Hawalli", name_ar = "حولي", lat = 29.3311, lng = 48.0411, tz = 3 },
        { name = "Farwaniya", name_ar = "الفروانية", lat = 29.2778, lng = 47.9511, tz = 3 },
        { name = "Ahmadi", name_ar = "الأحمدي", lat = 29.0761, lng = 48.0839, tz = 3 },
        { name = "Jahra", name_ar = "الجهراء", lat = 29.3375, lng = 47.6581, tz = 3 },
        { name = "Mubarak Al-Kabeer", name_ar = "مبارك الكبير", lat = 29.1950, lng = 48.0650, tz = 3 },
        -- مناطق وجزر إضافية تابعة لأهميتها الجغرافية وفروق التوقيت
        { name = "Salmiya", name_ar = "السالمية", lat = 29.3364, lng = 48.0764, tz = 3 },
        { name = "Wafra", name_ar = "الوفرة", lat = 28.5919, lng = 47.9572, tz = 3 },
        { name = "Abdali", name_ar = "العبدلي", lat = 30.0136, lng = 47.7478, tz = 3 },
        { name = "Failaka Island", name_ar = "جزيرة فيلكا", lat = 29.4394, lng = 48.2917, tz = 3 }
    },

    -- Bahrain
    ["Bahrain"] = {
        { name = "Manama", name_ar = "العاصمة", lat = 26.2285, lng = 50.5860, tz = 3 }, -- المنامة
        { name = "Muharraq", name_ar = "المحرق", lat = 26.2572, lng = 50.6119, tz = 3 },
        { name = "Riffa", name_ar = "المحافظة الجنوبية", lat = 26.1300, lng = 50.5500, tz = 3 }, -- الرفاع العاصمة الإدارية
        { name = "A'ali", name_ar = "المحافظة الشمالية", lat = 26.1500, lng = 50.5167, tz = 3 }, -- عالي والمنطقة الشمالية
        -- مدن ومناطق رئيسية أخرى لأهميتها الجغرافية والكثافة السكانية
        { name = "Hamad Town", name_ar = "مدينة حمد", lat = 26.1153, lng = 50.5069, tz = 3 },
        { name = "Isa Town", name_ar = "مدينة عيسى", lat = 26.1736, lng = 50.5472, tz = 3 },
        { name = "Sitra", name_ar = "سترة", lat = 26.1547, lng = 50.6208, tz = 3 },
        { name = "Budaiya", name_ar = "البديع", lat = 26.2122, lng = 50.4578, tz = 3 },
        { name = "Hawar Islands", name_ar = "جزر حوار", lat = 25.6519, lng = 50.7511, tz = 3 }
    },

    -- Oman
    ["Oman"] = {
        { name = "Muscat", name_ar = "مسقط", lat = 23.5859, lng = 58.4059, tz = 4 },
        { name = "Salalah", name_ar = "ظفار", lat = 17.0151, lng = 54.0924, tz = 4 }, -- صلالة العاصمة الإدارية
        { name = "Khasab", name_ar = "مسندم", lat = 26.1788, lng = 56.2415, tz = 4 }, -- خصب العاصمة الإدارية
        { name = "Sohar", name_ar = "شمال الباطنة", lat = 24.3461, lng = 56.7075, tz = 4 }, -- صحار العاصمة الإدارية
        { name = "Rustaq", name_ar = "جنوب الباطنة", lat = 23.3908, lng = 57.4244, tz = 4 }, -- الرستاق العاصمة الإدارية
        { name = "Nizwa", name_ar = "الداخلية", lat = 22.9333, lng = 57.5333, tz = 4 }, -- نزوى العاصمة الإدارية
        { name = "Sur", name_ar = "جنوب الشرقية", lat = 22.5667, lng = 59.5289, tz = 4 }, -- صور العاصمة الإدارية
        { name = "Ibra", name_ar = "شمال الشرقية", lat = 22.6905, lng = 58.5492, tz = 4 }, -- إبراء العاصمة الإدارية
        { name = "Ibri", name_ar = "الظاهرة", lat = 23.2104, lng = 56.5157, tz = 4 }, -- عبري العاصمة الإدارية
        { name = "Haima", name_ar = "الوسطى", lat = 19.9575, lng = 56.2778, tz = 4 }, -- هيماء العاصمة الإدارية
        { name = "Buraimi", name_ar = "البريمي", lat = 24.2505, lng = 55.7931, tz = 4 },
        -- مدن ومناطق إضافية لأهميتها الجغرافية وفروق التوقيت
        { name = "Seeb", name_ar = "السيب", lat = 23.6702, lng = 58.1890, tz = 4 },
        { name = "Duqm", name_ar = "الدقم", lat = 19.6583, lng = 57.7034, tz = 4 }
    },

    -- Iraq
    ["Iraq"] = {
        { name = "Baghdad", name_ar = "بغداد", lat = 33.3152, lng = 44.3661, tz = 3 },
        { name = "Basra", name_ar = "البصرة", lat = 30.5081, lng = 47.7835, tz = 3 },
        { name = "Mosul", name_ar = "نينوى", lat = 36.3489, lng = 43.1517, tz = 3 }, -- الموصل
        { name = "Erbil", name_ar = "أربيل", lat = 36.1901, lng = 44.0089, tz = 3 },
        { name = "Sulaymaniyah", name_ar = "السليمانية", lat = 35.5620, lng = 45.4372, tz = 3 },
        { name = "Kirkuk", name_ar = "كركوك", lat = 35.4681, lng = 44.3922, tz = 3 },
        { name = "Najaf", name_ar = "النجف", lat = 31.9922, lng = 44.3508, tz = 3 },
        { name = "Karbala", name_ar = "كربلاء", lat = 32.6160, lng = 44.0249, tz = 3 },
        { name = "Hillah", name_ar = "بابل", lat = 32.4811, lng = 44.4306, tz = 3 }, -- الحلة
        { name = "Nasiriyah", name_ar = "ذي قار", lat = 31.0581, lng = 46.2575, tz = 3 }, -- الناصرية
        { name = "Amarah", name_ar = "ميسان", lat = 31.8411, lng = 47.1444, tz = 3 }, -- العمارة
        { name = "Diwaniyah", name_ar = "القادسية", lat = 31.9911, lng = 44.9211, tz = 3 }, -- الديوانية
        { name = "Kut", name_ar = "واسط", lat = 32.5111, lng = 45.8167, tz = 3 }, -- الكوت
        { name = "Ramadi", name_ar = "الأنبار", lat = 33.4211, lng = 43.3011, tz = 3 }, -- الرمادي
        { name = "Baqubah", name_ar = "ديالى", lat = 33.7422, lng = 44.6433, tz = 3 }, -- بعقوبة
        { name = "Tikrit", name_ar = "صلاح الدين", lat = 34.6011, lng = 43.6811, tz = 3 }, -- تكريت
        { name = "Samawah", name_ar = "المثنى", lat = 31.3211, lng = 45.2811, tz = 3 }, -- السماوة
        { name = "Duhok", name_ar = "دهوك", lat = 36.8611, lng = 42.9911, tz = 3 },
        -- مدن إضافية لأهميتها الجغرافية الكبيرة وفروق التوقيت
        { name = "Faluja", name_ar = "الفلوجة", lat = 33.3511, lng = 43.7811, tz = 3 },
        { name = "Zubair", name_ar = "الزبير", lat = 30.3922, lng = 47.7011, tz = 3 }
    },

    -- Jordan
    ["Jordan"] = {
        { name = "Amman", name_ar = "عمان", lat = 31.9552, lng = 35.9450, tz = 3 },
        { name = "Zarqa", name_ar = "الزرقاء", lat = 32.0608, lng = 36.0942, tz = 3 },
        { name = "Irbid", name_ar = "إربد", lat = 32.5514, lng = 35.8514, tz = 3 },
        { name = "Aqaba", name_ar = "العقبة", lat = 29.5267, lng = 35.0078, tz = 3 },
        { name = "Salt", name_ar = "البلقاء", lat = 32.0381, lng = 35.7275, tz = 3 }, -- السلط العاصمة الإدارية
        { name = "Mafraq", name_ar = "المفرق", lat = 32.3400, lng = 36.2089, tz = 3 },
        { name = "Karak", name_ar = "الكرك", lat = 31.1637, lng = 35.7620, tz = 3 },
        { name = "Madaba", name_ar = "مادبا", lat = 31.7167, lng = 35.7933, tz = 3 },
        { name = "Jerash", name_ar = "جرش", lat = 32.2723, lng = 35.8914, tz = 3 },
        { name = "Ma'an", name_ar = "معان", lat = 30.1920, lng = 35.7360, tz = 3 },
        { name = "Ajloun", name_ar = "عجلون", lat = 32.3325, lng = 35.7517, tz = 3 },
        { name = "Tafilah", name_ar = "الطفيلة", lat = 30.8375, lng = 35.6042, tz = 3 }
    },

    -- Syria
    ["Syria"] = {
        { name = "Damascus", name_ar = "دمشق", lat = 33.5138, lng = 36.2765, tz = 3 },
        { name = "Aleppo", name_ar = "حلب", lat = 36.2021, lng = 37.1343, tz = 3 },
        { name = "Homs", name_ar = "حمص", lat = 34.7324, lng = 36.7137, tz = 3 },
        { name = "Hama", name_ar = "حماة", lat = 35.1318, lng = 36.7578, tz = 3 },
        { name = "Latakia", name_ar = "اللاذقية", lat = 35.5312, lng = 35.7921, tz = 3 },
        { name = "Deir ez-Zor", name_ar = "دير الزور", lat = 35.3359, lng = 40.1422, tz = 3 },
        { name = "Raqqa", name_ar = "الرقة", lat = 35.9525, lng = 39.0161, tz = 3 },
        { name = "Hasakah", name_ar = "الحسكة", lat = 36.5024, lng = 40.7475, tz = 3 },
        { name = "Daraa", name_ar = "درعا", lat = 32.6142, lng = 36.1044, tz = 3 },
        { name = "As-Suwayda", name_ar = "السويداء", lat = 32.7094, lng = 36.5664, tz = 3 },
        { name = "Tartus", name_ar = "طرطوس", lat = 34.8892, lng = 35.8867, tz = 3 },
        { name = "Idlib", name_ar = "إدلب", lat = 35.9306, lng = 36.6339, tz = 3 },
        { name = "Quneitra", name_ar = "القنيطرة", lat = 33.1256, lng = 35.8242, tz = 3 },
        { name = "Rif Dimashq", name_ar = "ريف دمشق", lat = 33.5150, lng = 36.4350, tz = 3 }, -- مركز دوما/إحداثيات تقريبية للمحافظة
        -- مدينة إضافية حيوية
        { name = "Palmyra", name_ar = "تدمر", lat = 34.5600, lng = 38.2672, tz = 3 }
    },

    -- Lebanon
    ["Lebanon"] = {
        { name = "Beirut", name_ar = "بيروت", lat = 33.8938, lng = 35.5018, tz = 2 },
        { name = "Tripoli", name_ar = "الشمال", lat = 34.4367, lng = 35.8497, tz = 2 }, -- طرابلس العاصمة الإدارية
        { name = "Sidon", name_ar = "الجنوب", lat = 33.5631, lng = 35.3689, tz = 2 }, -- صيدا العاصمة الإدارية
        { name = "Zahle", name_ar = "البقاع", lat = 33.8464, lng = 35.9020, tz = 2 }, -- زحلة العاصمة الإدارية
        { name = "Baabda", name_ar = "جبل لبنان", lat = 33.8333, lng = 35.5417, tz = 2 }, -- بعبدا العاصمة الإدارية
        { name = "Nabatieh", name_ar = "النبطية", lat = 33.3789, lng = 35.4839, tz = 2 },
        { name = "Baalbek", name_ar = "بعلبك الهرمل", lat = 34.0058, lng = 36.2064, tz = 2 }, -- بعلبك العاصمة الإدارية
        { name = "Halba", name_ar = "عكار", lat = 34.5422, lng = 36.0797, tz = 2 }, -- حلبا العاصمة الإدارية
        { name = "Marjayoun", name_ar = "كسروان جبيل", lat = 34.1222, lng = 35.6517, tz = 2 }, -- جونية/جبيل العاصمة الإدارية
        -- مدن ومناطق إضافية حيوية لفروق التوقيت والدقة
        { name = "Tyre", name_ar = "صور", lat = 33.2708, lng = 35.1964, tz = 2 },
        { name = "Jounieh", name_ar = "جونية", lat = 33.9811, lng = 35.6178, tz = 2 },
        { name = "Byblos", name_ar = "جبيل", lat = 34.1211, lng = 35.6481, tz = 2 }
    },

    -- Palestine
    ["Palestine"] = {
        { name = "Jerusalem", name_ar = "القدس", lat = 31.7683, lng = 35.2137, tz = 2 },
        { name = "Gaza", name_ar = "غزة", lat = 31.5017, lng = 34.4668, tz = 2 },
        { name = "Hebron", name_ar = "الخليل", lat = 31.5298, lng = 35.0998, tz = 2 },
        { name = "Nablus", name_ar = "نابلس", lat = 32.2211, lng = 35.2544, tz = 2 },
        { name = "Ramallah", name_ar = "رام الله", lat = 31.9029, lng = 35.2034, tz = 2 },
        { name = "Jenin", name_ar = "جنين", lat = 32.4646, lng = 35.2939, tz = 2 },
        { name = "Tulkarm", name_ar = "طولكرم", lat = 32.3117, lng = 35.0275, tz = 2 },
        { name = "Qalqilya", name_ar = "قلقيلية", lat = 32.1931, lng = 34.9811, tz = 2 },
        { name = "Bethlehem", name_ar = "بيت لحم", lat = 31.7058, lng = 35.2006, tz = 2 },
        { name = "Jericho", name_ar = "أريحا", lat = 31.8561, lng = 35.4631, tz = 2 },
        { name = "Salfit", name_ar = "سلفيت", lat = 32.0853, lng = 35.1814, tz = 2 },
        { name = "Tubas", name_ar = "طوباس", lat = 32.3214, lng = 35.3694, tz = 2 },
        { name = "Khan Yunis", name_ar = "خانيونس", lat = 31.3461, lng = 34.3039, tz = 2 },
        { name = "Rafah", name_ar = "رفح", lat = 31.2844, lng = 34.2536, tz = 2 },
        { name = "Deir al-Balah", name_ar = "دير البلح", lat = 31.4178, lng = 34.3531, tz = 2 },
        -- مدن فلسطينية حيوية أخرى لحساب المواقيت بدقة
        { name = "Haifa", name_ar = "حيفا", lat = 32.7940, lng = 34.9896, tz = 2 },
        { name = "Jaffa", name_ar = "يافا", lat = 32.0514, lng = 34.7522, tz = 2 },
        { name = "Nazareth", name_ar = "الناصرة", lat = 32.6996, lng = 35.3035, tz = 2 },
        { name = "Acre", name_ar = "عكا", lat = 32.9331, lng = 35.0828, tz = 2 },
        { name = "Safed", name_ar = "صفد", lat = 32.9658, lng = 35.4983, tz = 2 },
        { name = "Beersheba", name_ar = "بئر السبع", lat = 31.2518, lng = 34.7913, tz = 2 }
    },

    -- Yemen
    ["Yemen"] = {
        { name = "Sanaa", name_ar = "أمانة العاصمة (صنعاء)", lat = 15.3500, lng = 44.2075, tz = 3 },
        { name = "Aden", name_ar = "عدن", lat = 12.7794, lng = 45.0367, tz = 3 },
        { name = "Taiz", name_ar = "تعز", lat = 13.5794, lng = 44.0206, tz = 3 },
        { name = "Hodeidah", name_ar = "الحديدة", lat = 14.8014, lng = 42.9481, tz = 3 },
        { name = "Mukalla", name_ar = "حضرموت (المكلا)", lat = 14.5422, lng = 49.1242, tz = 3 },
        { name = "Ibb", name_ar = "إب", lat = 13.9667, lng = 44.1833, tz = 3 },
        { name = "Dhamar", name_ar = "ذمار", lat = 14.5425, lng = 44.4056, tz = 3 },
        { name = "Marib", name_ar = "مأرب", lat = 15.4628, lng = 45.3253, tz = 3 },
        { name = "Amran", name_ar = "عمران", lat = 15.6594, lng = 43.9439, tz = 3 },
        { name = "Saada", name_ar = "صعدة", lat = 16.9403, lng = 43.7639, tz = 3 },
        { name = "Hajjah", name_ar = "حجة", lat = 15.6939, lng = 43.6017, tz = 3 },
        { name = "Al Bayda", name_ar = "البيضاء", lat = 13.9853, lng = 45.5714, tz = 3 },
        { name = "Ataq", name_ar = "شبوة (عتق)", lat = 14.5956, lng = 46.8319, tz = 3 },
        { name = "Zinjibar", name_ar = "أبين (زنجبار)", lat = 13.1283, lng = 45.3806, tz = 3 },
        { name = "Al Ghaydah", name_ar = "المهرة (الغيضة)", lat = 16.2075, lng = 52.1761, tz = 3 },
        { name = "Al Mahwit", name_ar = "المحويت", lat = 15.4703, lng = 43.5414, tz = 3 },
        { name = "Raymah", name_ar = "ريمة", lat = 14.6192, lng = 43.7114, tz = 3 },
        { name = "Lahij", name_ar = "لحج", lat = 13.0567, lng = 44.8822, tz = 3 },
        { name = "Al Dhale'e", name_ar = "الضالع", lat = 13.6958, lng = 44.7314, tz = 3 },
        { name = "Al Jawf", name_ar = "الجوف", lat = 16.1667, lng = 44.8333, tz = 3 },
        { name = "Hadibu", name_ar = "سقطرى (حديبو)", lat = 12.6517, lng = 54.0175, tz = 3 },
        { name = "Sanaa Province", name_ar = "محافظة صنعاء", lat = 15.1114, lng = 44.3831, tz = 3 }
    },

    -- Libya
    ["Libya"] = {
        { name = "Tripoli", name_ar = "طرابلس", lat = 32.8872, lng = 13.1914, tz = 2 },
        { name = "Benghazi", name_ar = "بنغازي", lat = 32.1167, lng = 20.0667, tz = 2 },
        { name = "Misrata", name_ar = "مصراتة", lat = 32.3754, lng = 15.0925, tz = 2 },
        { name = "Bayda", name_ar = "البيضاء", lat = 32.7628, lng = 21.7550, tz = 2 },
        { name = "Zawiya", name_ar = "الزاوية", lat = 32.7522, lng = 12.7278, tz = 2 },
        { name = "Tobruk", name_ar = "طبرق", lat = 32.0836, lng = 23.9764, tz = 2 },
        { name = "Sebha", name_ar = "سبها", lat = 27.0377, lng = 14.4281, tz = 2 },
        { name = "Sirte", name_ar = "سيرت", lat = 31.2089, lng = 16.5887, tz = 2 },
        { name = "Khoms", name_ar = "الخمس", lat = 32.6486, lng = 14.2619, tz = 2 },
        { name = "Derna", name_ar = "درنة", lat = 32.7617, lng = 22.6425, tz = 2 },
        { name = "Ajdabiya", name_ar = "أجدابيا", lat = 30.7554, lng = 20.2264, tz = 2 },
        { name = "Zliten", name_ar = "زليتن", lat = 32.4674, lng = 15.7657, tz = 2 },
        { name = "Ghariyan", name_ar = "غريان", lat = 32.1722, lng = 13.0203, tz = 2 },
        { name = "Marj", name_ar = "المرج", lat = 32.4883, lng = 20.8317, tz = 2 },
        { name = "Tarhuna", name_ar = "ترهونة", lat = 32.4350, lng = 13.6331, tz = 2 },
        { name = "Ghadames", name_ar = "غدامس", lat = 30.1333, lng = 9.4833, tz = 2 },
        { name = "Ghat", name_ar = "غات", lat = 24.9633, lng = 10.1728, tz = 2 },
        { name = "Kufra", name_ar = "الكفرة", lat = 24.2928, lng = 23.2847, tz = 2 },
        { name = "Bani Walid", name_ar = "بني وليد", lat = 31.7566, lng = 13.9942, tz = 2 },
        { name = "Jalo", name_ar = "جالو", lat = 29.0331, lng = 21.5472, tz = 2 },
        { name = "Ubari", name_ar = "أوباري", lat = 26.5922, lng = 12.7806, tz = 2 },
        { name = "Nalut", name_ar = "نالوت", lat = 31.8681, lng = 10.9814, tz = 2 }
    },

    -- Tunisia
    ["Tunisia"] = {
        { name = "Tunis", name_ar = "تونس", lat = 36.8065, lng = 10.1815, tz = 1 },
        { name = "Sfax", name_ar = "صفاقس", lat = 34.7400, lng = 10.7600, tz = 1 },
        { name = "Sousse", name_ar = "سوسة", lat = 35.8256, lng = 10.6369, tz = 1 },
        { name = "Kairouan", name_ar = "القيروان", lat = 35.6781, lng = 10.0963, tz = 1 },
        { name = "Bizerte", name_ar = "بنزرت", lat = 37.2744, lng = 9.8739, tz = 1 },
        { name = "Gabes", name_ar = "قابس", lat = 33.8814, lng = 10.0983, tz = 1 },
        { name = "Aryanah", name_ar = "أريانة", lat = 36.8625, lng = 10.1956, tz = 1 },
        { name = "Ben Arous", name_ar = "بن عروس", lat = 36.7531, lng = 10.2222, tz = 1 },
        { name = "Manouba", name_ar = "منوبة", lat = 36.8078, lng = 10.1011, tz = 1 },
        { name = "Nabeul", name_ar = "نابلس", lat = 36.4561, lng = 10.7375, tz = 1 }, -- الحمامات / الوطن القبلي
        { name = "Zaghouan", name_ar = "زغوان", lat = 36.4025, lng = 10.1422, tz = 1 },
        { name = "Beja", name_ar = "باجة", lat = 36.7256, lng = 9.1817, tz = 1 },
        { name = "Jendouba", name_ar = "جندوبة", lat = 36.5011, lng = 8.7803, tz = 1 },
        { name = "Le Kef", name_ar = "الكاف", lat = 36.1822, lng = 8.7144, tz = 1 },
        { name = "Siliana", name_ar = "سليانة", lat = 36.0842, lng = 9.3708, tz = 1 },
        { name = "Sidi Bouzid", name_ar = "سيدي بوزيد", lat = 35.0381, lng = 9.4847, tz = 1 },
        { name = "Kasserine", name_ar = "القصرين", lat = 35.1675, lng = 8.8364, tz = 1 },
        { name = "Gafsa", name_ar = "قفصة", lat = 34.4250, lng = 8.7842, tz = 1 },
        { name = "Tozeur", name_ar = "توزر", lat = 33.9197, lng = 8.1336, tz = 1 },
        { name = "Kebili", name_ar = "قبلي", lat = 33.7042, lng = 8.9694, tz = 1 },
        { name = "Tataouine", name_ar = "تطاوين", lat = 32.9297, lng = 10.4517, tz = 1 },
        { name = "Medenine", name_ar = "مدنين", lat = 33.3547, lng = 10.4958, tz = 1 },
        { name = "Monastir", name_ar = "المنستير", lat = 35.7780, lng = 10.8262, tz = 1 },
        { name = "Mahdia", name_ar = "المهدية", lat = 35.5047, lng = 11.0622, tz = 1 },
        -- منطقة حيوية إضافية لفروق التوقيت والجزيرة
        { name = "Djerba", name_ar = "جربة", lat = 33.8075, lng = 10.8453, tz = 1 }
    },

    -- Algeria
    ["Algeria"] = {
        { name = "Adrar", name_ar = "أدرار", lat = 27.8739, lng = -0.2833, tz = 1 },
        { name = "Chlef", name_ar = "الشلف", lat = 36.1642, lng = 1.3317, tz = 1 },
        { name = "Laghouat", name_ar = "الأغواط", lat = 33.7997, lng = 2.8651, tz = 1 },
        { name = "Oum El Bouaghi", name_ar = "أم البواقي", lat = 35.8754, lng = 7.1135, tz = 1 },
        { name = "Batna", name_ar = "باتنة", lat = 35.5550, lng = 6.1741, tz = 1 },
        { name = "Béjaïa", name_ar = "بجاية", lat = 36.7559, lng = 5.0843, tz = 1 },
        { name = "Biskra", name_ar = "بسكرة", lat = 34.8504, lng = 5.7281, tz = 1 },
        { name = "Béchar", name_ar = "بشار", lat = 31.6167, lng = -2.2167, tz = 1 },
        { name = "Blida", name_ar = "البليدة", lat = 36.4700, lng = 2.8300, tz = 1 },
        { name = "Bouira", name_ar = "البويرة", lat = 36.3749, lng = 3.9015, tz = 1 },
        { name = "Tamanrasset", name_ar = "تمنراست", lat = 22.7850, lng = 5.5228, tz = 1 },
        { name = "Tébessa", name_ar = "تبسة", lat = 35.4042, lng = 8.1242, tz = 1 },
        { name = "Tlemcen", name_ar = "تلمسان", lat = 34.8783, lng = -1.3150, tz = 1 },
        { name = "Tiaret", name_ar = "تيارت", lat = 35.3710, lng = 1.3170, tz = 1 },
        { name = "Tizi Ouzou", name_ar = "تيزي وزو", lat = 36.7118, lng = 4.0459, tz = 1 },
        { name = "Algiers", name_ar = "الجزائر", lat = 36.7525, lng = 3.0420, tz = 1 },
        { name = "Djelfa", name_ar = "الجلفة", lat = 34.6728, lng = 3.2531, tz = 1 },
        { name = "Jijel", name_ar = "جيجل", lat = 36.8206, lng = 5.7661, tz = 1 },
        { name = "Sétif", name_ar = "سطيف", lat = 36.1911, lng = 5.4137, tz = 1 },
        { name = "Saïda", name_ar = "سعيدة", lat = 34.8303, lng = 0.1517, tz = 1 },
        { name = "Skikda", name_ar = "سكيكدة", lat = 36.8780, lng = 6.9042, tz = 1 },
        { name = "Sidi Bel Abbès", name_ar = "سيدي بلعباس", lat = 35.1899, lng = -0.6308, tz = 1 },
        { name = "Annaba", name_ar = "عنابة", lat = 36.9000, lng = 7.7667, tz = 1 },
        { name = "Guelma", name_ar = "قالمة", lat = 36.4621, lng = 7.4261, tz = 1 },
        { name = "Constantine", name_ar = "قسنطينة", lat = 36.3650, lng = 6.6147, tz = 1 },
        { name = "Médéa", name_ar = "المدية", lat = 36.2642, lng = 2.7539, tz = 1 },
        { name = "Mostaganem", name_ar = "مستغانم", lat = 35.9333, lng = 0.0903, tz = 1 },
        { name = "M'Sila", name_ar = "المسيلة", lat = 35.7058, lng = 4.5420, tz = 1 },
        { name = "Mascara", name_ar = "معسكر", lat = 35.3999, lng = 0.1403, tz = 1 },
        { name = "Ouargla", name_ar = "ورقلة", lat = 31.9493, lng = 5.3250, tz = 1 },
        { name = "Oran", name_ar = "وهران", lat = 35.6971, lng = -0.6308, tz = 1 },
        { name = "El Bayadh", name_ar = "البيض", lat = 33.6803, lng = 1.0193, tz = 1 },
        { name = "Illizi", name_ar = "إليزي", lat = 26.4833, lng = 8.4667, tz = 1 },
        { name = "Bordj Bou Arréridj", name_ar = "برج بوعريريج", lat = 36.0733, lng = 4.7611, tz = 1 },
        { name = "Boumerdès", name_ar = "بومرداس", lat = 36.7594, lng = 3.4731, tz = 1 },
        { name = "El Tarf", name_ar = "الطارف", lat = 36.7669, lng = 8.3137, tz = 1 },
        { name = "Tindouf", name_ar = "تندوف", lat = 27.6711, lng = -8.1478, tz = 1 },
        { name = "Tissemsilt", name_ar = "تيسمسيلت", lat = 35.6072, lng = 1.8106, tz = 1 },
        { name = "El Oued", name_ar = "الوادي", lat = 33.3678, lng = 6.8516, tz = 1 },
        { name = "Khenchela", name_ar = "خنشلة", lat = 35.4358, lng = 7.1433, tz = 1 },
        { name = "Souk Ahras", name_ar = "سوق أهراس", lat = 36.2864, lng = 7.9511, tz = 1 },
        { name = "Tipaza", name_ar = "تيبازة", lat = 36.5897, lng = 2.4475, tz = 1 },
        { name = "Mila", name_ar = "ميلة", lat = 36.4503, lng = 6.2644, tz = 1 },
        { name = "Aïn Defla", name_ar = "عين الدفلى", lat = 36.2642, lng = 1.9703, tz = 1 },
        { name = "Naâma", name_ar = "النعامة", lat = 33.2667, lng = -0.3167, tz = 1 },
        { name = "Aïn Témouchent", name_ar = "عين تموشنت", lat = 35.2975, lng = -1.1403, tz = 1 },
        { name = "Ghardaïa", name_ar = "غرداية", lat = 32.4906, lng = 3.6733, tz = 1 },
        { name = "Relizane", name_ar = "غليزان", lat = 35.7372, lng = 0.5558, tz = 1 },
        -- الولايات الجديدة (التقسيم الإداري الأخير)
        { name = "El M'Ghair", name_ar = "المغير", lat = 33.9500, lng = 6.0000, tz = 1 },
        { name = "El Meniaa", name_ar = "المنيعة", lat = 30.5833, lng = 2.8833, tz = 1 },
        { name = "Ouled Djellal", name_ar = "أولاد جلال", lat = 34.4267, lng = 5.0642, tz = 1 },
        { name = "Bordj Badji Mokhtar", name_ar = "برج باجي مختار", lat = 21.3275, lng = 0.9539, tz = 1 },
        { name = "Béni Abbès", name_ar = "بني عباس", lat = 30.0833, lng = -2.1667, tz = 1 },
        { name = "Timimoun", name_ar = "تيميمون", lat = 29.2639, lng = 0.2306, tz = 1 },
        { name = "Touggourt", name_ar = "تقرت", lat = 33.1000, lng = 6.0667, tz = 1 },
        { name = "Djanet", name_ar = "جانت", lat = 24.5500, lng = 9.4833, tz = 1 },
        { name = "In Salah", name_ar = "عين صالح", lat = 27.1956, lng = 2.4764, tz = 1 },
        { name = "In Guezzam", name_ar = "عين قزام", lat = 19.5667, lng = 5.7667, tz = 1 }
    },

    -- Morocco
    ["Morocco"] = {
        { name = "Rabat", name_ar = "الرباط", lat = 34.0209, lng = -6.8416, tz = 1 }, -- العاصمة الإدارية للبلاد
        { name = "Casablanca", name_ar = "الدار البيضاء", lat = 33.5731, lng = -7.5898, tz = 1 },
        { name = "Marrakesh", name_ar = "مراكش", lat = 31.6295, lng = -7.9811, tz = 1 },
        { name = "Fes", name_ar = "فاس", lat = 34.0331, lng = -5.0003, tz = 1 },
        { name = "Tangier", name_ar = "طنجة", lat = 35.7595, lng = -5.8340, tz = 1 },
        { name = "Agadir", name_ar = "أكادير", lat = 30.4278, lng = -9.5981, tz = 1 },
        { name = "Oujda", name_ar = "وجدة", lat = 34.6867, lng = -1.9114, tz = 1 },
        { name = "Meknes", name_ar = "مكناس", lat = 33.8935, lng = -5.5473, tz = 1 },
        { name = "Tetouan", name_ar = "تطوان", lat = 35.5889, lng = -5.3626, tz = 1 },
        { name = "Errachidia", name_ar = "الرشيدية", lat = 31.9317, lng = -4.4244, tz = 1 },
        { name = "Guelmim", name_ar = "كلميم", lat = 28.9864, lng = -10.0572, tz = 1 },
        { name = "Laayoune", name_ar = "العيون", lat = 27.1500, lng = -13.2000, tz = 1 },
        { name = "Dakhla", name_ar = "الداخلية", lat = 23.6848, lng = -15.9580, tz = 1 },
        { name = "Beni Mellal", name_ar = "بني ملال", lat = 32.3373, lng = -6.3498, tz = 1 },
        -- مدن حيوية وتاريخية إضافية لأهميتها الجغرافية في فروق التوقيت
        { name = "Chefchaouen", name_ar = "شفشاون", lat = 35.1713, lng = -5.2697, tz = 1 },
        { name = "Nador", name_ar = "الناظور", lat = 35.1667, lng = -2.9333, tz = 1 },
        { name = "Safi", name_ar = "آسفي", lat = 32.2994, lng = -9.2372, tz = 1 },
        { name = "Ouarzazate", name_ar = "ورزازات", lat = 30.9189, lng = -6.8934, tz = 1 }
    },

    -- Sudan
    ["Sudan"] = {
        { name = "Khartoum", name_ar = "الخرطوم", lat = 15.5007, lng = 32.5599, tz = 2 }, -- العاصمة الاتحادية
        { name = "Omdurman", name_ar = "أم درمان", lat = 15.6500, lng = 32.4833, tz = 2 },
        { name = "Port Sudan", name_ar = "بورتسودان", lat = 19.6158, lng = 37.2164, tz = 2 }, -- البحر الأحمر
        { name = "Wad Madani", name_ar = "ود مدني", lat = 14.4012, lng = 33.5199, tz = 2 }, -- الجزيرة
        { name = "El Obeid", name_ar = "الأبيض", lat = 13.1842, lng = 30.2014, tz = 2 }, -- شمال كردفان
        { name = "Nyala", name_ar = "نيالا", lat = 12.0500, lng = 24.8833, tz = 2 }, -- جنوب دارفور
        { name = "Al Qadarif", name_ar = "القضارف", lat = 14.0349, lng = 35.3834, tz = 2 },
        { name = "Kassala", name_ar = "كسلا", lat = 15.4510, lng = 36.4000, tz = 2 },
        { name = "Ad-Damazin", name_ar = "الدمازين", lat = 11.7611, lng = 34.3417, tz = 2 }, -- النيل الأزرق
        { name = "Kosti", name_ar = "كوشتي", lat = 13.1629, lng = 32.6635, tz = 2 }, -- النيل الأبيض
        { name = "Sennar", name_ar = "سنار", lat = 13.5691, lng = 33.5672, tz = 2 },
        { name = "Ad-Damir", name_ar = "الدامر", lat = 17.5917, lng = 33.9592, tz = 2 }, -- نهر النيل
        { name = "Dongola", name_ar = "دنقلا", lat = 19.1648, lng = 30.4725, tz = 2 }, -- الولاية الشمالية
        { name = "Kadugli", name_ar = "كادوقلي", lat = 11.0114, lng = 29.7167, tz = 2 }, -- جنوب كردفان
        { name = "Al-Fashir", name_ar = "الفاشر", lat = 13.6167, lng = 25.3500, tz = 2 }, -- شمال دارفور
        { name = "Al-Geneina", name_ar = "الجنينة", lat = 13.4500, lng = 22.4500, tz = 2 }, -- غرب دارفور
        { name = "Zalingei", name_ar = "زالنجي", lat = 12.9094, lng = 23.4752, tz = 2 }, -- وسط دارفور
        { name = "Al-Du'ayn", name_ar = "الضعين", lat = 11.4097, lng = 26.1264, tz = 2 }, -- شرق دارفور
        { name = "Al-Fulah", name_ar = "الفولة", lat = 11.8000, lng = 28.4000, tz = 2 } -- غرب كردفان
    },

    -- Mauritania
    ["Mauritania"] = {
        { name = "Nouakchott", name_ar = "نواكشوط", lat = 18.0858, lng = -15.9785, tz = 0 }, -- العاصمة الاتحادية (تشمل ولايات نواكشوط الثلاث)
        { name = "Néma", name_ar = "النعمة", lat = 16.6167, lng = -7.2500, tz = 0 }, -- الحوض الشرقي
        { name = "Aïoun", name_ar = "عيون العتروس", lat = 16.6333, lng = -9.6167, tz = 0 }, -- الحوض الغربي
        { name = "Kiffa", name_ar = "كيفة", lat = 16.6167, lng = -11.4000, tz = 0 }, -- لعصابة
        { name = "Kaédi", name_ar = "كيهيدي", lat = 16.1500, lng = -13.5000, tz = 0 }, -- كوركول
        { name = "Aleg", name_ar = "ألاك", lat = 17.0500, lng = -13.9167, tz = 0 }, -- لبراكنة
        { name = "Rosso", name_ar = "روصو", lat = 16.5167, lng = -15.8050, tz = 0 }, -- اترارزة
        { name = "Nouadhibou", name_ar = "نواذيبو", lat = 20.9309, lng = -17.0347, tz = 0 }, -- داخلة نواذيبو
        { name = "Atar", name_ar = "أطار", lat = 20.5167, lng = -13.0500, tz = 0 }, -- آدرار
        { name = "Tidjikja", name_ar = "تجكجة", lat = 18.5564, lng = -11.4322, tz = 0 }, -- تكانت
        { name = "Sélibaby", name_ar = "سيلبابي", lat = 15.1500, lng = -12.1833, tz = 0 }, -- كيدي ماغا
        { name = "Zouérat", name_ar = "ازويرات", lat = 22.7444, lng = -12.4533, tz = 0 }, -- تيرس زمور
        { name = "Akjoujt", name_ar = "أكجوجت", lat = 19.7500, lng = -14.3833, tz = 0 } -- إنشيري
    },

    -- Somalia
    ["Somalia"] = {
        { name = "Mogadishu", name_ar = "مقديشو", lat = 2.0439, lng = 45.3423, tz = 3 }, -- العاصمة الاتحادية / بنادر
        { name = "Hargeisa", name_ar = "هرجيسا", lat = 9.5624, lng = 44.0652, tz = 3 }, -- أرض الصومال
        { name = "Garowe", name_ar = "غاروي", lat = 8.4054, lng = 48.4842, tz = 3 }, -- بونتلاند / نغال
        { name = "Kismayo", name_ar = "كيسمايو", lat = -0.3582, lng = 42.5454, tz = 3 }, -- جوبالاند / جوبا السفلى
        { name = "Baidoa", name_ar = "بيدوا", lat = 3.1138, lng = 43.6492, tz = 3 }, -- جنوب الغرب / باي
        { name = "Dhusamareb", name_ar = "دوسمريب", lat = 5.5311, lng = 46.3861, tz = 3 }, -- جالمودوج / جالجودود
        { name = "Jowhar", name_ar = "جوهر", lat = 2.7803, lng = 45.5005, tz = 3 }, -- هيرشبيلي / شبيلي الوسطى
        { name = "Beledweyne", name_ar = "بلد وين", lat = 4.7417, lng = 45.2042, tz = 3 }, -- هيران
        { name = "Bossaso", name_ar = "بوساسو", lat = 11.2842, lng = 49.1814, tz = 3 }, -- باري
        { name = "Galkayo", name_ar = "جالكعيو", lat = 6.7694, lng = 47.4308, tz = 3 }, -- مدج
        { name = "Burao", name_ar = "برعو", lat = 9.5211, lng = 45.5342, tz = 3 }, -- توغدير
        { name = "Merca", name_ar = "مركة", lat = 1.7158, lng = 44.7717, tz = 3 } -- شبيلي السفلى
    },

    -- Djibouti
    ["Djibouti"] = {
        { name = "Djibouti City", name_ar = "جيبوتي العاصمة", lat = 11.5880, lng = 43.1450, tz = 3 },
        { name = "Ali Sabieh", name_ar = "علي صبيح", lat = 11.1558, lng = 42.7125, tz = 3 },
        { name = "Tadjourah", name_ar = "تاجورة", lat = 11.7853, lng = 42.8856, tz = 3 },
        { name = "Dikhil", name_ar = "دخيل", lat = 11.1114, lng = 42.3731, tz = 3 },
        { name = "Obock", name_ar = "أوبوخ", lat = 11.9631, lng = 43.2881, tz = 3 },
        { name = "Arta", name_ar = "عرتا", lat = 11.5239, lng = 42.8461, tz = 3 }
    },

    -- Comoros
    ["Comoros"] = {
        { name = "Moroni", name_ar = "موروني", lat = -11.7022, lng = 43.2551, tz = 3 }, -- العاصمة الاتحادية / جزيرة القمر الكبرى
        { name = "Mutsamudu", name_ar = "موتسامودو", lat = -12.1667, lng = 44.4000, tz = 3 }, -- جزيرة أنجوان
        { name = "Fomboni", name_ar = "فومبوني", lat = -12.2800, lng = 43.7425, tz = 3 }, -- جزيرة موهيلي
        { name = "Domoni", name_ar = "دوموني", lat = -12.2569, lng = 44.5319, tz = 3 }, -- مدينة رئيسية في أنجوان
        { name = "Mamoudzou", name_ar = "مامودزو (مايوت)", lat = -12.7806, lng = 45.2317, tz = 3 } -- جزيرة مايوت (جغرافياً ضمن الأرخبيل)
    },

}

local country_names_ar = {
    ["Saudi Arabia"] = "المملكة العربية السعودية",
    ["Egypt"] = "مصر",
    ["UAE"] = "الإمارات العربية المتحدة",
    ["Qatar"] = "قطر",
    ["Kuwait"] = "الكويت",
    ["Bahrain"] = "البحرين",
    ["Oman"] = "سلطنة عمان",
    ["Iraq"] = "العراق",
    ["Jordan"] = "الأردن",
    ["Syria"] = "سوريا",
    ["Lebanon"] = "لبنان",
    ["Palestine"] = "فلسطين",
    ["Yemen"] = "اليمن",
    ["Libya"] = "ليبيا",
    ["Tunisia"] = "تونس",
    ["Algeria"] = "الجزائر",
    ["Morocco"] = "المغرب",
    ["Sudan"] = "السودان",
    ["Mauritania"] = "موريتانيا",
    ["Somalia"] = "الصومال",
    ["Djibouti"] = "جيبوتي",
    ["Comoros"] = "جزر القمر",
}

return {
    locations = locations,
    country_names_ar = country_names_ar,
}