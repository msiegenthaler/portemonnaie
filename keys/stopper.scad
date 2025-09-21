module key_stopper(width, height) {
  d = 0.3;
  difference() {
    translate([0,0,0]) scale([height/20,width/20,d/8]) sphere(r=10);
    translate([-height/2,-width/2,d]) cube([height,width,2]);
    translate([-height/2,-width/2,-2]) cube([height,width,2]);
  }
}



module key_window() {
    d = 3;
    l = 14; h = 12; r_h = 4;
    union() {
        translate([0,-l/2,0]) cube([h-r_h/2, l, d]);
        translate([h-r_h/2,0,0]) scale([r_h/10, l/10, 1]) cylinder(d=10, h=d, $fn=50);
    }
}

module key_window_positioned() {
    translate([0.5,0,1.8]) key_window();
}
