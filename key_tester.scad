include <keys/ju.scad>
include <keys/tr.scad>
include <keys/bv.scad>

delta = 0.01;
gap = 0.4;
inset = 0.5;

w = 60;
h = 62;
t_top = 0.8;
d = 2.5 + t_top+1;

d = 2.95; // cut off the top

difference() {
    cube([w-2*delta, h, d]);
    translate([w-delta,0,t_top]) {
        translate([-w,14,0]) {
            key_tr(inset, gap);
            key_window_positioned();
        }
        translate([0,32,0]) rotate([0,0,180]) {
            key_bv(inset, gap);
            key_window_positioned();
        }
        translate([-w,49,0]) {
            key_ju(inset, gap);
            key_window_positioned();
        }
    }
}
