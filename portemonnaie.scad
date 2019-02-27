cards_to_store = 4;

version = 2;
include <engraving.scad>

cc_h = 54.1;
cc_w = 85.6;
cc_t = 0.8;

key_l = 57.2;
key_top_w = 25.9;
key_m1_d = 30.1;
key_m1_w = 13.0;
key_m2_d = 25.9;
key_m2_w = 9.2;
key_bottom_w = 7.4;

side_wall = 2.5;
top_wall = 1.2;
front_gap = -1;
card_spacing = 0;
cc_h_gap = 0.25;
cards_gap = 0.5;

x(cards_to_store);
%translate([side_wall, side_wall+cc_h_gap, top_wall+cards_gap/2])
  card(cards_to_store);

module x(number_of_cards, draft=true) {
  w = cc_w + side_wall + front_gap;
  h = cc_h + 2*side_wall + 2*cc_h_gap;
  t_c = (cc_t+card_spacing)*number_of_cards + cards_gap;
  t = t_c + 2*top_wall;
  
  difference() {
    cube([w, h, t]);
    translate([side_wall, side_wall, top_wall])
      cube([w-side_wall, h-2*side_wall, t_c]);
    translate([0, h/2, t-top_wall])
      card_window(w);
    if (draft) {
      translate([0,h/2,t/2]) rotate([90,0,0]) rotate([0,90,0])
        engraving();
    }
  }
}

module card_window(outer_w) {
  h = 22;
  l = 63;
  offset = 18.5;
  factor = 0.4;
  translate([outer_w/2-l/2,0,0])
  translate([h/2*factor, 0, 0]) hull() {
    scale([factor,1,1])
      cylinder(d=h,h=top_wall);
    translate([l-h/2-h/2*factor,0,0])
      cylinder(d=h,h=top_wall);
  }
}






module card(n=1) {
  cube([cc_w,cc_h,cc_t*n]);
}