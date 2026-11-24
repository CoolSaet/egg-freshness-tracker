# Usage, sleep and Home Assistant

## Button

| Action | Result |
|---|---|
| Single click | Wakes the device, refreshes the display and keeps it awake ~2 min so you can change settings in Home Assistant |
| **Double-click** | Sets the **gathered date to today's local date** (Europe/Brussels) and redraws |

The double-click works with **no Wi-Fi**, as long as the PCF8563 has been synchronised at least once. When the device is asleep, the first click wakes it (the chip takes about half a second to boot) and counts as click one; **the second click must arrive within about 2 seconds of the first**. Click firmly at a relaxed pace – a very fast double-tap can finish while the chip is still booting and will then count as a single click, so just repeat it. The result is shown on the display (the gathered date changes). This timing is designed but **not verified on real hardware**.

## Sleep and "unavailable" in Home Assistant

The device deep-sleeps for **4 hours** between updates (ESPHome `deep_sleep`), and also wakes when the button is pressed. In deep sleep, Wi-Fi is off, so **Home Assistant will usually show the device and its entities as `unavailable`** between wake-ups. That is expected, not a fault. On each wake-up the device reconnects, publishes its status, expiry date and thresholds, then goes back to sleep after a few seconds (typically 10–40 s awake).

Consequences:

- Home Assistant **cannot change settings while the device is asleep**; use the procedure in [setup §6](setup.md#6-changing-settings-later).
- The display always works offline: it is updated by the device itself.
- Automations should treat `unavailable` as "asleep" (e.g. use the last known `Status` for notifications, or trigger on `Status` changing to `EXPIRED`).
- The 4-hour interval is the `sleep_interval` substitution (default `4h`) in [`firmware/egg-freshness-tracker.yaml`](../firmware/egg-freshness-tracker.yaml). The status can therefore be up to ~4 hours late in changing on the display (the date itself is always right at the next wake-up).

## Home Assistant entities

| Entity | Type | Purpose |
|---|---|---|
| Fresh threshold | number (days) | Fresh ends at this age. Required. |
| Expiry threshold | number (days) | Expired starts at this age. Required; must be larger than the fresh threshold. |
| Status | text | `FRESH`, `STILL OK`, `EXPIRED`, or a setup message |
| Gathered date | text (YYYY-MM-DD) | |
| Expiry date | text (YYYY-MM-DD) | gathered date + expiry threshold |
| Set gathered date to today | button | Same as double-click, only while the device is awake |
| Stay awake | switch | Prevents sleeping for up to 30 min while you configure |

## How the dates are calculated

- `age = today − gathered date`, in **calendar days** (local Europe/Brussels date), so daylight-saving changes cannot shift anything by a day.
- **Fresh** while `age < fresh threshold`; **Still OK** while `age < expiry threshold`; **Expired** from `age ≥ expiry threshold`, i.e. from the expiry date shown on the display.
- **Expiry date = gathered date + expiry threshold.** The *laying* date is never used and is unknown to the device; the gathered date may be later than it. Pick thresholds accordingly and follow local food-safety guidance.
- Example for illustration **only** (values are not a default or a recommendation): thresholds 7 and 28, gathered 1 March → Fresh through 7 March, Still OK 8–28 March, Expired from 29 March.

## Clock accuracy

The PCF8563 is accurate to a few seconds per day or better with a normal 32 kHz crystal; it is re-synchronised every time Home Assistant or SNTP is reachable. If the device runs without Wi-Fi for months, the displayed date can drift by minutes, which matters only near midnight.
