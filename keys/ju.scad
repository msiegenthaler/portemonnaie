module key_ju(inset, gap) {
  w_top = 22.9+gap;     h_maxw = 16.5+inset;
  w_stopper = 11+gap;   h_stopper = 22.5+inset;
  w_beard = 7.8+gap;    h_beard_s = 28.5+inset;
  h_total = 57+inset;
  rotate([0,0,270]) polygon([
    [0,0], [w_top/2,0], [w_top/2,h_maxw],
    [w_stopper/2, h_stopper], [w_stopper/2, h_beard_s],
    [w_beard/2, h_beard_s], [w_beard/2, h_total], [0, h_total],
    [-w_beard/2, h_total], [-w_beard/2, h_beard_s],
    [-w_stopper/2, h_beard_s], [-w_stopper/2, h_stopper],
    [-w_top/2,h_maxw], [-w_top/2,0],
  ]);
}

