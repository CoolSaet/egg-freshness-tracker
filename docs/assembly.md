# Case and assembly

The case has two printed parts, [`body.stl`](../hardware/case/body.stl) and [`lid.stl`](../hardware/case/lid.stl), generated from [`egg-case.scad`](../hardware/case/egg-case.scad).

> **Untested.** The STL files render as valid solids, but nothing has been printed or fitted with real parts. Dimensions of the display, XIAO and battery are from memory/datasheet figures. **Measure your parts and edit the values at the top of the `.scad` file** (open it in the free [OpenSCAD](https://openscad.org) app or the online OpenSCAD playground, export STL) before printing the final case. Print a quick test body first (e.g. 0.3 mm layers, 10 % infill) to check fit.

Outer size ≈ 73 × 42 × 16 mm body + 3 mm lid.

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
3. Stick the display, **screen facing the window**, into the rim on the inside of the front plate with a thin strip of double-sided tape. Do not press on the glass; handle by the edges and fold the flex tail gently toward the left tail area.
4. Press the tactile switch into its hole in the right wall (the 7 mm hole is for the cap/stem; fix with a dab of hot glue or CA glue on the *switch body*, not the cap).
5. Place the battery in the cavity between the ribs, taped with its protection board away from the XIAO, with a layer of Kapton under any bare solder joints. Do not squeeze it.
6. Mount the XIAO at the bottom right with the USB-C port aligned to the slot in the bottom wall, and the RTC beside it. Tape the boards in place; keep wires slack, none trapped by the posts.
7. Optional: glue the two 8 × 2 mm magnets (check polarity) into the pockets on the outside of the lid.
8. Close the lid with four **short** M2 self-tapping screws (6–8 mm). Snug, not tight.
9. Smoke test: plug in USB-C (or connect the battery), confirm the display updates and the button wakes the device.

## If parts do not fit

Common edits in the `.scad`: `disp_w/disp_h` (panel size), `win_*` (window), `tail_w` (space for the connector), `bat_*` and `cavity_d` (thicker battery), `usb_*` and `btn_hole_d`.
