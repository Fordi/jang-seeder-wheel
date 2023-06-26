/**
 * Parametric Jang Seeder Wheel
 * Author: Bryan Elliott <fordiman@gmail.com>
 * Contributors:
 *  [Bryan Elliott](https://github.com/Fordi)
 *  [fouroakfarm](https://www.thingiverse.com/fouroakfarm/designs) - Info about the "cone" type
 *  [mandrewcramer](https://github.com/mandrewcramer) - label feature
 *  [fernplant](https://github.com/fernplant) - lots of shape help
 *  [Peter Armstrong](https://github.com/peteretep) - J#-6 series
 * License: [CC-Attribution 4.0](https://creativecommons.org/licenses/by/4.0/)
 * Source code: https://github.com/Fordi/jang-seeder-wheel
**/

// Wheel diameter in mm
wheel_dia=60;
// Wheel width in mm
wheel_width=20;

// Thickness of rim in mm
rim_thickness=4;
// Thickness of slope to disc in mm
rim_slope=5;
// Thickness of disc in mm
disc_thickness=6;

// Diameter of circular part of bore in mm
bore_dia=15;
// Distance from edge to flatten bore in mm
bore_flat=2;
// Thickness of bore wall (hub) in mm
bore_wall=4;
// Thickness of ribs inside bore (for added support) in mm
bore_rib_depth=0.50;
// Width of bore bezel in mm
bore_bezel=0.5;

// Number of support spokes
spoke_count=9;
// Thickness of spokes in mm
spoke_thickness=1.5;
// Height of spokes through wheel in mm
spoke_height=13;

// Numberof total seed cells
seed_count=12;
// Rows of seed cells
seed_rows=1;
// Diameter of seed cells in mm
seed_size=3.5;
// Depth of seed cells in mm
seed_depth=1.75;

// Shape of seed imprint
seed_shape = "sphere"; // [sphere:sphere, cone:cone, half-moon:half-moon, cross:cross, slot:slot, finger:finger]

// Countersink around seed in mm
seed_countersink_size=0.01;

// Depth of countersink around seed in mm
seed_countersink_depth=0.01;

// Resolution of cylinders
cylinder_res=72;

// Resolution of seeds
seed_res=30;

// Text
text = "LABEL"; // Text string
text_size = 6;
text_depth = 0.4;
text_box_width = text_size+2;
text_box_length = 28;
text_box_height = spoke_height/2-disc_thickness/2+text_depth;


// Spoked and sloped main body OR solid
solid_main_body = false;

function chord(r, f) = sin(acos((r - f) / r)) * r;

module flattened_cylinder(r1, r2, h, f1, f2, $fn) {
  difference () {
    cylinder(r1=r1, r2=r2, h=h, $fn=$fn);
    polyhedron(
      points = [
        [ r1 - f1,  chord(r1, f1), -0.001],
        [ r1 - f1, -chord(r1, f1), -0.001],
        [ r2 - f2,  chord(r2, f2), 1.001*h],
        [ r2 - f2, -chord(r2, f2), 1.001*h],
        [ r1     ,  chord(r1, f1), -0.001],
        [ r1     , -chord(r1, f1), -0.001],
        [ r2     ,  chord(r2, f2), 1.001*h],
        [ r2     , -chord(r2, f2), 1.001*h],
      ],
      faces = [
        [0, 2, 3, 1],
        [5, 7, 6, 4],
        [4, 0, 1, 5],
        [3, 2, 6, 7],
        [7, 5, 1, 3],
        [4, 6, 2, 0],
      ]
    );
  }
};

module quarter_cylinder() {
  difference() {
    cylinder(h=1, d=2, $fn=seed_res);
    union() {
      translate([-1, -1, -0.001]) cube([2, 1, 1.002]);
      translate([-1, -1, -0.001]) cube([1, 2, 1.002]);
    }
  }
}

module unit_half_teardrop() {
  resize([1, 1, 1])
    union() {
      resize([0.5, 0, 0])
        translate([1, 0, 0])
          rotate([0, 0, 90])
            quarter_cylinder();
      translate([0.5, 0, 0])
        resize([0.333, 1, 0])
          difference() {
            scale([0.5, 0.5, 1]) 
              quarter_cylinder();
            translate([0.4, -0.001, -0.001])
              cube([0.5, 0.5, 1.002]);
          }
      translate([0.833, 0, 0])
        resize([0.75, 0.6, 0])
          translate([1, 1, 0])
            rotate(180)
              difference() {
                translate([0.001, 0.001, 0])
                  cube([0.999, 0.999, 1]);
                quarter_cylinder();
              }
    }
}

