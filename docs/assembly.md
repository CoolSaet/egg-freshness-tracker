# Case and assembly

The case has two printed parts, [`body.stl`](../hardware/case/body.stl) and [`lid.stl`](../hardware/case/lid.stl), generated from [`egg-case.scad`](../hardware/case/egg-case.scad).

> **Untested.** The STL files render as valid solids, but nothing has been printed or fitted with real parts. Dimensions of the display, XIAO, battery and switch are from memory/datasheet figures. **Measure your parts and edit the values at the top of the `.scad` file** (open it in the free [OpenSCAD](https://openscad.org) app or the online OpenSCAD playground, export STL) before printing the final case. Print a quick test body first (e.g. 0.3 mm layers, 10 % infill) to check fit.

The case layout was designed for a Seeed XIAO ESP32-C3 and its battery pads. The ESP32-C3 Super Mini and Lipo Rider Plus are different in size and layout; the case needs space for both boards, the battery, and the USB-A-to-USB-C power cable. Check fit and revise the board mount/USB openings before printing. See [wiring](wiring.md) for the power connections.

Outer size ≈ 95 × 64 × 18 mm body + 3 mm lid.

## Printing

| Setting | Value |
|---|---|
| Material | PLA or PETG |
| Layer height | 0.2 mm |
| Walls | 3 perimeters |
| Infill | 15–20 % |
| Supports | None: print the **body with the window face down**, the **lid flat** |

## Assembly

1. **Test-fit** all parts in the body before gluing or soldering anything.
2. Prepare electronics on the bench first: wire the display, RTC, button and 10 kΩ resistor following [wiring](wiring.md). Flash the firmware **before** closing the case ([setup](setup.md)); USB-C is reachable through the slot afterwards, but updates are also possible over Wi-Fi.
3. Stick the display, **screen facing the window**, into the rim on the inside of the front plate with a thin strip of double-sided tape. Do not press on the glass; handle by the edges and keep the flex tail and connector free.
4. Drop the 6×6×5 switch into the pocket in the right wall (stem towards the wall, pins towards the inside), put the printed plunger (`plunger.stl`) through the wall hole so its flange sits between the wall and the switch stem, then solder wires to the pins. The plunger and pocket sizes assume a ~3.7 mm switch body and ~1.5 mm stem; check by pressing it.
5. For the Super Mini build, fit the protected battery and Lipo Rider Plus in insulated, separately sized spaces. Do not squeeze the cell or leave exposed conductors where they could short.
6. Mount the controller and RTC only after checking fit and the USB openings. The existing positions and port orientation are for the XIAO; the Super Mini and Rider Plus need a redesigned mount. Route the Rider Plus 5 V USB-A output to the Super Mini USB-C port without pinching the cable. Lay the Waveshare PCF8563 board lengthwise in the strip below the display, between its two guide ribs (the case assumes 7 mm total thickness incl. coin cell; measure yours). Tape the boards in place; keep wires slack, none trapped by the posts.
7. Optional: glue the two 8 × 2 mm magnets (check polarity) into the pockets on the outside of the lid.
8. Close the lid with four **short** M2 self-tapping screws (6–8 mm). Snug, not tight.
9. Smoke test: plug in USB-C (or connect the battery), confirm the display updates and the button wakes the device.

## If parts do not fit

Common edits in the `.scad`: `disp_w/disp_h` (panel size), `win_*` (window), `tail_w` (space for the connector), `bat_*` and `cavity_d` (battery size; set for the 5×35×62 mm LP503562), `usb_*` and `btn_hole_d`.
