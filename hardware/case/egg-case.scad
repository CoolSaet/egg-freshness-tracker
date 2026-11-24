// Egg freshness tracker - 3D-printable case (OpenSCAD, all dimensions in mm).
//
// UNTESTED: this case has been rendered to STL but NOT printed or fitted with real hardware.
// Measure your parts with calipers and adjust the "Parts" values before printing.
//
// Parts (printed separately, no supports needed if printed as exported):
//   body - front shell with display window, USB-C slot and button hole. Print window side DOWN.
//   plunger - small printed button cap that passes through the right wall (the 6x6x5 switch has no cap). Print flange down.
//   lid  - back plate, fixed with 4 x M2 self-tapping screws (6-8 mm long). Print flat.
//
// Render:  openscad -D 'part="body"' -o body.stl egg-case.scad
//          openscad -D 'part="lid"'  -o lid.stl  egg-case.scad
//          openscad -D 'part="plunger"' -o plunger.stl egg-case.scad
// Or open in OpenSCAD and set `part` below ("body", "lid" or "preview").

part = "preview";

// ---- Parts (check against your actual parts!) ------------------------------------------
// Waveshare 2.9" e-paper MODULE (Tinytronics SKU 002750): PCB 90 x 38 mm per the shop listing.
// Active area is about 67 x 29 mm; its position on the PCB, the thickness (disp_t) and the
// window offset are ASSUMED. VERIFY with calipers.
disp_w = 90.0;       // panel width (long side)
disp_h = 38.0;       // panel height
disp_t = 4.0;        // panel thickness incl. adhesive
win_w = 68.0;        // visible window (active area is about 67 x 29)
win_h = 30.0;
win_off_x = 0;       // shift window if active area is not centred on the panel
tail_w = 0;          // room at the left edge for the flex tail and 8-pin connector

// Seeed XIAO ESP32-C3 is about 21 x 17.8 mm, 3.5 mm incl. USB-C shell about 8.4 x 3.2 mm.
xiao_w = 21.5;
xiao_h = 18.3;
usb_w = 9.5;
usb_h = 4.0;

// PKCELL LP503562 (Tinytronics 005879): 5 x 35 x 62 mm (thickness x width x length) nominal; cells swell/wrap, so measure.
bat_l = 63.0;
bat_w = 35.5;
bat_t = 6.0;         // if you use a thicker cell, increase cavity_d accordingly

// Waveshare PCF8563 RTC board (Tinytronics): PCB 54.3 x 15.5 mm per the shop listing.
// Thickness incl. headers and coin cell is ASSUMED, measure it.
rtc_l = 54.3;
rtc_w = 15.5;
rtc_t = 7.0;

// Tinytronics 000181: 6 x 6 x 5 mm tactile switch WITHOUT cap (body ~3.5 mm + ~1.5 mm stem, assumed).
sw_w = 6.3;          // pocket width for the 6 x 6 mm switch
sw_body = 3.7;       // switch body depth along the press axis
plunger_d = 5.0;     // printed plunger shaft
btn_hole_d = 5.6;    // hole in the right wall for the plunger

// ---- Case -------------------------------------------------------------------------------
wall = 2.0;
front_t = 2.0;       // front plate thickness (window is cut through it)
lid_t = 3.0;
tol = 0.3;
cavity_d = 12.0;     // depth behind the display (battery 5.5 + wiring + XIAO + clearance)

in_w = disp_w + tail_w + 2 * tol;        // inner width
strip_h = rtc_w + 2.5;                   // strip below the display that holds the RTC board lengthwise
top_extra = 3.2;                         // hidden space above the display so the battery (30.5 wide) fits
in_h = disp_h + 2 * tol + strip_h + top_extra;  // inner height
by = wall + strip_h + 0.2;               // bottom edge of the battery/XIAO zone
out_w = in_w + 2 * wall;
out_h = in_h + 2 * wall;
body_d = front_t + disp_t + cavity_d;    // total depth of the body shell
btn_y = out_h - wall - 5;                       // centre of the button along the height
btn_z = front_t + disp_t + cavity_d / 2;
post_d = 5.5;
screw_pilot = 1.8;   // pilot hole for M2 self-tapping screw
screw_clear = 2.4;
$fn = 40;

module rrect(w, h, d, r = 2) {
  hull() for (x = [r, w - r], y = [r, h - r]) translate([x, y, 0]) cylinder(r = r, h = d);
}

