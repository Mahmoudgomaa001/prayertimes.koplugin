# Prayer Times for KOReader

**English** | [**العربية**](docs/README.ar.md)

**Version:** 1.2.0

**Repository:** [github.com/Mahmoudgomaa001/prayertimes.koplugin](https://github.com/Mahmoudgomaa001/prayertimes.koplugin)

A comprehensive Islamic prayer times plugin for KOReader, supporting multiple calculation methods, Hijri calendar, fasting reminders, custom fonts, and a bilingual Arabic/English interface.

![Prayer Times Main Screen](docs/images/sc-ar.png)

## Features

- **Accurate prayer time calculation** (Fajr, Sunrise, Dhuhr, Asr, Maghrib, Isha)
- **Nine calculation methods**: IAC Standard, MWL, Egyptian, Moroccan, Umm al-Qura, Karachi, ISNA, Tehran, Jafari
- **Auto method & madhhab selection** based on your country
- **Per-prayer manual corrections** (±30 minutes for each prayer)
- **Hijri calendar** with manual adjustment (±3 days)
- **Ramadan mode** for Umm al-Qura (auto-detects or force override)
- **Fasting day reminders** (Mondays/Thursdays, White Days, Ashura, Arafah, Six Shawwal)
- **High-latitude support** with configurable estimation rules
- **Arabic-Indic digits** (١٢٣) when interface is set to Arabic
- **City search** — type to filter 200+ cities instantly
- **Customizable display** (fonts, sizes, status widgets, brightness)
- **Optional DST clock offset** — apply DST to plugin clock independently
- **Auto-show on device wake** (battery-friendly)
- **Full Arabic and English UI** with RTL layout support
- **Location database** with 22 countries and 200+ cities
- **Custom location support** with step-by-step coordinate guide
- **Font management** — add your own .ttf/.otf fonts
- **Alert options** (screen flash, message, frontlight pulse)

> ℹ️ **Battery-Friendly Design:**
> This plugin does **not** keep your device awake in the background. It shows prayer times only when you open it, or optionally when the device wakes from sleep (if enabled). This approach helps preserve battery life on e-ink devices like Kindle.

## What's New in v1.2.0

- **Moroccan calculation method** (19°/17°) for Morocco and Mauritania
- **IAC Standard method** with latitude-aware Isha angle (18° below 45°, 17° above)
- **Auto Asr madhhab selection** — Hanafi for South Asia & Turkey, Shafi for all others
- **Per-prayer corrections** — fine-tune each prayer time by ±30 minutes
- **City search** — filter the location list by typing in Arabic or English
- **Arabic-Indic digits** — clock, dates, and prayer times display in ١٢٣ format
- **High-latitude rules** — five configurable estimation methods for polar regions
- **Ramadan mode** — force or auto-detect Ramadan for Umm al-Qura Isha interval
- **DST clock toggle** — optionally apply DST offset to the plugin clock only
- **Location guide** — integrated timesprayer.com instructions for finding coordinates
- **Fixed**: screen brightness lock after closing widget
- **Fixed**: background timer memory leaks
- **Fixed**: timezone double-shift in fasting reminders
- **Fixed**: custom locations lost on plugin update
- **Fixed**: calculation engine now uses iterative solar position for better accuracy

## Installation

1. Download the latest release ZIP from the [Releases page](../../releases).
2. Connect your e-reader (Kindle, Kobo, etc.) to your computer via USB.
3. Extract the ZIP file. You will get a folder named `prayertimes.koplugin`.
4. Copy that entire folder into the KOReader **plugins** directory:
   - **Kindle**: `koreader/plugins/`
   - **Kobo**: `.adds/koreader/plugins/`
   - **Android**: `koreader/plugins/`

   The final path should look like:
   `koreader/plugins/prayertimes.koplugin/`

5. Safely eject the device.
6. Restart KOReader completely (exit and reopen, not just close the widget).

## Quick Start

1. Open KOReader.
2. Go to **Tools → Prayer Times**.
3. Select **Launch** to see today's prayer times.
4. To change location: **Set Location → Choose from list**.
5. To search for a city: tap **🔍 Search for a city...** at the top of the list.
6. To add your exact location easily, use the **"My Location"** button on [timesprayer.com](https://timesprayer.com/) to get your coordinates and calculation method automatically.

## Screenshots

| Arabic                           | English                           |
| -------------------------------- | --------------------------------- |
| ![Arabic](docs/images/sc-ar.png) | ![English](docs/images/sc-en.png) |

## Documentation

- [Full English Guide](docs/README.en.md)
- [الدليل الكامل بالعربية](docs/README.ar.md)

---

## License

MIT License – see [LICENSE](LICENSE) file.

## Contributing

Pull requests are welcome. Please test on your device before submitting.

## Updates & Issues

For the latest updates, bug reports, or feature requests, visit the [repository](https://github.com/Mahmoudgomaa001/prayertimes.koplugin).