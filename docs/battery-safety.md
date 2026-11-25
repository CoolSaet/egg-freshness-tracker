# Battery, charging and safety

Lithium-polymer (LiPo) cells can catch fire if shorted, punctured, overcharged, over-discharged, overheated or wired the wrong way round. Read this before soldering the battery.

**ESP32-C3 Super Mini build:** use the Seeed Studio Lipo Rider Plus between the protected single-cell LiPo and the Super Mini. Connect the Rider Plus regulated 5 V USB-A output to the Super Mini USB-C port. Do not connect the LiPo directly to the Super Mini's 3V3 or 5V pin, and do not use the Rider Plus 3.3 V / 250 mA header to power the ESP32-C3.

## Choosing the battery

- 3.7 V single-cell LiPo **with a protection circuit (PCM/BMS board)** — protects against over-charge, over-discharge and short-circuit. Never use bare cells without protection.
- The case was sized for the PKCELL LP503562 (3.7 V, 1200 mAh, about 5 × 35 × 62 mm); the Super Mini/Rider Plus combination needs a case fit check. Other cells must fit within ≈ 6 × 36 × 63 mm. Use a cell with a protection circuit. Check that the connector fits the Rider Plus JST2.0 port and verify its polarity with a multimeter before connecting; do not force a mismatched plug.
- The Rider Plus can charge at up to 5 V / 2 A. This is a maximum board rating, not a suitable current for every battery; verify the cell's permitted charge current and do not use a cell whose requirements you cannot confirm.
- Buy from a seller who states capacity honestly and offers CE/UN 38.3 documentation; very cheap cells often overstate capacity.
- Check the **polarity of the leads**. Red/black is *usually* but not always +/−. Many cells come with a JST connector whose polarity does **not** match the XIAO's pads; do not assume.

## Wiring the battery

1. Use a multimeter on the battery leads: the voltage should read **+3.0 to +4.2 V**; the lead that reads positive is **+**. Mark it.
2. Solder only one lead at a time, never let bare leads touch. Cut and solder leads one by one so they cannot short against each other.
3. Connect the protected cell to the Rider Plus battery connector, matching the verified polarity. Do not connect the raw cell to the Super Mini.
4. Connect the Rider Plus regulated 5 V USB-A output to the Super Mini's USB-C port using an appropriate cable. The Rider Plus's USB-C port is its charging input.
5. Insulate exposed conductors. Keep the cell away from the soldering iron; do not heat the cell or its protection board.

## Charging

- Charge through the Rider Plus USB-C input using a suitable 5 V supply. Its USB-A port provides regulated 5 V output to the Super Mini; its 3.3 V header is limited to 250 mA. See [Seeed's Lipo Rider Plus documentation](https://wiki.seeedstudio.com/Lipo-Rider-Plus/) and confirm indicators/ports on your board revision.
- Charge **attended or at least in a safe place**, on a non-flammable surface, not unattended overnight on a bed or sofa; stop immediately if the cell swells, gets hot, smells or leaks.
- Charge at room temperature (roughly 5–35 °C). **Do not charge or store the device in a freezer.** A fridge is fine for discharge but charge it at room temperature.
- The firmware does not measure battery voltage, so there is no low-battery indicator. Recharge when the display stops updating or after a few months; plan to recharge periodically.
- Do not connect Rider Plus 5 V output and computer USB power to the Super Mini at the same time unless the power path is specifically designed to prevent backfeeding.

## Operating and storage

- Never leave the device in a hot place (car, sunny window). Keep below about 45 °C.
- If you will not use the device for months, store at about half charge, disconnected.
- Do not crush the cell with screws: leave the clearances in the case, never tighten the lid onto the battery, and keep screws short.
- Dispose of damaged or old cells at a battery collection point (in Belgium, e.g. via Bebat collection points). Never in household waste.

## Runtime (estimate, **not measured**)

With a 4-hour sleep interval the device is mostly asleep; each wake-up (Wi-Fi + display refresh) is on the order of tens of seconds. **Runtime with the Super Mini and Rider Plus is not estimated or measured.** It depends on Wi-Fi quality, the display, board leakage, battery capacity and power-conversion losses. Measure before relying on any runtime. Leaving the `Stay awake` switch on, or an unconfigured device, drains the battery much faster.
