cards_to_store = 4;

version = 7;
include <engraving.scad>

cc_h = 54.1;
cc_w = 85.6;
cc_t = 0.9;

key_l = 57.2;
key_t = 2.8;
key_top_w = 26.0;
key_top_d = 4.5;

key_m1_d = 30.1;
key_m1_w = 13.5;
key_m2_d = 25.8;
key_m2_w = 9.2;
key_bottom_w = 7.4;

side_wall = 1.0;
top_wall = 0.8;
mid_wall = 0.5;
front_gap = 0.5;
card_spacing = 0;
cc_h_gap = 0.25;
cards_gap = 0.9;

key_from_top = 0.8;
key_spacing_top = 0.1;
key_spacing_side = 0.1;

portemonnaie(cards_to_store);

module portemonnaie(number_of_cards, draft=true) {
  w = 91.6;
  h = 60.6;
  
  card_box(w, h, number_of_cards, draft);
  key_box(w, h);

  %translate([w-0.5,key_from_top,-key_t]) rotate([0,0,180])
    key();
}

module card_box(w, h, number_of_cards, draft) {
  t_c = (cc_t+card_spacing)*number_of_cards + cards_gap;
  h_c = cc_h+cc_h_gap*2;
  w_c = cc_w+front_gap;
  t = t_c + top_wall + mid_wall;

  difference() {
    cube([w, h, t]);
    translate([w-w_c, (h-h_c)/2, mid_wall])
      cube([w_c, h_c, t_c]);
    translate([0, h/2, t-top_wall])
      card_window(w);
    if (draft) {
      translate([0,h/2,t/2]) rotate([90,0,0]) rotate([0,90,0])
        engraving();
    }
  }

  %translate([w-w_c+cc_h_gap, (h-h_c)/2+cc_h_gap, top_wall+cards_gap/2])
    card(cards_to_store);
}

module card_window(outer_w) {
  h = 22;
  l = 63;
  factor = 0.4;
  translate([outer_w/2-l/2,0,0])
  translate([h/2*factor, 0, 0]) hull() {
    scale([factor,1,1])
      cylinder(d=h,h=top_wall, $fa=0.5);
    translate([l-h/2-h/2*factor,0,0])
      cylinder(d=h,h=top_wall, $fa=0.5);
  }
}

module card(n=1) {
  cube([cc_w,cc_h,cc_t*n]);
}


module key_box(w,h) {
  t = key_t + top_wall + key_spacing_top*2;
  t_neg = key_t + 2*key_spacing_top;
  key_inset = 0.5;  window_inset = 2.7;
  y1 = key_from_top + key_top_w/2 + key_spacing_side;
  difference() {
    translate([0,0,-t])
      cube([w,h,t]);
    translate([w-window_inset, y1, -t])
      key_window();
    translate([w-key_inset, key_from_top, -t_neg]) rotate([0,0,180]) linear_extrude(t_neg)
      key_negative(key_inset, key_spacing_side);

    translate([0,0,0])
      paper_money_negative(w, h, t);
  }

  %translate([side_wall,h-36-side_wall,-3])
    money();
}

module paper_money_negative(w_full, h_full, t) {
  w = 71;
  h = 38;
  d = h*2; d_flat = 4;
  translate([side_wall, h_full-h-side_wall, -t]) {
    difference() {
      linear_extrude(t)
        polygon(points=[[0,0], [w,0], [w,h], [0,h]]);
      hull() {
        translate([d_flat,h,0])
          cylinder(d=d, h=top_wall, $fa=0.5);
        translate([0,h-d/2,0])
          cube([10,d/2,top_wall]);
      }
    }
  }
}

// swiss paper money is 70x151 (200CHFs)
module money() {
  cube([70, 36, 1.5]);
}

module key_window() {
  h = 14;
  l = 22;
  factor = 0.4;
  translate([h/2-l, 0, 0]) hull() {
    cylinder(d=h,h=top_wall, $fa=0.5);
    translate([l-h/2-h/2*factor,0,0]) scale([factor,1,1])
      cylinder(d=h,h=top_wall, $fa=0.5);
  }
}

module key_negative(inset, gap) {
  a = (key_top_w/2+gap)-(key_m2_w/2+gap);
  b = (key_m1_w-key_m2_w)/2;
  c = key_m2_d-key_top_d;
  k = b * c/a; //where the outdent meets the shaft line

  x0=-inset;        y0=key_top_w/2+gap;
  x1=key_top_d;     y1=y0;
  x2=key_m2_d-k;      y2=key_m1_w/2+gap;
  x3=key_m1_d+gap;  y3=key_m1_w/2+gap;
  x4=key_m1_d+gap;  y4=key_bottom_w/2+gap;
  x5=key_l+gap;     y5=key_bottom_w/2+gap;
  #translate([0,-y0,0]) polygon([
    [x0,y0],  [x1,y1],  [x2,y2],  [x3,y3],  [x4,y4],  [x5,y5],
    [x5,-y5], [x4,-y4], [x3,-y3], [x2,-y2], [x1,-y1], [x0,-y0],
  ]);
}

module key() {
  x0 = 0;         y0 = key_top_w/2;
  x1 = key_top_d; y1 = key_top_w/2;
  x2 = key_m2_d;  y2 = key_m2_w/2;
  x3 = key_m1_d;  y3 = key_m1_w/2;
  x4 = key_l;     y4 = key_bottom_w/2;
  translate([0,-y0,0]) linear_extrude(key_t) polygon([
    [x0,y0],  [x1,y1],  [x2,y2],  [x3,y3],  [x3,y4],  [x4,y4],
    [x4,-y4], [x3,-y4], [x3,-y3], [x2,-y2], [x1,-y1], [x0,-y0]
  ]);
}
