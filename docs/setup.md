# Setup (no terminal needed)

Everything below can be done in a web browser with the Home Assistant ESPHome add-on. Requirements: Home Assistant with the **ESPHome device builder** add-on installed, Wi-Fi (2.4 GHz) reachable where the device sits, and a USB-C data cable.

## 1. Create the device in ESPHome

1. In Home Assistant open **ESPHome** → **+ New device** → name it `egg-freshness-tracker` → choose **ESP32-C3** → skip the install step.
2. Open the new device → **Edit**. The wizard generated `wifi:`, `api:` (with an encryption key) and `ota:` blocks. **Keep your generated `api` key and Wi-Fi settings.**
3. Paste the contents of [`firmware/example-user-config.yaml`](../firmware/example-user-config.yaml) around them (it adds `external_components` and `packages`, which pull the firmware logic from this repository). Make sure there is only one of each top-level block (`wifi`, `api`, `ota`).
4. Set the correct key in `api: encryption: key:`.
5. **Install** the first time via the browser (below).

The first build downloads fonts and the ESP-IDF toolchain, and can take 5–15 minutes.

## 2. First flash

Option A – **plug into the Home Assistant host**: ESPHome → Install → *Plug into the computer running ESPHome Dashboard*.

Option B – **plug into your laptop**: ESPHome → Install → *Manual download* → *Factory format* and flash it at <https://web.esphome.io> using Chrome/Edge (needs Web Serial; this may be blocked on a restricted laptop, then use option A).

If the board is not detected, hold the **B (Boot)** button on the XIAO while plugging in USB, then release. After the first flash, updates go over Wi-Fi (OTA).

## 3. Adopt in Home Assistant

The device should appear under **Settings → Devices & services** as a discovered ESPHome device → **Add** (enter the encryption key).

## 4. Set the thresholds (mandatory)

There are **no default thresholds** by design. Until both are set the display shows `SET LIMITS`, and the device stays awake (up to 15 min) so you can set them.

1. In Home Assistant open the device → **Configuration**: set **Fresh threshold** and **Expiry threshold** in days.
2. Fresh threshold must be **smaller** than the expiry threshold, otherwise the display shows `BAD LIMITS`.
3. Choose values from guidance you trust, counted **from the gathered date** (not the laying date). See the [food-safety disclaimer](../README.md#food-safety-disclaimer). The values are stored in the device's flash and survive sleep and power loss.

## 5. Set the clock

The clock syncs automatically from Home Assistant (and SNTP) whenever the device is awake and online, in **Europe/Brussels** time, and is stored in the PCF8563. It only needs to sync once for the double-click to work offline.

## 6. Changing settings later

The device sleeps, so Home Assistant cannot talk to it most of the time ([usage](usage.md)). To change thresholds:

1. Press the button **once** (single click). The screen refreshes and the device stays awake for about **2 minutes** (more if you also turn on **Stay awake**).
2. In Home Assistant change **Fresh threshold** / **Expiry threshold**. The display updates immediately.
3. For longer sessions, turn on **Stay awake** (it switches itself off after 30 min); turn it off when done and the device sleeps within a few seconds.

## 7. Troubleshooting

| Symptom | Likely cause |
|---|---|
| Display blank/garbled | Wrong display revision; check `model:` in the YAML against the board (see [BOM](bom.md)). Wiring per [wiring](wiring.md). |
| `NO CLOCK` | The device has never reached Home Assistant/SNTP. Check Wi-Fi and wait up to a minute. |
| `CHECK DATE` | Gathered date is in the future – double-click to reset it to today. |
| Double-click ignored | See timing in [usage](usage.md). |
| Entities "unavailable" | Normal while asleep. |
