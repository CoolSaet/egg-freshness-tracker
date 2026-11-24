# Egg freshness tracker

Battery-powered ESPHome egg-date tracker with a monochrome e-paper display and a printable enclosure. An ESP32-C3 shows the **gathered date**, the **calculated expiry date** and a status of **Fresh**, **Still OK** or **Expired**, and reports to Home Assistant.

> **Project status (please read):** The firmware configuration validates and the date/button logic passes unit tests on a computer. **No hardware has been built or tested, and the case has not been printed.** See [what is verified](docs/verification.md). Treat everything involving real parts (pin choices, display model, case dimensions, battery runtime) as a design to be checked, not a proven build.

## Food-safety disclaimer

- This device is a **date-keeping aid, not a food-safety device**. It cannot tell whether an egg is safe to eat.
- There are **no default thresholds**. You must set both in Home Assistant. Any numbers quoted in discussions (for example "7 days fresh / 28 days to expiry from the laying date when kept below 20 °C") are **unverified information, used only as test values** — not a default, recommendation or safety guarantee.
- The device counts from the **gathered date** (the day you press the button). This **may differ from the laying date** — eggs can be laid days before you collect them. Expiry is calculated from the gathered date, so choose thresholds with that in mind.
- Follow your **local food-safety authority's guidance** (in Belgium, the FAVV/AFSCA) for storage and use-by decisions. When in doubt, throw it out.

## What it does

| Display | Meaning |
|---|---|
| Gathered | Date you set (double-click sets today's local date) |
| Expires | Gathered date + *expiry threshold* days |
| FRESH | age < *fresh threshold* (fresh ends **on** the fresh-threshold day) |
| STILL OK | fresh threshold ≤ age < expiry threshold |
| EXPIRED | age ≥ expiry threshold (expired **starts on** the expiry date) |

Other screens: `SET LIMITS` (thresholds not set), `BAD LIMITS` (fresh threshold must be smaller than expiry threshold), `SET DATE`, `NO CLOCK`, `CHECK DATE` (gathered date is in the future).

- **Time zone:** Europe/Brussels. All date maths uses calendar days, so daylight-saving changes (23/25-hour days) never shift an expiry date. Covered by [unit tests](tests/test_egg_dates.cpp).
- **Double-click** sets the gathered date to the current local date. It works **without Wi-Fi** once the clock has synchronised once, because a battery-backed PCF8563 RTC keeps time.
- **Sleep:** deep sleep for 4 hours between updates, plus wake-on-button. While asleep the device is offline, so **Home Assistant may show it as "unavailable"** between wake-ups. This is expected. See [usage](docs/usage.md).
- **Thresholds** (`Fresh threshold`, `Expiry threshold`) are number entities in Home Assistant and are stored in the device's flash, so they survive sleep, power loss and missing Wi-Fi. Until both are set, the device stays awake (up to 15 min per wake) and shows `SET LIMITS`.

## Documentation

1. [Bill of materials](docs/bom.md) (display choice, links, **prices not verified**)
2. [Wiring](docs/wiring.md)
3. [Battery and charging safety](docs/battery-safety.md)
4. [Case and assembly](docs/assembly.md) – [OpenSCAD source](hardware/case/egg-case.scad), [body.stl](hardware/case/body.stl), [lid.stl](hardware/case/lid.stl)
5. [Setup (no terminal needed)](docs/setup.md)
6. [Usage, sleep behaviour and Home Assistant](docs/usage.md)
7. [What is verified and what is not](docs/verification.md)

## Repository layout

```
components/egg_dates/   pure date/status/click logic (C++ header + ESPHome glue)
firmware/               ESPHome package, example user config, CI dev config
hardware/case/          OpenSCAD source + STL files
tests/                  host-side unit tests for the date logic
docs/                   build and usage documentation
```
