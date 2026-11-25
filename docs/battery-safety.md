# Battery, charging and safety

Lithium-polymer (LiPo) cells can catch fire if shorted, punctured, overcharged, over-discharged, overheated or wired the wrong way round. Read this before soldering the battery.

## Choosing the battery

- 3.7 V single-cell LiPo **with a protection circuit (PCM/BMS board)** — protects against over-charge, over-discharge and short-circuit. Never use bare cells without protection.
- The case is sized for the PKCELL LP503562 (3.7 V, 1200 mAh, about 5 × 35 × 62 mm). Other cells must fit within ≈ 6 × 36 × 63 mm. The cell must have a protection circuit, which I could not confirm from the listing; charging a 1200 mAh cell on the XIAO's small charger is slow but fine. Check the JST-PH polarity of the wires against BAT+/BAT− with a multimeter; PKCELL/other brands sometimes differ from what the XIAO expects.
- Buy from a seller who states capacity honestly and offers CE/UN 38.3 documentation; very cheap cells often overstate capacity.
- Check the **polarity of the leads**. Red/black is *usually* but not always +/−. Many cells come with a JST connector whose polarity does **not** match the XIAO's pads; do not assume.

## Wiring the battery

1. Use a multimeter on the battery leads: the voltage should read **+3.0 to +4.2 V**; the lead that reads positive is **+**. Mark it.
2. Solder only one lead at a time, never let bare leads touch. Cut and solder leads one by one so they cannot short against each other.
3. Connect **+ to BAT+** and **− to BAT−** (pads on the underside of the XIAO ESP32-C3 – see Seeed's pin diagram on the [product page](https://www.seeedstudio.com/Seeed-XIAO-ESP32C3-p-5431.html)).
4. Insulate with Kapton tape. Keep the cell away from the soldering iron; do not heat the cell or its protection board.

## Charging

- Charge by plugging USB-C into the XIAO. The XIAO ESP32-C3 has a built-in single-cell LiPo charger (the charge LED indicates charging; check Seeed's documentation for its exact behaviour and charge current, which is low — about 100 mA class – so charging takes hours).
- Charge **attended or at least in a safe place**, on a non-flammable surface, not unattended overnight on a bed or sofa; stop immediately if the cell swells, gets hot, smells or leaks.
- Charge at room temperature (roughly 5–35 °C). **Do not charge or store the device in a freezer.** A fridge is fine for discharge but charge it at room temperature.
- The firmware does not measure battery voltage, so there is no low-battery indicator. Recharge when the display stops updating or after a few months; plan to recharge periodically.
- Use a plain 5 V USB charger or computer port.

## Operating and storage

- Never leave the device in a hot place (car, sunny window). Keep below about 45 °C.
- If you will not use the device for months, store at about half charge, disconnected.
- Do not crush the cell with screws: leave the clearances in the case, never tighten the lid onto the battery, and keep screws short.
- Dispose of damaged or old cells at a battery collection point (in Belgium, e.g. via Bebat collection points). Never in household waste.

## Runtime (estimate, **not measured**)

With a 4-hour sleep interval the device is mostly asleep; each wake-up (Wi-Fi + display refresh) is on the order of tens of seconds. A rough estimate from datasheet-class numbers suggests weeks to months per charge on a ~1200 mAh cell, but **actual runtime depends on Wi-Fi quality, the display, and unmeasured sleep current** (the XIAO board, display and RTC each leak a little). Measure with a USB power meter or multimeter before trusting any figure. Leaving the `Stay awake` switch on, or an unconfigured device, drains the battery in about a day.
