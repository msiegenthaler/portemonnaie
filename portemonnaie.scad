cards_to_store = 4;

version = 3;
include <engraving.scad>

cc_h = 54.1;
cc_w = 85.6;
cc_t = 0.8;

key_l = 57.2;
key_t = 2.8;
key_top_w = 25.9;
key_m1_d = 30.1;
key_m1_w = 13.0;
key_m2_d = 25.9;
key_m2_w = 9.2;
key_bottom_w = 7.4;

side_wall = 2.5;
top_wall = 1;
mid_wall = 0.4;
front_gap = -1;
card_spacing = 0;
cc_h_gap = 0.25;
cards_gap = 0.5;

key_from_top = side_wall;
key_spacing_top = 0.1;
key_spacing_side = 0.08;

portemonnaie(cards_to_store);

%translate([side_wall, side_wall+cc_h_gap, top_wall+cards_gap/2])
  card(cards_to_store);
%translate([cc_w+side_wall+front_gap-0.5,key_from_top,-key_t]) rotate([0,0,180]) {
  key();
}


module portemonnaie(number_of_cards, draft=true) {
  w = cc_w + side_wall + front_gap;
  h = cc_h + 2*side_wall + 2*cc_h_gap;
  
  card_box(w, h, number_of_cards, draft);
  key_box(w, h);
}

module card_box(w, h, number_of_cards, draft) {
  t_c = (cc_t+card_spacing)*number_of_cards + cards_gap;
  t = t_c + top_wall + mid_wall;

  difference() {
    cube([w, h, t]);
    translate([side_wall, side_wall, mid_wall])
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


module key_box(w,h) {
  t = key_t + top_wall + key_spacing_top*2;
  t_neg = key_t + 2*key_spacing_top;
  key_inset = 0.5;  window_inset = 4;
  y1 = key_from_top + key_top_w/2 + key_spacing_side;
  difference() {
    translate([0,0,-t])
      cube([w,h,t]);
    translate([w-window_inset, y1, -t])
      key_window();
    translate([w-key_inset, key_from_top, -t_neg]) rotate([0,0,180]) linear_extrude(t_neg)
      key_negative(key_inset, key_spacing_side);
  }
}

module key_window() {
  h = 14;
  l = 22;
  offset = 18.5;
  factor = 1;
  translate([h/2-l, 0, 0]) hull() {
    cylinder(d=h,h=top_wall);
    translate([l-h/2-h/2*factor,0,0]) scale([factor,1,1])
      cylinder(d=h,h=top_wall);
  }
}

module key_negative(inset=2, gap=2) {
  x0=0;             y0=key_top_w/2+gap;
  x1=key_m1_d+gap;  y1=key_m1_w/2+gap;
  x2=key_l+gap;     y2=key_bottom_w/2+gap;
  translate([0,-y0,0]) polygon([
    [-inset,y0],
    [x0,y0],  [x1,y1],  [x1,y2],  [x2,y2],
    [x2,-y2], [x1,-y2], [x1,-y1], [x0,-y0],
    [-inset,-y0]
  ]);
}

module key() {
  x0 = 0;         y0 = key_top_w/2;
  x1 = key_m2_d;  y1 = key_m2_w/2;
  x2 = key_m1_d;  y2 = key_m1_w/2;
  x3 = key_l;     y3 = key_bottom_w/2;
  translate([0,-y0,0]) linear_extrude(key_t) polygon([
    [x0,y0],  [x1,y1],  [x2,y2],  [x2,y3],  [x3,y3],
    [x3,-y3], [x2,-y3], [x2,-y2], [x1,-y1], [x0,-y0]
  ]);
}