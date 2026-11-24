// Egg freshness tracker - 3D-printable case (OpenSCAD, all dimensions in mm).
//
// UNTESTED: this case has been rendered to STL but NOT printed or fitted with real hardware.
// Measure your parts with calipers and adjust the "Parts" values before printing.
//
// Parts (printed separately, no supports needed if printed as exported):
//   body - front shell with display window, USB-C slot and button hole. Print window side DOWN.
//   lid  - back plate, fixed with 4 x M2 self-tapping screws (6-8 mm long). Print flat.
//
// Render:  openscad -D 'part="body"' -o body.stl egg-case.scad
//          openscad -D 'part="lid"'  -o lid.stl  egg-case.scad
// Or open in OpenSCAD and set `part` below ("body", "lid" or "preview").

part = "preview";

// ---- Parts (check against your actual parts!) ------------------------------------------
// Bare 2.13" e-paper panel + flex tail area. Waveshare lists ~59.2 x 29.2 mm for the panel;
// the 8-pin breakout/cable adds length at one short edge. VERIFY.
disp_w = 59.5;       // panel width (long side)
disp_h = 29.5;       // panel height
disp_t = 1.6;        // panel thickness incl. adhesive
win_w = 49.5;        // visible window (active area is about 48.6 x 23.7)
win_h = 24.7;
win_off_x = 0;       // shift window if active area is not centred on the panel
tail_w = 9;          // room at the left edge for the flex tail and 8-pin connector

// Seeed XIAO ESP32-C3 is about 21 x 17.8 mm, 3.5 mm incl. USB-C shell about 8.4 x 3.2 mm.
xiao_w = 21.5;
xiao_h = 18.3;
usb_w = 9.5;
usb_h = 4.0;

// LiPo cell, e.g. 503035 = 5 x 30 x 35 mm (thickness x width x length) incl. wrap.
bat_l = 35.5;
bat_w = 30.5;
bat_t = 5.5;         // if you use a thicker cell, increase cavity_d accordingly

btn_hole_d = 7.0;    // hole for a 6 x 6 mm tactile switch with a cap

// ---- Case -------------------------------------------------------------------------------
wall = 2.0;
front_t = 2.0;       // front plate thickness (window is cut through it)
lid_t = 3.0;
tol = 0.3;
cavity_d = 12.0;     // depth behind the display (battery 5.5 + wiring + XIAO + clearance)

in_w = disp_w + tail_w + 2 * tol;        // inner width
in_h = disp_h + 2 * tol + 8;             // inner height: extra strip for PCF8563/button wiring
out_w = in_w + 2 * wall;
out_h = in_h + 2 * wall;
body_d = front_t + disp_t + cavity_d;    // total depth of the body shell
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
               wall + 8 + tol + (disp_h - win_h) / 2, -1])
      cube([win_w, win_h, front_t + 2]);
    // USB-C slot in the bottom wall, aligned over the XIAO position (lower right)
    translate([out_w - wall - xiao_w / 2 - 2 - usb_w / 2, -1, front_t + disp_t + 1])
      cube([usb_w, wall + 2, usb_h]);
    // button hole in the right wall
    translate([out_w - wall - 1, out_h - wall - 5, front_t + disp_t + cavity_d / 2])
      rotate([0, 90, 0]) cylinder(d = btn_hole_d, h = wall + 2);
  }
  // display seat: rim around the panel (stick the panel on with a thin strip of double-sided tape)
  difference() {
    translate([wall + tail_w + tol - 1.2, wall + 8 + tol - 1.2, front_t])
      cube([disp_w + 2.4, disp_h + 2.4, disp_t]);
    translate([wall + tail_w + tol, wall + 8 + tol, front_t - 0.1])
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
  // battery and XIAO guide ribs on the back of the front plate area
  translate([wall + 2, wall + 2, front_t + disp_t]) cube([bat_l + 1, 1.2, 1.5]);
  translate([wall + 2, wall + 2 + bat_w + 1, front_t + disp_t]) cube([bat_l + 1, 1.2, 1.5]);
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

if (part == "body") body();
else if (part == "lid") lid();
else {
  body();
  translate([0, 0, body_d + 10]) lid();
}
