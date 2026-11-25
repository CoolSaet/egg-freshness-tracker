# Wiring

All signals are 3.3 V. **Not hardware-tested** – double-check against the datasheets/silkscreen of the parts you actually receive.

## Pin map (ESP32-C3 Super Mini)

| Function | Super Mini GPIO | Connects to |
|---|---|---|---|
| SPI clock | GPIO8 | Display `CLK` |
| SPI MOSI | GPIO10 | Display `DIN` |
| Display CS | GPIO20 | Display `CS` |
| Display DC | GPIO21 | Display `DC` |
| Display RST | GPIO5 | Display `RST` |
| Display BUSY | GPIO4 | Display `BUSY` |
| I²C SDA | GPIO6 | PCF8563 `SDA` |
| I²C SCL | GPIO7 | PCF8563 `SCL` |
| Button | GPIO3 | Button → GND, 10 kΩ pull-up to 3V3 |
| Power | 3V3 / GND | Display `VCC`, PCF8563 `VCC`, GND of all |
| Main power | Super Mini USB-C | Lipo Rider Plus 5 V USB-A output, using a USB-A-to-USB-C cable |
| Battery | Lipo Rider Plus JST2.0 | Protected single-cell LiPo; verify connector fit and polarity |

Notes:

- Connect by the **GPIO numbers**, not the pin positions from a XIAO diagram. Super Mini board layouts can vary; verify the silkscreen before wiring.
- **GPIO3 is deep-sleep-wake capable** on the ESP32-C3 (only GPIO0–5 are). It is not a strapping pin. The **external 10 kΩ pull-up is required** because internal pull-ups are not kept during deep sleep.
- GPIO8 (SCK) is a strapping pin; it is the board's standard SPI clock and ESPHome prints a warning, which is expected. Do not add external pull-ups/downs on it.
- GPIO20/GPIO21 are the UART pins; the firmware sends logs over USB (`USB_SERIAL_JTAG`) instead.
- Charge the battery through the Lipo Rider Plus USB-C input. Its regulated 5 V USB-A output powers the Super Mini through its USB-C port; its 3.3 V header is rated for only 250 mA and is not suitable for the ESP32-C3's Wi-Fi current peaks.
- Keep the Lipo Rider Plus 5 V output disconnected when powering the Super Mini from a computer USB port, unless using a power-path designed to prevent backfeeding.
- The display's 8-pin JST-PH cable ends in DuPont sockets. The Waveshare pin order is VCC, GND, DIN, CLK, CS, DC, RST, BUSY; check the labels on the module and wire by label, not by cable colour.
- Display `GND` to GND, `VCC` to **3V3** (not 5 V, not the battery).

## Schematic

```
 3V3 ──┬─────────────── Display VCC
       ├─────────────── PCF8563 VCC
       └──[10 kΩ]──┬─── GPIO3
                   └─── Button ─── GND
 GND ───────────────── Display GND, PCF8563 GND

 GPIO8 ─ Display CLK   GPIO10 ─ Display DIN   GPIO20 ─ Display CS
 GPIO21 ─ Display DC   GPIO5 ─ Display RST    GPIO4 ─ Display BUSY
 GPIO6 ─ PCF8563 SDA   GPIO7 ─ PCF8563 SCL

 Protected LiPo ─ Lipo Rider Plus
 Lipo Rider Plus USB-A 5 V OUT ─ USB-A-to-USB-C cable ─ Super Mini USB-C
```

Waveshare PCF8563 board: connect to the male header pins (SDA, SCL, VCC, GND); leave INT/other pins unconnected. Its female header is the I²C pass-through and is not needed.

## Soldering order

1. Solder wires to the PCF8563, display cable/breakout and button first; keep them short.
2. Connect the protected battery to the Lipo Rider Plus only after verifying polarity. Connect its 5 V USB-A output to the Super Mini USB-C port for battery operation; use a separate USB-C supply for the Rider Plus charging input.
3. Before closing the case, test the Super Mini over USB power, then test battery operation through the Rider Plus and confirm the display and clock work.
