# Prayer Times for KOReader – User Guide (English)

Version 1.0.1

**Repository:** [github.com/Mahmoudgomaa001/koreader.prayertimes](https://github.com/Mahmoudgomaa001/koreader.prayertimes)

## Introduction

Prayer Times is a plugin for KOReader that displays Islamic prayer times, the Hijri date, and fasting reminders for your selected location. It supports multiple calculation methods, custom fonts, and a fully bilingual Arabic/English interface.

## Features

- Accurate prayer time calculation (Fajr, Sunrise, Dhuhr, Asr, Maghrib, Isha)
- Seven calculation methods (MWL, Egyptian, Umm al-Qura, Karachi, ISNA, Jafari, Tehran)
- Asr jurisprudence (Shafi/Hanafi) selection
- Hijri calendar with manual adjustment (-5 to +5 days)
- Fasting day reminders:
  - Mondays and Thursdays
  - White days (13, 14, 15 Hijri)
  - Ashura (10 Muharram)
  - Arafah (9 Dhul-Hijjah)
  - Six days of Shawwal
- Customizable display:
  - Language (English/العربية)
  - Time format (12/24 hour)
  - Clock mode (static/live/prayer only)
  - Font style (built-in + custom fonts)
  - Font size adjustment
  - Status widgets (battery, WiFi, memory)
  - Screen brightness control
- Auto-show on device wake (battery‑friendly)
- Location database with auto suggestion of calculation method
- Add custom locations manually
- Alert options (flash screen, show message, frontlight pulse)

> ℹ️ **Battery‑Friendly Design:**  
> This plugin does **not** keep your device awake in the background. It shows prayer times only when you open it, or optionally when the device wakes from sleep (if enabled). This approach helps preserve battery life on e‑ink devices like Kindle. The plugin is designed to be as power‑efficient as possible.

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
5. Or add a new city via **Add new location**.

## Configuration Menu

The plugin adds a "Prayer Times" entry to the Tools menu with these submenus:

### Launch

Opens the prayer times screen for the current day.

### Set Location

- **Choose from list**: browse built-in countries/cities.
- **Add new location**: enter country, city, latitude, longitude manually.
- **Daylight Saving Time**: adjust DST (0, +1, +2, -1 hours).

### Calculation Settings

- **Calculation Method**: MWL, Egyptian, Umm al-Qura, Karachi, ISNA, Jafari, Tehran.
- **Asr Jurisprudence**: Shafi (shadow = object length) or Hanafi (shadow = 2× object length).

### Hijri Date and Fasting

- **Show Hijri date**: display Hijri date alongside Gregorian.
- **Hijri date adjustment**: manually shift the Hijri date (-5..+5 days).
- **Show fasting reminders**: enable/disable fasting lines.
- **Remind me in advance**: choose how many days ahead to show fasting reminders (0=only on fasting day, 1=day before + day itself, 2=two days before + one day before + day itself).
- **Fasting types**: enable/disable specific fasting categories:
  - Mondays and Thursdays
  - White days (13, 14, 15 Hijri)
  - Ashura (10 Muharram)
  - Arafah (9 Dhul Hijjah)
  - Six days of Shawwal

### Display and Appearance

- **Language**: English or العربية.
- **Time format**: 24-hour or 12-hour (AM/PM).
- **Clock mode**: Static (no auto refresh), Live (refresh every minute), Prayer time only (refresh at next prayer).
- **Font style**: choose built-in fonts or custom fonts you added.
- **Font size adjustment**: global font size offset (−15..+20).
- **Screen brightness**: set widget brightness (0..24, -1 = no change).
- **Status bar items**: toggle battery, WiFi, memory widgets.
- **Show automatically on wake**: open the widget when the device wakes from sleep. This is a battery‑friendly way to see prayer times without keeping the device awake.

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
   - **Calculation Method**: choose the same method in **Calculation Settings**.
   - **Asr Jurisprudence**: select Shafi or Hanafi as shown.
6. If you prefer not to share your location, you can manually search for your city using the search box.

### Manual search on timesprayer.com

If you don't want to use "My Location", you can manually search:

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
- City name (English) – e.g., Khanka
- City name (Arabic) – e.g., الخانكة
- Latitude – e.g., 30.099711
- Longitude – e.g., 31.328638

The timezone is calculated automatically from longitude. The calculation method is auto-suggested based on country, but you can override it manually.

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

**Incorrect prayer times**: Verify your location coordinates and timezone. Use timesprayer.com to confirm the correct calculation method for your city.

**No icons or images**: Ensure the `images` folder exists inside the plugin folder and contains the required PNG files.

**Battery drains quickly**: This plugin is designed to be battery‑friendly. It does not run in the background. If you have enabled "Show automatically on wake", it only appears briefly when the device wakes. If battery is still a concern, disable that option and launch manually.

## FAQ

**Can I use it on Kobo?**
Yes, the plugin works on any KOReader installation.

**Does it need internet?**
No, all calculations are done locally. The timesprayer.com website is only used to find your coordinates and method.

**How accurate is it?**
It uses standard astronomical formulas. Accuracy depends on the calculation method and location.

**Does it keep my device awake?**
No, the plugin does not keep the device awake. It only shows when opened or when the device wakes (if enabled).

## License

MIT License – see LICENSE file.

## Contributing

Pull requests are welcome. Please test on your device before submitting.

## Updates & Issues

For the latest updates, bug reports, or feature requests, visit the [repository](https://github.com/Mahmoudgomaa001/koreader.prayertimes).

## Credits

Developed for the KOReader community.
