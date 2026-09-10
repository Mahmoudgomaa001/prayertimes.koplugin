# Prayer Times for KOReader – User Guide (English)

Version 1.2.0

**Repository:** [github.com/Mahmoudgomaa001/prayertimes.koplugin](https://github.com/Mahmoudgomaa001/prayertimes.koplugin)

## Introduction

Prayer Times is a plugin for KOReader that displays Islamic prayer times, the Hijri date, and fasting reminders for your selected location. It supports nine calculation methods, custom fonts, per-prayer corrections, high-latitude estimation, and a fully bilingual Arabic/English interface with Arabic-Indic digits.

## Features

- Accurate prayer time calculation (Fajr, Sunrise, Dhuhr, Asr, Maghrib, Isha)
- Nine calculation methods: IAC Standard, MWL, Egyptian, Moroccan, Umm al-Qura, Karachi, ISNA, Jafari, Tehran
- Automatic calculation method and Asr madhhab selection based on country
- Per-prayer manual corrections (±30 minutes for each prayer independently)
- Hijri calendar with manual adjustment (-3 to +3 days)
- Ramadan mode for Umm al-Qura (auto-detect or force override)
- Fasting day reminders:
  - Mondays and Thursdays
  - White days (13, 14, 15 Hijri)
  - Ashura (10 Muharram)
  - Arafah (9 Dhul-Hijjah)
  - Six days of Shawwal
- High-latitude support with five configurable estimation rules
- Arabic-Indic digits (١٢٣) when interface is set to Arabic
- City search — type to filter 200+ cities instantly in Arabic or English
- Customizable display:
  - Language (English/العربية)
  - Time format (12/24 hour)
  - Clock mode (static/live/prayer only)
  - Font style (built-in + custom fonts)
  - Per-font size adjustment with live preview
  - Status widgets (battery, WiFi, memory)
  - Screen brightness control
- Optional DST clock offset — apply DST to plugin clock independently
- Auto-show on device wake (battery-friendly)
- Location database with 22 countries and 200+ cities
- Auto-suggestion of calculation method and Asr madhhab
- Add custom locations with integrated coordinate guide
- Alert options (flash screen, show message, frontlight pulse)

> ℹ️ **Battery-Friendly Design:**
> This plugin does **not** keep your device awake in the background. It shows prayer times only when you open it, or optionally when the device wakes from sleep (if enabled). This approach helps preserve battery life on e-ink devices like Kindle. The plugin is designed to be as power-efficient as possible.

## Installation

1. Download the latest release ZIP from the GitHub Releases page.
2. Connect your e-reader to your computer via USB.
3. Extract the ZIP file. You will get a folder named `prayertimes.koplugin`.
4. Copy that entire folder into the KOReader **plugins** directory:
   - **Kindle**: `koreader/plugins/`
   - **Kobo**: `.adds/koreader/plugins/`
   - **Android**: `koreader/plugins/`
     The final path must look like: `koreader/plugins/prayertimes.koplugin/`
5. Safely eject the device.
6. Restart KOReader completely.

> **Important**: The folder must be named exactly `prayertimes.koplugin` (including the `.koplugin` suffix). Do not rename it, and do not place its files directly inside `plugins/`.

## Quick Start

1. Open KOReader.
2. Go to **Tools → Prayer Times**.
3. Select **Launch** to see today's prayer times.
4. To change location: **Set Location → Choose from list**.
5. To search for a city: tap **🔍 Search for a city...** at the top of the list and type in Arabic or English.
6. Or add a new city via **Add new location** — a step-by-step guide using timesprayer.com will appear automatically.

## Configuration Menu

The plugin adds a "Prayer Times" entry to the Tools menu with these submenus:

### Launch

Opens the prayer times screen for the current day.

### Set Location

- **Choose from list**: browse built-in countries and cities (22 countries, 200+ cities). Tap **🔍 Search for a city...** at the top to filter by typing in Arabic or English.
- **Add new location**: enter country, city, latitude, and longitude manually. A step-by-step guide using timesprayer.com is shown automatically.
- **Daylight Saving Time**: adjust DST offset (0, +1, +2, -1 hours).
  - **Apply DST to plugin clock**: when enabled, the DST offset is added to the displayed clock. When disabled, the plugin clock matches the Kindle clock exactly. DST always affects prayer time calculations regardless of this setting.

### Calculation Settings

- **Calculation Method**: IAC Standard, MWL, Egyptian, Moroccan, Umm al-Qura, Karachi, ISNA, Tehran, Jafari.
- **Asr Jurisprudence**: Shafi (shadow = object length) or Hanafi (shadow = 2× object length). Auto-selected based on country (Hanafi for South Asia and Turkey, Shafi for all others).
- **Per-Prayer Corrections**: adjust each prayer time independently by ±30 minutes. Useful for matching local mosque timetables.
- **Northern Regions (High Latitude)**: five estimation rules for locations where astronomical twilight does not occur:
  - Show real times only (--:-- if unavailable)
  - One-seventh of the night
  - Middle of the night
  - Angle-based portion of night
  - Fixed minutes from sunrise/sunset
  - Tap **ℹ️ What is this?** for a full explanation.

### Hijri Date and Fasting

- **Show Hijri date**: display Hijri date alongside Gregorian.
- **Hijri date adjustment**: manually shift the Hijri date (-3..+3 days).
- **Ramadan Mode (Umm al-Qura)**: controls the Isha interval for Umm al-Qura method:
  - Automatic (calculated Hijri) — uses the tabular Hijri calendar to detect Ramadan
  - Force Ramadan (120 min Isha) — always use the Ramadan interval
  - Force Normal (90 min Isha) — always use the normal interval
- **Show fasting reminders**: enable/disable fasting reminder lines.
- **Remind me in advance**: choose how many days ahead to show fasting reminders (0 = only on fasting day, 1 = day before + day itself, 2 = two days before + one day before + day itself).
- **Fasting types**: enable/disable specific fasting categories individually:
  - Mondays and Thursdays
  - White days (13, 14, 15 Hijri)
  - Ashura (10 Muharram)
  - Arafah (9 Dhul Hijjah)
  - Six days of Shawwal

### Display and Appearance

- **Language**: English or العربية. When Arabic is selected, all numbers display as Arabic-Indic digits (١٢٣).
- **Time format**: 24-hour or 12-hour (AM/PM).
- **Clock mode**: Static (no auto refresh), Live (refresh every minute), Prayer time only (refresh at next prayer).
- **Font style**: choose built-in fonts or custom fonts you added. Includes a live preview carousel with font size adjustment.
- **Screen brightness**: set widget brightness (0..24, -1 = no change). Brightness is automatically restored when the widget is closed.
- **Status bar items**: toggle battery, WiFi, memory widgets. Battery format options: icon only, percent only, or both.
- **Show automatically on wake**: open the widget when the device wakes from sleep. This is a battery-friendly way to see prayer times without keeping the device awake.

### Alerts

- **Flash screen**: flash the screen at next prayer time.
- **Frontlight pulse**: briefly change frontlight (if supported).
- **Show message**: display an InfoMessage with the next prayer name.
- **Frontlight duration**: seconds for the pulse (1..30).

### About

Shows version and feature summary.

## Adding a Custom Location

You need latitude and longitude in decimal degrees.

### Easiest method: Use "My Location" on timesprayer.com

1. Open your web browser and go to:
   [https://timesprayer.com/](https://timesprayer.com/)
2. Click the **"My Location"** button (or **"جد مكاني"** in Arabic).
   The website will request permission to access your location.
3. Allow the permission. The site will automatically detect your coordinates, timezone, and the appropriate calculation method.
4. The page will show your location name, latitude/longitude, calculation method, and timezone.
5. Use these values in the plugin:
   - **Latitude and Longitude**: add a custom location with these numbers.
   - **Calculation Method**: auto-suggested based on your country (you can change it).
   - **Asr Jurisprudence**: auto-suggested based on your country (you can change it).
6. If you prefer not to share your location, you can manually search for your city using the search box.

### Manual search on timesprayer.com

1. Go to [https://timesprayer.com/](https://timesprayer.com/)
2. In the search box, type your city name (Arabic or English).
   Example: `Khanka` or `الخانكة`
3. The website will display prayer times for that city.
4. Scroll down or look for the settings section. You will see:
   - **Latitude, Longitude** – e.g., `30.099711, 31.328638`
   - **Calc Method** – e.g., `Egyptian General Authority of Survey`
   - **Juristic Methods** – e.g., `Standard (Shafi, Hanbali, Maliki)`
   - **TimeZone** – e.g., `Africa/Cairo (UTC+3)`
5. Use these values in the plugin accordingly.

### Input fields (for manual entry):

- Country name (English) – e.g., Egypt
- Country name (Arabic) – e.g., مصر
- City name (English) – e.g., Cairo
- City name (Arabic) – e.g., القاهرة
- Latitude – e.g., 30.0444
- Longitude – e.g., 31.2357

The timezone is calculated automatically from longitude. The calculation method and Asr madhhab are auto-suggested based on country, but you can override both manually.

## Custom Fonts

The plugin supports adding your own font files (.ttf or .otf).

### On Kindle:

1. Connect Kindle via USB.
2. Open the Kindle drive (usually `E:`).
3. Create or open the `fonts` folder at the root (`E:\fonts`).
4. Copy your font files into it.
5. Eject safely.
6. Restart KOReader completely.
7. In Prayer Times menu: **Display and Appearance → Font style → My fonts** to select.

### On other devices:

- The plugin also scans its own `fonts` folder inside `prayertimes.koplugin`. You can place fonts there and they will be auto-installed to a writable system font directory.

## Fasting Reminders

The widget shows fasting reminders based on the settings you choose. For example, if "Remind me in advance" is set to 2 days, and a fasting day is 3 days away, you will see:

- "Fasting in two days: White days" (two days before)
- "Fasting tomorrow: White days" (one day before)
- "Fasting today: White days" (on the day itself)

You can disable any fasting type individually.

## Troubleshooting

**Widget does not open**: Check that the plugin folder is correctly placed and KOReader was restarted.

**Font not showing**: Make sure the font file is .ttf or .otf and placed in the correct folder. Restart KOReader.

**Incorrect prayer times**: Verify your location coordinates and timezone. Use timesprayer.com to confirm the correct calculation method for your city. You can also use per-prayer corrections to fine-tune.

**Clock does not match Kindle**: The plugin clock matches the Kindle clock by default. If you enabled "Apply DST to plugin clock", the DST offset is added to the displayed clock. Disable it to sync with the Kindle clock.

**No icons or images**: Ensure the `images` folder exists inside the plugin folder and contains the required PNG files.

**Battery drains quickly**: This plugin is designed to be battery-friendly. It does not run in the background. If you have enabled "Show automatically on wake", it only appears briefly when the device wakes. If battery is still a concern, disable that option and launch manually.

**Prayer times show --:--**: This occurs at high latitudes when the sun does not reach the required angle. Enable a high-latitude estimation rule in **Calculation Settings → Northern Regions**.

## FAQ

**Can I use it on Kobo?**
Yes, the plugin works on any KOReader installation.

**Does it need internet?**
No, all calculations are done locally and offline. The timesprayer.com website is only used to find your coordinates and method.

**How accurate is it?**
It uses standard astronomical formulas based on research by Mohammad Shawkat Odeh / International Astronomical Center (IAC). Accuracy depends on the calculation method and location. For best results, compare with your local mosque timetable and use per-prayer corrections if needed.

**Does it keep my device awake?**
No, the plugin does not keep the device awake. It only shows when opened or when the device wakes (if enabled).

**Why are there 9 methods now?**
Version 1.2.0 added the IAC Standard method (with latitude-aware Isha angle) and the Moroccan method (19°/17° for Morocco and Mauritania).

**Can I match my local mosque timetable exactly?**
Yes. Use **Calculation Settings → Per-Prayer Corrections** to add or subtract minutes from each prayer independently.

## License

MIT License – see LICENSE file.

## Contributing

Pull requests are welcome. Please test on your device before submitting.

## Updates & Issues

For the latest updates, bug reports, or feature requests, visit the [repository](https://github.com/Mahmoudgomaa001/prayertimes.koplugin).

## Credits

Developed for the KOReader community.
Astronomical basis: Mohammad Shawkat Odeh / International Astronomical Center (IAC).