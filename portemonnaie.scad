cards_to_store = 4;

version = 22;
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

// rotate([0,-90,0])
  // portemonnaie(cards_to_store, false);

all_keys();


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

module all_keys() {
  translate([0,0,0])
    key_ju(0, key_spacing_side);
  translate([0,50,0])
    key_tr(0, key_spacing_side);
  translate([0,100,0])
    key_bv(0, key_spacing_side);
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
    card(cards_to_store);
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
  key_inset = 0.5;  window_inset = 3.5;
  y1 = key_from_top + key_top_w/2 + key_spacing_side;
  key2_offset = w - 32.7;
  stopper_h = 0.7;
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
    translate([w-key_inset-key_m1_w,window_inset,-t]) rotate([0,0,-90])
      key_window();
    translate([w-key_inset-key_m1_w*2, key_from_top-0.3, -t_neg]) rotate([0,0,90]) {
      difference() {
        linear_extrude(t_neg) key_ho(key_inset, key_spacing_side);
        difference() {
          translate([4,-key_top_w/2,t_neg]) scale([0.2,0.4,0.15]) sphere(r=10);
          translate([0,-20,t_neg-2-stopper_h]) cube([10,20,2]);
        }
      }
    }
    translate([key2_offset, h-window_inset,-t]) rotate([0,0,90])
      key_window();
    translate([key2_offset, h, -t_neg]) rotate([0,0,-90]) {
      difference() {
        linear_extrude(t_neg) rotate([0,0,-0]) key_ju(key_inset, key_spacing_side);
        difference() {
          translate([4.5,0,t_neg]) scale([0.2,0.4,0.15]) sphere(r=10);
          translate([0,-5,t_neg-2-stopper_h]) cube([20,10,2]);
        }
      }
    }

    translate([0,0,0])
      paper_money_slot_negative(w, h, t);
  }
}

module paper_money_slot_negative(w_full, h_full, t) {
  w = 40;
  h = h_full-side_wall*2;
  d = w; d_flat = h-d/2;
  wall = side_wall*1.5;
  slider_d = 13; slider_l = 20;
  translate([side_wall, h_full-h-side_wall+2, -t+wall]) {
    union() {
      linear_extrude(t)
        polygon(points=[[0,0], [w,0], [w,h], [0,h]]);
      gstranslate([h/2-slider_d/2,w/2,-wall]) linear_extrude(side_wall*2) hull() {
        translate([0,-slider_l/2+slider_d/2]) scale([1,0.5]) circle(d=slider_d);
        translate([0,slider_l/2+slider_d/2]) scale([1,0.5]) circle(d=slider_d);
      }
    }
  }
}

module paper_money_negative(w_full, h_full, t) {
  w = 41;
  h = h_full-side_wall*2;
  d = w; d_flat = h-d/2;
  translate([side_wall, h_full-h-side_wall, -t]) {
    difference() {
      linear_extrude(t)
        polygon(points=[[0,0], [w,0], [w,h], [0,h]]);
      hull() {
        translate([0,d_flat,0])
          cylinder(d=d, h=top_wall, $fa=0.2);
        cube([d/2,d_flat,top_wall]);
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
  l = 7;
  factor = 0.4;
  union() {
    intersection() {
      translate([-l-10+2,-h/2,0]) cube([l+10, h, top_wall+0.2]);
      translate([-l+h*factor/2-0.7,0,0]) scale([factor,1,1]) cylinder(d=h,h=top_wall+0.2, $fa=0.5);
    }
    translate([-l+2,-h/2,0])
      cube([l, h, top_wall+0.2]);
  }
}




module multicolor(color) {
  if (current_color != "ALL" && current_color != color) {
    // ignore our children.
  } else {
    color(color) children();
  }
}
