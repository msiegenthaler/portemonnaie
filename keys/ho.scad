key_l = 57.2;
key_t = 2.8;
key_top_w = 26.0;
key_top_d = 4.5;

key_m1_d = 30.1;
key_m1_w = 13.5;
key_m2_d = 25.8;
key_m2_w = 9.2;
key_bottom_w = 7.4;

module key_ho_detail() {
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



module key_ho(inset, gap) {
  a = (key_top_w/2+gap)-(key_m2_w/2+gap);
  b = (key_m1_w-key_m2_w)/2;
  c = key_m2_d-key_top_d;
  k = b * c/a; //where the outdent meets the shaft line

  x0=-inset;        y0=key_top_w/2+gap;
  x1=key_top_d;     y1=y0;
  x2=key_m2_d-k+2;  y2=key_m1_w/2+gap;
  x3=key_m1_d+gap;  y3=key_m1_w/2+gap;
  x4=key_m1_d+gap;  y4=key_bottom_w/2+gap;
  x5=key_l+gap;     y5=key_bottom_w/2+gap;
  translate([0,-y0,0]) polygon([
    [x0,y0],  [x1,y1],  [x2,y2],  [x3,y3],  [x4,y4],  [x5,y5],
    [x5,-y5], [x4,-y4], [x3,-y3], [x2,-y2], [x1,-y1], [x0,-y0],
  ]);
}
