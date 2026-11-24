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
| 1 | Seeed Studio XIAO ESP32-C3 | 1 | ESP32-C3, USB-C, built-in LiPo charger, castellated pads incl. BAT+/BAT− on the underside. Pre-soldered headers optional. | [Seeed (official)](https://www.seeedstudio.com/Seeed-XIAO-ESP32C3-p-5431.html) · [AliExpress](https://www.aliexpress.com/wholesale?SearchText=XIAO+ESP32C3) · [Amazon.nl](https://www.amazon.nl/s?k=Seeed+XIAO+ESP32C3) · [Conrad.be](https://www.conrad.be/nl/search.html?search=XIAO%20ESP32C3) |
| 2 | **Waveshare 2.9" e-Paper Module (B/W, 296×128, SPI)**, SKU 002750 | 1 | Includes mounting material and an 8-pin JST-PH to DuPont female cable, so no soldering to the display. | [Tinytronics SKU 002750](https://www.tinytronics.nl/en/search?search=002750) |
| 3 | **Waveshare PCF8563 RTC Board** (Tinytronics) | 1 | I²C, 1.8–5.5 V supply and signals, PCB 54.3 × 15.5 mm, I²C pass-through headers, **backup battery included** (per the shop listing). Keeps time while the ESP32 sleeps and offline. | [Tinytronics (search "PCF8563")](https://www.tinytronics.nl/en/search?search=PCF8563) |
| 4 | LiPo cell 3.7 V, **with built-in protection circuit (PCM)**, about 400–700 mAh, e.g. 503035 (5×30×35 mm), bare leads (no JST) or JST you will cut off | 1 | Must fit the case (max ≈ 6×31×36 mm). Do not buy cells without protection. See [battery safety](battery-safety.md). | [AliExpress](https://www.aliexpress.com/wholesale?SearchText=503035+3.7V+lipo+battery+protection) · [Amazon.nl](https://www.amazon.nl/s?k=503035+3.7V+lipo+500mAh) · [Conrad.be](https://www.conrad.be/nl/search.html?search=lipo%203.7V%20500mAh) |
| 5 | Tactile switch 6×6 mm, with ~9–13 mm cap/stem | 1 | The case hole is 7 mm. | [AliExpress](https://www.aliexpress.com/wholesale?SearchText=6x6+tactile+switch+with+cap) · [Amazon.nl](https://www.amazon.nl/s?k=6x6+tactile+switch+kit) · [Conrad.be](https://www.conrad.be/nl/search.html?search=tactile%20switch%206x6) |
| 6 | Resistor 10 kΩ, 0.25 W | 1 | Button pull-up (internal pull-ups are off during deep sleep). | Any assortment kit |
| 7 | Thin stranded hookup wire, 28–30 AWG, assorted colours | ~1 m | Silicone insulation is easiest to solder. | any electronics shop |
| 8 | M2 × 6–8 mm self-tapping screws | 4 | Fix the lid. | [AliExpress](https://www.aliexpress.com/wholesale?SearchText=M2+self+tapping+screws+assortment) · [Amazon.nl](https://www.amazon.nl/s?k=M2+self+tapping+screws) · [Conrad.be](https://www.conrad.be/nl/search.html?search=M2%20zelftappende%20schroeven) |
| 9 | Double-sided tape (thin, 3M-type) | small | Holds the display and battery. | any shop |
| 10 | Kapton / insulating tape | small | Insulate the battery side from the PCBs. | any shop |
| 11 | Optional: 2 neodymium magnets 8×2 mm | 2 | Fridge mounting; pockets are in the lid. | [AliExpress](https://www.aliexpress.com/wholesale?SearchText=magnet+8x2mm) · [Amazon.nl](https://www.amazon.nl/s?k=magnet+8x2mm) |
| 12 | USB-C data cable | 1 | For flashing and charging. | any shop |
| 13 | 3D-printed case (PLA/PETG) | 1 set | [`body.stl`](../hardware/case/body.stl), [`lid.stl`](../hardware/case/lid.stl) | print yourself or use a print service |

Tinytronics is a Dutch shop; I could not open it from the build environment, so part details come from the listing text you provided, not from my own check. Prices are still not listed.

Tools: soldering iron + solder, wire cutters/strippers, small Phillips screwdriver, multimeter (strongly recommended for checking battery polarity), calipers.

## Checks before ordering

- XIAO ESP32-C3 (not S3/C6): the pin map in [wiring](wiring.md) is for the C3.
- Display is **296×128, B/W, SPI, 3.3 V** and its revision is V2 (see above).
- Battery has a protection board, fits the case, and its connector/leads can be wired to the XIAO pads.
