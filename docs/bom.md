# Bill of materials

**Prices are deliberately not listed.** I could not access AliExpress, Amazon or Conrad from the build environment, and I will not invent prices. Links below are **search links** (stable, but results change) or official manufacturer pages. Always confirm the exact variant before ordering.

## Display choice: 2.13" vs 2.9"

The request was to pick whichever 2.13" or 2.9" module has the **cheaper total delivered cost to Belgium**. That comparison **has not been done** (no price access). Until it is:

- **Provisional choice: Waveshare-type 2.13" (250×122) black/white e-paper, "V3" revision**, because it is smaller (smaller case, shorter flex tail) and ESPHome has a model for it (`waveshare-2.13in-v3`). This is a **default for design purposes, not a price-based decision.**
- To decide properly, fill this table with real quotes, **including shipping and import VAT/customs** to Belgium, for the *same* seller type (e.g. both from Amazon, or both from AliExpress "choice" shipping):

| Module | Seller / link | Item price | Shipping to BE | VAT/customs | **Total delivered** | Date checked |
|---|---|---|---|---|---|---|
| 2.13" B/W 250×122 (V3, SSD1680-family) | | | | | | |
| 2.9" B/W 296×128 | | | | | | |

- If the 2.9" is clearly cheaper delivered, change `model:` to `waveshare-2.9in-v2` (check the revision of the module you buy), update the drawing coordinates in [`firmware/egg-freshness-tracker.yaml`](../firmware/egg-freshness-tracker.yaml) (screen becomes 296×128) and the display dimensions at the top of [`egg-case.scad`](../hardware/case/egg-case.scad). This is **not implemented or tested**.
- **Revision matters.** Waveshare sells several 2.13" revisions (V2, V3, V4…) with different controllers/waveforms. Buy a board that says **V3** in the listing and on the PCB, or pick the ESPHome model that matches the revision you actually receive and re-validate. Cheap clones may not match; this is the highest-risk part of the BOM.

## Parts

| # | Part | Qty | Notes | Where to look (search/official links) |
|---|---|---|---|---|
| 1 | Seeed Studio XIAO ESP32-C3 | 1 | ESP32-C3, USB-C, built-in LiPo charger, castellated pads incl. BAT+/BAT− on the underside. Pre-soldered headers optional. | [Seeed (official)](https://www.seeedstudio.com/Seeed-XIAO-ESP32C3-p-5431.html) · [AliExpress](https://www.aliexpress.com/wholesale?SearchText=XIAO+ESP32C3) · [Amazon.nl](https://www.amazon.nl/s?k=Seeed+XIAO+ESP32C3) · [Conrad.be](https://www.conrad.be/nl/search.html?search=XIAO%20ESP32C3) |
| 2 | 2.13" e-paper module, B/W, SPI, 3.3 V, **V3**, with 8-pin cable/breakout | 1 | See choice above. Get the *module with 8-pin cable* rather than the Raspberry Pi HAT. | [AliExpress](https://www.aliexpress.com/wholesale?SearchText=Waveshare+2.13+inch+e-paper+module+V3) · [Amazon.nl](https://www.amazon.nl/s?k=Waveshare+2.13+inch+e-paper+module+V3) · [Conrad.be](https://www.conrad.be/nl/search.html?search=2.13%20e-paper%20Waveshare) |
| 3 | PCF8563 RTC breakout (I²C, 3.3 V) | 1 | Keeps time while the ESP32 sleeps and offline. Choose a board without a 5 V-only regulator or level shifter, running at 3.3 V. | [AliExpress](https://www.aliexpress.com/wholesale?SearchText=PCF8563+RTC+module) · [Amazon.nl](https://www.amazon.nl/s?k=PCF8563+RTC+module) · [Conrad.be](https://www.conrad.be/nl/search.html?search=PCF8563) |
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

Tools: soldering iron + solder, wire cutters/strippers, small Phillips screwdriver, multimeter (strongly recommended for checking battery polarity), calipers.

## Checks before ordering

- XIAO ESP32-C3 (not S3/C6): the pin map in [wiring](wiring.md) is for the C3.
- Display listing says **250×122, B/W, SPI, 3.3 V** and the revision you can support.
- Battery has a protection board, fits the case, and its connector/leads can be wired to the XIAO pads.
