cards_to_store = 4;

version = 23;
include <engraving.scad>
include <keys/ho.scad>
include <keys/ju.scad>
include <keys/tr.scad>
include <keys/bv.scad>

cc_h = 54.1;
cc_w = 85.6;
cc_t = 0.9;

side_wall = 0.87;
top_wall = 0.87;
mid_wall = 0.87;
front_gap = 0.5;
card_spacing = 0;
cc_h_gap = 0.25;
cards_gap = 0.9;

key_from_top = 0.8;
key_spacing_top = 0.2;
key_spacing_side = 0.4;

edge_rounding = side_wall;

current_color = "yellow";

rotate([0,-90,0])
  portemonnaie(cards_to_store, false);


module portemonnaie(number_of_cards, draft=true) {
  w = 87.5;
  h = 59.5;

  multicolor("yellow") difference() {
    union() {
      card_box(w, h, number_of_cards);
      key_box(w, h);
    }
    if (draft) {
      translate([0,h/2,0]) rotate([90,0,0]) rotate([0,90,0])
        engraving();
    }
  }
}


module card_box(w, h, number_of_cards) {
  t_c = (cc_t+card_spacing)*number_of_cards + cards_gap;
  h_c = cc_h+cc_h_gap*2;
  w_c = cc_w+front_gap;
  t = t_c + top_wall + mid_wall;

  difference() {
    rounded_rect(w, h, t, edge_rounding);
    translate([w-w_c, (h-h_c)/2, mid_wall])
      cube([w_c, h_c, t_c]);
    translate([0, h/2, t-top_wall])
      card_window(w);
  }

  %translate([w-w_c+cc_h_gap, (h-h_c)/2+cc_h_gap, top_wall+cards_gap/2])
    card(cards_to_store);
}

module rounded_rect(w, h, t, edge_rounding) {
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
delta = 0.01;
module key_box(h,w) {
  gap = 0.4;
  inset = 0.5;
  t_top = 0.8;
  d = 2.5 + t_top;

  window_d_offset = -4.5;
  window_steg = 1;

  difference() {
    translate([0,delta,0]) 
      mirror([0,0,1]) rounded_rect(h, w-2*delta, d, edge_rounding);
    //keys
    translate([h-48,0,0]) {
        translate([0,0,0]) rotate([180,0,90])
          key_ju(inset, gap);
        translate([0,window_steg,window_d_offset]) rotate([0,0,90])
          key_window();

        translate([16.5,w,0]) rotate([180,0,270])
          key_bv(inset, gap);
        translate([16.5,w-window_steg,window_d_offset]) rotate([0,0,-90])
          key_window();

        translate([34,0,0]) rotate([180,0,90])
          key_tr(inset, gap);
        translate([34,window_steg,window_d_offset]) rotate([0,0,90])
          key_window();
    }
    // money box
    money_slot(w, 28, d+delta);
  }
}

module money_slot(w, h, d_outer) {
  d = d_outer - 0.8;
  t = 1;
  t_border = 1;
  translate([t_border,-delta,-d]) cube([h-t-t_border,w-t,d]);

  window_h = 12;
  window_w = 40;
  window_bow = 10;
  translate([h/2,w/2,-10]) rotate([0,0,90]) hull() {
    translate([-window_w/2+window_bow/2,0,0]) scale([window_bow/window_h,1,1]) cylinder(d=window_h, h=d+10);
    translate([window_w/2-window_bow/2,0,0]) scale([window_bow/window_h,1,1]) cylinder(d=window_h, h=d+10);
  }
}

// swiss paper money is 70x151 (200CHFs)
module money() {
  cube([70, 36, 1.5]);
}


module multicolor(color) {
  if (current_color != "ALL" && current_color != color) {
    // ignore our children.
  } else {
    color(color) children();
  }
}
