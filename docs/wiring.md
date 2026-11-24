# Wiring

All signals are 3.3 V. **Not hardware-tested** – double-check against the datasheets/silkscreen of the parts you actually receive.

## Pin map (XIAO ESP32-C3)

| Function | XIAO pin | GPIO | Connects to |
|---|---|---|---|
| SPI clock | D8 | GPIO8 | Display `CLK` |
| SPI MOSI | D10 | GPIO10 | Display `DIN` |
| Display CS | D7 | GPIO20 | Display `CS` |
| Display DC | D6 | GPIO21 | Display `DC` |
| Display RST | D3 | GPIO5 | Display `RST` |
| Display BUSY | D2 | GPIO4 | Display `BUSY` |
| I²C SDA | D4 | GPIO6 | PCF8563 `SDA` |
| I²C SCL | D5 | GPIO7 | PCF8563 `SCL` |
| Button | D1 | GPIO3 | Button → GND, 10 kΩ pull-up to 3V3 |
| Power | 3V3 / GND | – | Display `VCC`, PCF8563 `VCC`, GND of all |
| Battery | BAT+ / BAT− pads (underside) | – | LiPo red (+) / black (−) |

Notes:

- **GPIO3 is deep-sleep-wake capable** on the ESP32-C3 (only GPIO0–5 are). It is not a strapping pin. The **external 10 kΩ pull-up is required** because internal pull-ups are not kept during deep sleep.
- GPIO8 (SCK) is a strapping pin; it is the board's standard SPI clock and ESPHome prints a warning, which is expected. Do not add external pull-ups/downs on it.
- GPIO20/GPIO21 are the UART pins; the firmware sends logs over USB (`USB_SERIAL_JTAG`) instead.
- The display's 8-pin JST-PH cable ends in DuPont sockets. The Waveshare pin order is VCC, GND, DIN, CLK, CS, DC, RST, BUSY; check the labels on the module and wire by label, not by cable colour.
- Display `GND` to GND, `VCC` to **3V3** (not 5 V, not the battery).

## Schematic

```
 3V3 ──┬─────────────── Display VCC
       ├─────────────── PCF8563 VCC
       └──[10 kΩ]──┬─── D1 (GPIO3)
                   └─── Button ─── GND
 GND ───────────────── Display GND, PCF8563 GND

 D8 ─ Display CLK     D10 ─ Display DIN    D7 ─ Display CS
 D6 ─ Display DC      D3  ─ Display RST    D2 ─ Display BUSY
 D4 ─ PCF8563 SDA     D5  ─ PCF8563 SCL

 LiPo + ─ BAT+ pad    LiPo − ─ BAT− pad   (underside of the XIAO)
```

Waveshare PCF8563 board: connect to the male header pins (SDA, SCL, VCC, GND); leave INT/other pins unconnected. Its female header is the I²C pass-through and is not needed.

## Soldering order

1. Solder wires to the PCF8563, display cable/breakout and button first; keep them short.
2. Solder the battery to the XIAO **last**, after checking polarity with a multimeter (see [battery safety](battery-safety.md)).
3. Before closing the case, power from USB only and confirm the display and clock work.
