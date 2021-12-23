/**
 * Parametric Jang Seeder Wheel
 * Author: Bryan Elliott <fordiman@gmail.com>
 * Contributors: 
 *  [Bryan Elliott](https://github.com/Fordi)
 *  [fouroakfarm](https://www.thingiverse.com/fouroakfarm/designs)
 * License: [CC-Attribution 4.0](https://creativecommons.org/licenses/by/4.0/)
 * Source code: https://github.com/Fordi/jang-seeder-wheel
**/

include <./utility.scad>

module jangSeederWheel(
  wheel_dia=60,
  wheel_width=20,
  rim_thickness=4,
  rim_slope=5,
  disc_thickness=6,
  bore_dia=15.25,
  bore_flat=2,
  bore_wall=4,
  bore_rib_depth=0.5,
  bore_bezel=0.5,
  spoke_count=9,
  spoke_thickness=1.5,
  spoke_height=13,
  seed_count=12,
  seed_rows=1,
  seed_diameter=3.5,
  seed_depth=1.75,
  seed_shape="v", // Thanks, [fouroakfarm](https://www.thingiverse.com/fouroakfarm/designs)!
  seed_countersink_depth=0.5,
  seed_countersink_size=1,
  cylinder_res=90,
  seed_res=30
) {
  flat_width=sin(acos((bore_dia / 2 - bore_flat) / (bore_dia / 2))) * bore_dia / 2;
  bezel_dia = bore_dia + bore_bezel * 2;
  bezel_flat = bore_flat + bore_bezel;
  flat_bevel_width=sin(acos((bezel_dia / 2 - bezel_flat) / (bezel_dia / 2))) * (bezel_dia / 2);

  difference() {
    union() {
      // Rim
      difference() {
        cylinder(r=wheel_dia/2, h=wheel_width, $fn=cylinder_res);
        translate([0, 0, -(wheel_width - disc_thickness) / 2 * 0.001]) 
        cylinder(
          r1=wheel_dia/2 - rim_thickness,
          r2=wheel_dia/2 - rim_thickness - rim_slope,
          h=(wheel_width - disc_thickness) / 2 * 1.001,
          $fn=cylinder_res
        );
        
        translate([0, 0, wheel_width - (wheel_width - disc_thickness) / 2]) 
          cylinder(
            r1=wheel_dia/2 - rim_thickness - rim_slope,
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
        flattenedCylinder(
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
      translate([0, 0, -bore_bezel * 2 * 0.001]) flattenedCylinder(
        r1  = bore_dia / 2 + bore_bezel, 
        r2  = bore_dia / 2 - bore_bezel, 
        f1  = bore_flat,
        f2  = bore_flat,
        h   = bore_bezel * 2 * 1.001, 
        $fn = cylinder_res
      );
      translate([0, 0, wheel_width - bore_bezel * 2])
        flattenedCylinder(
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
            if(seed_shape == "v") {
              rotate([0,270,0])
                union() {
                  if (seed_countersink_size > 0 && seed_countersink_depth > 0) {
                    cylinder(
                      h=seed_countersink_depth*1.001,
                      d1=seed_countersink_size * 2 + seed_diameter,
                      d2=seed_diameter,
                      $fn=seed_res
                    );
                  }
                  translate([0, 0, seed_countersink_depth])
                    cylinder(
                      h=seed_depth,
                      d1=seed_diameter,
                      d2=0,
                      $fn=seed_res
                    );
                }
            // Cross shape (+) like stock Jang rollers with code: XY
            } else if( seed_shape == "x" ) union() {
              // Countersink
              if (seed_countersink_size > 0 && seed_countersink_depth > 0) {
                for (i = [-2 : 2]) {
                  rotate([i * 90, 0, 0])
                    translate([0, seed_diameter / 4, 0])
                      rotate([0, 270, 0]) cylinder(
                        h=seed_countersink_depth,
                        d1=seed_countersink_size * 2 + seed_diameter / 2,
                        d2=seed_diameter / 2,
                        $fn=seed_res
                      );
                }
              }
            
              for(i = [-2 : 2]) {
                translate([-seed_countersink_depth, 0, 0])
                  resize([seed_depth, 0, 0])
                    rotate([i * 90,0,0])
                      translate([0, seed_diameter / 4, 0])
                        difference() {
                          union() {
                            sphere(d=seed_diameter / 2, $fn=seed_res);
                            rotate([90, 0, 0]) cylinder(
                              h = seed_diameter / 4,
                              r = seed_diameter / 4,
                              $fn=seed_res
                            );
                          }
                          translate([seed_diameter / 4, 0, 0]) cube(seed_diameter / 2, center=true);
                        }
              }
            // Half-moon shape like stock Jang rollers with code: J
            } else if( seed_shape == "hm" ) {
              if (seed_countersink_size > 0 && seed_countersink_depth > 0) {
                rotate([0,270,0])
                  translate([
                    0,
                    seed_countersink_size / 2 * seed_diameter / (seed_countersink_size * 2 + seed_diameter),
                    seed_countersink_depth / 2
                  ])
                    linear_extrude(
                      height=seed_countersink_depth * 1.001,
                      scale=seed_diameter / (seed_countersink_size * 2 + seed_diameter),
                      twist=0,
                      center=true,
                      $fn = seed_res,
                      slices = seed_res
                    )
                    
                      translate([0, -seed_countersink_size / 2, 0]) difference() {
                        circle(d=seed_countersink_size * 2 + seed_diameter, $fn=seed_res);
                        translate([
                          -(seed_countersink_size * 2 + seed_diameter)/2,
                          -(seed_countersink_size * 2 + seed_diameter),
                        ])
                          square([seed_countersink_size * 2 + seed_diameter, seed_countersink_size * 2 + seed_diameter]);
                      }
              }
              translate([-seed_countersink_depth, 0, 0]) {
                resize([seed_depth, 0, 0])
                  difference(){
                    sphere(d=seed_diameter, $fn=seed_res);
                    union() {
                      translate([seed_diameter / 2, 0, 0])
                        cube(seed_diameter, center=true);
                      translate([-seed_diameter*0.13,-seed_diameter/2,0])
                        rotate([0, 0, 60])
                          cube([seed_diameter, seed_diameter*2, seed_diameter],center=true);
                    }
                  }
              }
            // Regular sphere shape
            } else {
              union() {
                if (seed_countersink_size > 0 && seed_countersink_depth > 0) {
                  rotate([0,270,0]) cylinder(
                    h=seed_countersink_depth * 1.001,
                    d1=seed_countersink_size * 2 + seed_diameter,
                    d2=seed_diameter,
                    $fn=seed_res
                  );
                }
                translate([-seed_countersink_depth, 0, 0])
                  resize([seed_depth, 0, 0])
                    difference() {
                      sphere(d=seed_diameter, $fn=seed_res);
                      translate([seed_diameter / 2, 0, 0]) cube(seed_diameter, center=true);
                    }
              }
            }
          }
      }
    }
  }

}