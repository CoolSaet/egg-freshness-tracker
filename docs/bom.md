# Bill of materials

**Prices are deliberately not listed.** I could not access AliExpress, Amazon or Conrad from the build environment, and I will not invent prices. Links below are **search links** (stable, but results change) or official manufacturer pages. Always confirm the exact variant before ordering.

## Display choice

**Chosen: Waveshare 2.9" e-Paper Module, black/white, 296×128, SPI** (Tinytronics SKU 002750, Waveshare model 12956), with the 8-pin JST-PH to DuPont cable in the box. Price from the listing you supplied: **€19.00 incl. 21 % VAT (€15.70 ex VAT)**, shipping not included.

- **The 2.13" vs 2.9" price comparison was not done.** I have only this one price (no access to other shops from my build environment). If a 2.13" module is clearly cheaper delivered, the earlier design (`waveshare-2.13in-v3`, 250×122) can be restored from the Git history, but it has not been maintained.
- **Revision matters.** The firmware uses ESPHome's `waveshare-2.9in-v2` model. The listing does not state the module's revision, so check the V-number on the board or in Waveshare's documentation. If it is not V2, the model has to change or the screen will stay blank or show garbage.
- Listing facts used: PCB 90 × 38 mm, 3.3–5 V supply, SPI, partial refresh supported, B/W only.

## Parts

| # | Part | Qty | Notes | Where to look (search/official links) |
|---|---|---|---|---|
| 1 | ESP32-C3 Super Mini | 1 | USB-C development board. The firmware targets `esp32-c3-devkitm-1`; verify your board exposes the GPIOs in the [pin map](wiring.md). No built-in LiPo charger or battery pads. | [AliExpress search](https://www.aliexpress.com/wholesale?SearchText=ESP32-C3+Super+Mini) · [Amazon.nl search](https://www.amazon.nl/s?k=ESP32-C3+Super+Mini) |
| 2 | **Waveshare 2.9" e-Paper Module (B/W, 296×128, SPI)**, SKU 002750, €19.00 | 1 | Includes mounting material and an 8-pin JST-PH to DuPont female cable, so no soldering to the display. | [Tinytronics SKU 002750, €19.00](https://www.tinytronics.nl/en/search?search=002750) |
| 3 | **Waveshare PCF8563 RTC Board** (Tinytronics SKU 003308, €4.00 per your cart) | 1 | I²C, 1.8–5.5 V supply and signals, PCB 54.3 × 15.5 mm, I²C pass-through headers, **backup battery included** (per the shop listing). Keeps time while the ESP32 sleeps and offline. | [Tinytronics (search "PCF8563")](https://www.tinytronics.nl/en/search?search=PCF8563) |
| 4 | **Seeed Studio Lipo Rider Plus (charger/booster)** | 1 | USB-C charging input; regulated 5 V USB-A output up to 2.4 A powers the Super Mini. The 3.3 V header is limited to 250 mA and is not used for the ESP32-C3. | [Seeed Wiki](https://wiki.seeedstudio.com/Lipo-Rider-Plus/) · [Seeed product page](https://www.seeedstudio.com/Lipo-Rider-Plus-p-4204.html) |
| 5 | Protected 3.7 V LiPo battery (e.g. PKCELL LP503562, 1200 mAh) | 1 | Connect to the Rider Plus JST2.0 battery port only after checking connector fit and polarity. Verify the cell's allowed charge current; the charger's maximum rating is not a safe current for every cell. See [battery safety](battery-safety.md). | [Tinytronics SKU 005879](https://www.tinytronics.nl/en/search?search=005879) |
| 6 | **Tactile switch 6×6×5 mm, no cap** (Tinytronics SKU 000181, €0.15) | 1 | Has no cap, so the case uses a printed plunger ([`plunger.stl`](../hardware/case/plunger.stl)) that passes through the right wall. | [Tinytronics SKU 000181](https://www.tinytronics.nl/en/search?search=000181) |
| 7 | Resistor 10 kΩ, 0.25 W | 1 | Button pull-up (internal pull-ups are off during deep sleep). | Any assortment kit |
| 8 | Thin stranded hookup wire, 28–30 AWG, assorted colours | ~1 m | Silicone insulation is easiest to solder. | any electronics shop |
| 9 | M2 × 6–8 mm self-tapping screws | 4 | Fix the lid. | [AliExpress](https://www.aliexpress.com/wholesale?SearchText=M2+self+tapping+screws+assortment) · [Amazon.nl](https://www.amazon.nl/s?k=M2+self+tapping+screws) · [Conrad.be](https://www.conrad.be/nl/search.html?search=M2%20zelftappende%20schroeven) |
| 10 | Double-sided tape (thin, 3M-type) | small | Holds the display, battery and power board. | any shop |
| 11 | Kapton / insulating tape | small | Insulate the battery side from the PCBs. | any shop |
| 12 | Optional: 2 neodymium magnets 8×2 mm | 2 | Fridge mounting; pockets are in the lid. | [AliExpress](https://www.aliexpress.com/wholesale?SearchText=magnet+8x2mm) · [Amazon.nl](https://www.amazon.nl/s?k=magnet+8x2mm) |
| 13 | USB-C data cable and USB-A-to-USB-C cable | 1 each | Data cable for flashing; A-to-C cable connects the Rider Plus 5 V output to the Super Mini. | any shop |
| 14 | 3D-printed case (PLA/PETG) | 1 set | [`body.stl`](../hardware/case/body.stl), [`lid.stl`](../hardware/case/lid.stl), [`plunger.stl`](../hardware/case/plunger.stl) | print yourself or use a print service |

Tinytronics is a Dutch shop; I could not open it from the build environment, so part details come from the listing text you provided, not from my own check. Only the prices from your Tinytronics cart are listed (display €19.00, RTC €4.00, battery €6.00, switch €0.15 = €29.15, incl. VAT per your cart, shipping not included, not checked by me). The resistor and other small parts are already on hand.

Tools: soldering iron + solder, wire cutters/strippers, small Phillips screwdriver, multimeter (strongly recommended for checking battery polarity), calipers.

## Checks before ordering

- ESP32-C3 Super Mini with the GPIOs listed in [wiring](wiring.md) exposed.
- Display is **296×128, B/W, SPI, 3.3 V** and its revision is V2 (see above).
- The case is still laid out for a XIAO and does not include space for the Super Mini and Lipo Rider Plus; redesign/check fit before printing, see [assembly](assembly.md).
