# What is verified and what is not

## Verified (by automated checks)

| Check | How | Where |
|---|---|---|
| Date arithmetic, leap years, DST spring/autumn local-date boundaries (Europe/Brussels) | C++ unit tests | [`tests/test_egg_dates.cpp`](../tests/test_egg_dates.cpp) |
| Fresh / Still OK / Expired boundaries; both thresholds required; BAD LIMITS | same | same |
| Double-click counting (wake press counts as click one) | same | same |
| ESPHome configuration is valid (pins, deep sleep, wake pin, PCF8563, template entities) | `esphome config` (ESPHome 2026.11.0) | [`firmware/dev.yaml`](../firmware/dev.yaml) |
| Firmware compiles; case renders to valid solids; example user config resolves | GitHub Actions workflow [`ci.yml`](../.github/workflows/ci.yml) | see the CI status of the pull request |

## NOT verified

- **No hardware was built or run.** Display model `waveshare-2.9in-v2` vs. the board you receive, the RTC wiring, wake-on-button, the actual wake/boot timing for double-click, deep-sleep current and battery life are all untested.
- **Firmware was not compiled in the authoring environment** (it had no access to the ESP-IDF download servers); compilation is only checked by CI if that run succeeded.
- **The case has not been printed**; the RTC board thickness (7 mm) in the case is an assumption; dimensions of parts are approximate and must be measured.
- **2.13" and 2.9" prices were not compared.** Only the user-supplied Tinytronics price of the 2.9" module is recorded (see [BOM](bom.md)); the display revision is unconfirmed.
- Home Assistant behaviour (entity availability, adoption, threshold persistence across reboot) was not tested against a live Home Assistant.
- Battery charging/safety notes are general guidance, not product-specific verification.
- The 7-day/28-day example is unverified and not used anywhere as a default.
