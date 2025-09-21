include <stopper.scad>

module key_tr(inset=0, gap=0, d_gap=0) {
  w_top = 25+gap;       h_maxw = 17.5+inset;
  w_stopper = 12+gap;   h_stopper = 24.5+inset;
  w_beard = 10+gap;     h_beard_s = 31+inset;
  h_total = 58.5+inset; d=2.3+d_gap;
  stopper_from_top = 6.7;
  difference() {
    linear_extrude(d) rotate([0,0,270]) polygon([
      [0,0], [w_top/2,0], [w_top/2,h_maxw],
      [w_stopper/2, h_stopper], [w_stopper/2, h_beard_s],
      [w_beard/2, h_beard_s], [w_beard/2, h_total], [0, h_total],
      [-w_beard/2, h_total], [-w_beard/2, h_beard_s],
      [-w_stopper/2, h_beard_s], [-w_stopper/2, h_stopper],
      [-w_top/2,h_maxw], [-w_top/2,0],
    ]);
    translate([stopper_from_top,0,-0.01]) key_stopper(6,6);
  }
}
