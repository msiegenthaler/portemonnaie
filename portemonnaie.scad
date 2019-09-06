cards_to_store = 5;

version = 13;
include <engraving.scad>

cc_h = 54.1;
cc_w = 85.6;
cc_t = 0.9;

key_l = 54.2;
key_t = 2.3;
key_top_w = 24.9;
key_top_d = 4.5;

key_m2_d = 19.9;
key_m2_w = 21.2;
key_m1_d = 24.1;
key_m1_w = 12.0;
key_bottom_w = 9.4;

side_wall = 0.87;
top_wall = 0.87;
mid_wall = 0.87;
front_gap = 0.5;
card_spacing = 0;
cc_h_gap = 0.25;
cards_gap = 0.9;

key_from_top = 0.8;
key_spacing_top = 0.1;
key_spacing_side = 0.1;

edge_rounding = side_wall*0.75;

current_color = "gold";

rotate([0,-90,0])
  portemonnaie(cards_to_store, false);

module portemonnaie(number_of_cards, draft=true) {
  w = 95.5;
  h = 61.3;

  multicolor("gold") difference() {
    union() {
      card_box(w, h, number_of_cards);
      key_box(w, h);
    }
    if (draft) {
      translate([0,h/2,0]) rotate([90,0,0]) rotate([0,90,0])
        engraving();
    }
  }

  %translate([w-0.5,key_from_top,-key_t]) rotate([0,0,180])
    key();
}

module card_box(w, h, number_of_cards) {
  t_c = (cc_t+card_spacing)*number_of_cards + cards_gap;
  h_c = cc_h+cc_h_gap*2;
  w_c = cc_w+front_gap;
  t = t_c + top_wall + mid_wall;

  difference() {
    hull() {
      translate([edge_rounding,edge_rounding,t-edge_rounding]) sphere(r=edge_rounding);
      translate([w-edge_rounding,edge_rounding,t-edge_rounding]) sphere(r=edge_rounding);
      translate([edge_rounding,h-edge_rounding,t-edge_rounding]) sphere(r=edge_rounding);
      translate([w-edge_rounding,h-edge_rounding,t-edge_rounding]) sphere(r=edge_rounding);
      translate([edge_rounding,edge_rounding,0]) cylinder(r=edge_rounding, h=edge_rounding);
      translate([w-edge_rounding,edge_rounding,0]) cylinder(r=edge_rounding, h=edge_rounding);
      translate([edge_rounding,h-edge_rounding,0]) cylinder(r=edge_rounding, h=edge_rounding);
      translate([w-edge_rounding,h-edge_rounding,0]) cylinder(r=edge_rounding, h=edge_rounding);
    }
    translate([w-w_c, (h-h_c)/2, mid_wall])
      cube([w_c, h_c, t_c]);
    translate([0, h/2, t-top_wall])
      card_window(w);
  }

  %translate([w-w_c+cc_h_gap, (h-h_c)/2+cc_h_gap, top_wall+cards_gap/2])
    card(number_of_cards);
}

module card_window(outer_w) {
  h = 22;
  l = 45;
  factor = 0.4;
  translate([outer_w/2-l/2,0,0])
  translate([h/2-h/2*factor, 0, 0]) hull() {
    cylinder(d=h,h=top_wall, $fa=0.5);
    translate([l-h/2*factor,0,0]) scale([factor,1,1])
      cylinder(d=h,h=top_wall, $fa=0.5);
  }
}

module card(n=1) {
  cube([cc_w,cc_h,cc_t*n]);
}


$fs = 0.1;
module key_box(w,h) {
  t = key_t + top_wall + key_spacing_top*2;
  t_neg = key_t + 2*key_spacing_top;
  key_inset = 0.5;  window_inset = 2.7;
  y1 = key_from_top + key_top_w/2 + key_spacing_side;
  difference() {
    union() {
      hull() {
        translate([edge_rounding,edge_rounding,-t+edge_rounding]) sphere(r=edge_rounding);
        translate([w-edge_rounding,edge_rounding,-t+edge_rounding]) sphere(r=edge_rounding);
        translate([edge_rounding,h-edge_rounding,-t+edge_rounding]) sphere(r=edge_rounding);
        translate([w-edge_rounding,h-edge_rounding,-t+edge_rounding]) sphere(r=edge_rounding);
        translate([edge_rounding,edge_rounding,-edge_rounding]) cylinder(r=edge_rounding, h=edge_rounding);
        translate([w-edge_rounding,edge_rounding,-edge_rounding]) cylinder(r=edge_rounding, h=edge_rounding);
        translate([edge_rounding,h-edge_rounding,-edge_rounding]) cylinder(r=edge_rounding, h=edge_rounding);
        translate([w-edge_rounding,h-edge_rounding,-edge_rounding]) cylinder(r=edge_rounding, h=edge_rounding);
      }
    }
    translate([w-window_inset, y1, -t])
      key_window();
    translate([w-key_inset, key_from_top, -t_neg]) rotate([0,0,180]) {
      difference() {
        linear_extrude(t_neg) key_negative(key_inset, key_spacing_side);
        translate([3,-key_top_w/2,t_neg]) scale([0.2,0.2,0.15]) sphere(r=10);
      }
    }

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
          cylinder(d=d, h=top_wall, $fa=0.2);
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
  k = 0;

  x0=-inset;        y0=key_top_w/2+gap;
  x1=key_top_d;     y1=y0;
  x2=key_m2_d-k+2;  y2=key_m2_w/2+gap;
  x3=key_m1_d+gap;  y3=key_m1_w/2+gap;
  x4=key_l+gap;     y4=key_bottom_w/2+gap;
  translate([0,-y0,0]) polygon([
    [x0,y0],  [x1,y1],  [x2,y2],  [x3,y3],  [x3,y4],  [x4,y4],
    [x4,-y4], [x3,-y4], [x3,-y3], [x2,-y2], [x1,-y1], [x0,-y0],
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

module multicolor(color) {
  if (current_color != "ALL" && current_color != color) {
    // ignore our children.
  } else {
    color(color) children();
  }
}