module post_positions() {
  for (x = [wall + post_d / 2 - 0.3, out_w - wall - post_d / 2 + 0.3],
       y = [wall + post_d / 2 - 0.3, out_h - wall - post_d / 2 + 0.3])
    translate([x, y, 0]) children();
}

module body() {
  difference() {
    rrect(out_w, out_h, body_d, 3);
    // inner cavity (open at the back)
    translate([wall, wall, front_t]) cube([in_w, in_h, body_d]);
    // display window through the front plate
    translate([wall + tail_w + tol + (disp_w - win_w) / 2 + win_off_x,
               wall + strip_h + tol + (disp_h - win_h) / 2, -1])
      cube([win_w, win_h, front_t + 2]);
    // USB-C slot in the right wall, aligned with the XIAO (behind the display, right end)
    translate([out_w - wall - 1, by + 2.2 + (xiao_h - usb_w) / 2, front_t + disp_t + 0.5])
      cube([wall + 2, usb_w, usb_h]);
    // plunger hole in the right wall
    translate([out_w - wall - 1, btn_y, btn_z])
      rotate([0, 90, 0]) cylinder(d = btn_hole_d, h = wall + 2);
  }
  // display seat: rim around the panel (stick the panel on with a thin strip of double-sided tape)
  difference() {
    translate([wall + tail_w + tol - 1.2, wall + strip_h + tol - 1.2, front_t])
      cube([disp_w + 2.4, disp_h + 2.4, disp_t]);
    translate([wall + tail_w + tol, wall + strip_h + tol, front_t - 0.1])
      cube([disp_w, disp_h, disp_t + 0.2]);
  }
  // screw posts
  difference() {
    intersection() {
      union() post_positions() cylinder(d = post_d, h = body_d);
      rrect(out_w, out_h, body_d, 3);
    }
    post_positions() translate([0, 0, body_d - 8]) cylinder(d = screw_pilot, h = 9);
  }
  // battery and XIAO guide ribs behind the display: battery left, XIAO (USB-C towards the right wall) right
  translate([wall + 2, by, front_t + disp_t]) cube([bat_l + 1, 1.2, 1.5]);
  translate([wall + 2, by + bat_w + 1, front_t + disp_t]) cube([bat_l + 1, 1.2, 1.5]);
  // switch pocket against the right wall: open towards the lid, so the switch drops in from behind
  // (stem towards the wall, pins towards the inside). Plunger flange sits between wall and stem.
  x0 = out_w - wall;
  translate([x0 - 2.7 - sw_body - 0.2, btn_y - sw_w / 2 - 1.2, btn_z - sw_w / 2 - 1.2])
    cube([sw_body + 0.4, 1.2, body_d - (btn_z - sw_w / 2 - 1.2)]);
  translate([x0 - 2.7 - sw_body - 0.2, btn_y + sw_w / 2, btn_z - sw_w / 2 - 1.2])
    cube([sw_body + 0.4, 1.2, sw_w + 1.2]);
  translate([x0 - 2.7 - sw_body - 0.2, btn_y - sw_w / 2 - 1.2, btn_z - sw_w / 2 - 1.2])
    cube([sw_body + 0.4, sw_w + 2.4, 1.2]);
  // RTC board guide ribs in the strip below the display
  rx = wall + (in_w - rtc_l) / 2;
  translate([rx, wall + 0.6, front_t]) cube([rtc_l, 1.2, rtc_t]);
  translate([rx, wall + 0.6 + 1.2 + rtc_w, front_t]) cube([rtc_l, 1.2, rtc_t]);
}

module lid() {
  difference() {
    rrect(out_w, out_h, lid_t, 3);
    // screw holes with countersink
    post_positions() {
      translate([0, 0, -1]) cylinder(d = screw_clear, h = lid_t + 2);
      translate([0, 0, lid_t - 1.2]) cylinder(d1 = screw_clear, d2 = 4.6, h = 1.21);
    }
    // two optional magnet pockets (8 x 2 mm) on the outside for sticking on a fridge
    for (x = [out_w * 0.3, out_w * 0.7])
      translate([x, out_h / 2, -0.01]) cylinder(d = 8.2, h = 2.2);
  }
}

module plunger() {
  cylinder(d = 8, h = 1.2);                       // flange, kept inside the wall
  cylinder(d = plunger_d, h = 1.2 + wall + 0.8);   // shaft, about 0.8 mm proud of the wall
}

if (part == "plunger") plunger();
else if (part == "body") body();
else if (part == "lid") lid();
else {
  body();
  translate([0, 0, body_d + 10]) lid();
}