module finger(
  h=20,
  rh=5,
  d1=10,
  d2=10,
  $fn=30
) {
   translate([0, 0, rh]) union() {
    cylinder(
      h = h - rh,
      d1 = d1,
      d2 = d2,
      $fn = $fn
    );
    scale([d1, d1, rh*2]) sphere(d=1, $fn = $fn);
  }
}

module seedRoller(
  wheel_dia=60,
  wheel_width=20,
  rim_thickness=4,
  rim_slope=5,
  disc_thickness=6,
  bore_dia=15,
  bore_flat=2,
  bore_wall=4,
  bore_rib_depth=0.5,
  bore_bezel=0.5,
  spoke_count=9,
  spoke_thickness=1.5,
  spoke_height=13,
  seed_count=12,
  seed_rows=1,
  seed_size=3.5,
  seed_depth=1.75,
  seed_shape="sphere", // Thanks, [fouroakfarm](https://www.thingiverse.com/fouroakfarm/designs)!
  seed_countersink_depth=0.5,
  seed_countersink_size=1,
  cylinder_res=72,
  seed_res=30
) {
  flat_width=sin(acos((bore_dia / 2 - bore_flat) / (bore_dia / 2))) * bore_dia / 2;
  bezel_dia = bore_dia + bore_bezel * 2;
  bezel_flat = bore_flat + bore_bezel;
  flat_bevel_width=sin(acos((bezel_dia / 2 - bezel_flat) / (bezel_dia / 2))) * (bezel_dia / 2);
  // Override min_slope to prevent model holes
  min_rim_slope = max(rim_slope, 1.5*(seed_depth + seed_countersink_depth - rim_thickness));
  teardrop_ratio=1.2;

  difference() {
    // Rim / main body/cylinder
    if( solid_main_body )
      // Solid body
      if( text ) {
        //_offset = wheel_width-1;
        difference() {
          cylinder(d=wheel_dia, h=wheel_width, $fn=cylinder_res);
        rotate([0,0,270])
          translate([0,text_box_width/2+bore_dia/2+1,wheel_width-text_depth+.05])
              linear_extrude(text_depth) text(text, text_size, halign="center", valign="center");
        }      
      } else {
        cylinder(d=wheel_dia, h=wheel_width, $fn=cylinder_res);
      }
    else
      // Spoked body / copy of Jang design
      union() {
        // Rim
        difference() {
          cylinder(r=wheel_dia/2, h=wheel_width, $fn=cylinder_res);
          translate([0, 0, -(wheel_width - disc_thickness) / 2 * 0.001]) 
          cylinder(
            r1=wheel_dia/2 - rim_thickness,
            r2=wheel_dia/2 - rim_thickness - min_rim_slope,
            h=(wheel_width - disc_thickness) / 2 * 1.001,
            $fn=cylinder_res
          );
          
          translate([0, 0, wheel_width - (wheel_width - disc_thickness) / 2]) 
            cylinder(
              r1=wheel_dia/2 - rim_thickness - min_rim_slope,
              r2=wheel_dia/2 - rim_thickness,
              h=(wheel_width - disc_thickness) / 2 * 1.001,
              $fn=cylinder_res
            );
        }
      // Hub
      difference() {
        cylinder(r=bore_dia/2 + bore_wall, h=wheel_width, $fn=cylinder_res);
        translate([(bore_dia / 2 - bore_flat) + bore_wall, -(bore_dia/2 + bore_wall), -wheel_width * 0.001])
          cube([bore_flat, bore_dia + bore_wall*2, wheel_width * 1.002]);
      }
      
      // Spokes
      for (theta = [0 : (360 / spoke_count) : 360]) {
        rotate([0, 0, theta])
          translate([0, -spoke_thickness/2, (20-spoke_height)/2])
            cube([26.5, spoke_thickness, spoke_height]);
      }
    }
    // Bore

    union() {
      difference() {
        flattened_cylinder(
          r1=bore_dia / 2,
          r2=bore_dia / 2,
          f1=bore_flat,
          f2=bore_flat,
          h=wheel_width,
          $fn=cylinder_res
        );
        translate([bore_dia / 2 - bore_flat, -flat_bevel_width, 0])
          union() {
            translate([0, flat_bevel_width*2/3, 0]) cylinder(r=bore_rib_depth, h=20, $fn=cylinder_res);
            translate([0, flat_bevel_width*4/3, 0]) cylinder(r=bore_rib_depth, h=20, $fn=cylinder_res);
          }
        // Bore ribs
        for (theta = [0 : 60 : 300]) {
          rotate([0, 0, theta])
            translate([0, bore_dia/2, 0])
              cylinder(r=bore_rib_depth, h=20, $fn=cylinder_res);
        }
      }
      translate([0, 0, -bore_bezel * 2 * 0.001]) flattened_cylinder(
        r1  = bore_dia / 2 + bore_bezel, 
        r2  = bore_dia / 2 - bore_bezel, 
        f1  = bore_flat,
        f2  = bore_flat,
        h   = bore_bezel * 2 * 1.001, 
        $fn = cylinder_res
      );
      translate([0, 0, wheel_width - bore_bezel * 2])
        flattened_cylinder(
          r1  = bore_dia / 2 - bore_bezel, 
          r2  = bore_dia / 2 + bore_bezel, 
          f1  = bore_flat,
          f2  = bore_flat,
          h   = bore_bezel * 2 * 1.001, 
          $fn = cylinder_res
        );
    }
    // Seeds
    for(theta = [0 : (360 / (seed_count / seed_rows)) : 360 - (360 / (seed_count / seed_rows))]) {
      for(row = [0 : 1 : seed_rows - 1]) {
        rotate([0, 0, theta + (360 / seed_count * row)])
          translate([wheel_dia / 2 * 1.001, 0, wheel_width * (row + 0.5) / (seed_rows)]) {
            // Conical 'v' shape
            if(seed_shape == "cone") {
              rotate([0,270,0])
                union() {
                  if (seed_countersink_size > 0 && seed_countersink_depth > 0) {
                    cylinder(
                      h=seed_countersink_depth*1.001,
                      d1=seed_countersink_size * 2 + seed_size,
                      d2=seed_size,
                      $fn=seed_res
                    );
                  }
                  translate([0, 0, seed_countersink_depth])
                    cylinder(
                      h=seed_depth,
                      d1=seed_size,
                      d2=0,
                      $fn=seed_res
                    );
                }
            // Cross shape (X) like stock Jang rollers with code: XY
            } else if( seed_shape == "cross" ) union() {
              // Countersink
              if (seed_countersink_size > 0 && seed_countersink_depth > 0) {
                for (i = [-2 : 2]) {
                  rotate([i * 90, 0, 0])
                    translate([0, seed_size / 4, 0])
                      rotate([0, 270, 0]) cylinder(
                        h=seed_countersink_depth,
                        d1=seed_countersink_size * 2 + seed_size / 2,
                        d2=seed_size / 2,
                        $fn=seed_res
                      );
                }
              }
            
              for(i = [-2 : 2]) {
                translate([-seed_countersink_depth, 0, 0])
                  resize([seed_depth, 0, 0])
                    rotate([i * 90,0,0])
                      translate([0, seed_size / 4, 0])
                        difference() {
                          union() {
                            sphere(d=seed_size / 2, $fn=seed_res);
                            rotate([90, 0, 0]) cylinder(
                              h = seed_size / 4,
                              r = seed_size / 4,
                              $fn=seed_res
                            );
                          }
                          translate([seed_size / 4, 0, 0]) cube(seed_size / 2, center=true);
                        }
              }
            // Half-moon shape like stock Jang rollers with code: J
            } else if( seed_shape == "half-moon" ) {
              if (seed_countersink_size > 0 && seed_countersink_depth > 0) {
                rotate([0,270,0])
                  translate([
                    0,
                    seed_countersink_size / 2 * seed_size / (seed_countersink_size * 2 + seed_size),
                    seed_countersink_depth / 2
                  ])
                    linear_extrude(
                      height=seed_countersink_depth * 1.001,
                      scale=seed_size / (seed_countersink_size * 2 + seed_size),
                      twist=0,
                      center=true,
                      $fn = seed_res,
                      slices = seed_res
                    )
                    
                      translate([0, -seed_countersink_size / 2, 0]) difference() {
                        circle(d=seed_countersink_size * 2 + seed_size, $fn=seed_res);
                        translate([
                          -(seed_countersink_size * 2 + seed_size)/2,
                          -(seed_countersink_size * 2 + seed_size),
                        ])
                          square([seed_countersink_size * 2 + seed_size, seed_countersink_size * 2 + seed_size]);
                      }
              }
              translate([-seed_countersink_depth, 0, 0]) {
                resize([seed_depth, 0, 0])
                  difference(){
                    sphere(d=seed_size, $fn=seed_res);
                    union() {
                      translate([seed_size / 2, 0, 0])
                        cube(seed_size, center=true);
                      translate([-seed_size*0.13,-seed_size/2,0])
                        rotate([0, 0, 60])
                          cube([seed_size, seed_size*2, seed_size],center=true);
                    }
                  }
              }
            // Half-cylinder shape
            } else if(seed_shape == "slot") {
              rotate([0, 270, 0]) {
                translate([
                  0, 
                  seed_size * (teardrop_ratio - 1) / 2,
                  seed_countersink_depth / 2
                ])
                  linear_extrude(
                    height=seed_countersink_depth * 1.001,
                    scale=[
                      (wheel_width - rim_thickness * 2) / (seed_countersink_size * 2 + wheel_width - rim_thickness * 2),
                      seed_size * teardrop_ratio / (seed_countersink_size * 2 + seed_size  * teardrop_ratio)
                    ],
                    twist=0,
                    center=true,
                    $fn = seed_res,
                    slices = seed_res
                  )
                    square([
                      seed_countersink_size * 2 + wheel_width - rim_thickness * 2,
                      seed_countersink_size * 2 + seed_size * teardrop_ratio
                    ], center=true);
              }
              
              translate([-seed_countersink_depth, 0, -wheel_width / 2 + rim_thickness])
                union() {
                  rotate([0, 0, 90])
                    resize([seed_size, seed_depth, (wheel_width - rim_thickness*2)]) {
                      translate([-0.5, 0, 0]) unit_half_teardrop();
                    }
                }
            // Regular sphere shape
            } else if (seed_shape == "finger") {
              translate([-seed_size / 2, 0, 0]) rotate([0, 0, -45]) rotate([0, 90, 0]) finger(
                d1=seed_size,
                d2=seed_size,
                h=seed_size * 2,
                rh=seed_size / 2,
                $fn=seed_res
              );
            } else {
              union() {
                if (seed_countersink_size > 0 && seed_countersink_depth > 0) {
                  rotate([0,270,0]) cylinder(
                    h=seed_countersink_depth * 1.001,
                    d1=seed_countersink_size * 2 + seed_size,
                    d2=seed_size,
                    $fn=seed_res
                  );
                }
                translate([-seed_countersink_depth, 0, 0])
                  resize([seed_depth, 0, 0])
                    difference() {
                      sphere(d=seed_size, $fn=seed_res);
                      translate([seed_size / 2, 0, 0]) cube(seed_size, center=true);
                    }
              }
            }
          }
      }
    }
  }
  // Text (for spoked body)
  union() {
    // Sit on top of spokes _unless_ spokes at upper extreme
    _z = disc_thickness/2+wheel_width/2;
    translate([9.5,text_box_length/2,_z])
    rotate([0,0,270])
      difference() {
        cube([text_box_length,text_box_width,text_box_height]);
        translate([text_box_length/2,text_box_width/2,text_box_height-text_depth+.05])
            linear_extrude(text_depth) text(text, text_size, halign="center", valign="center");
      }
  }
}

seedRoller(
  wheel_dia=wheel_dia,
  wheel_width=wheel_width,
  rim_thickness=rim_thickness,
  rim_slope=rim_slope,
  disc_thickness=disc_thickness,
  bore_dia=bore_dia,
  bore_flat=bore_flat,
  bore_wall=bore_wall,
  bore_rib_depth=bore_rib_depth,
  bore_bezel=bore_bezel,
  spoke_count=spoke_count,
  spoke_thickness=spoke_thickness,
  spoke_height=spoke_height,
  seed_count=seed_count,
  seed_rows=seed_rows,
  seed_size=seed_size,
  seed_depth=seed_depth,
  seed_shape=seed_shape,
  seed_countersink_depth=seed_countersink_depth,
  seed_countersink_size=seed_countersink_size,
  cylinder_res=cylinder_res,
  seed_res=seed_res
);
