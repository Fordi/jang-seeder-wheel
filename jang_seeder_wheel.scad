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
  seed_dia=3.5,
  seed_shape="v", // Thanks, [fouroakfarm](https://www.thingiverse.com/fouroakfarm/designs)!
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
        
        cylinder(
          r1=wheel_dia/2 - rim_thickness,
          r2=wheel_dia/2 - rim_thickness - rim_slope,
          h=(wheel_width - disc_thickness) / 2,
          $fn=cylinder_res
        );
        
        translate([0, 0, wheel_width - (wheel_width - disc_thickness) / 2]) 
          cylinder(
            r1=wheel_dia/2 - rim_thickness - rim_slope,
            r2=wheel_dia/2 - rim_thickness,
            h=(wheel_width - disc_thickness) / 2,
            $fn=cylinder_res
          );
      }

      // Hub
      difference() {
        cylinder(r=bore_dia/2 + bore_wall, h=wheel_width, $fn=cylinder_res);
        translate([(bore_dia / 2 - bore_flat) + bore_wall, -(bore_dia/2 + bore_wall), 0])
          cube([bore_flat, bore_dia + bore_wall*2, wheel_width]);
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
        for (theta = [0 : 60 : 300]) {
          rotate([0, 0, theta])
            translate([0, bore_dia/2, 0])
              cylinder(r=bore_rib_depth, h=20, $fn=cylinder_res);
        }
      }
      flattenedCylinder(
        r1  = bore_dia / 2 + bore_bezel, 
        r2  = bore_dia / 2 - bore_bezel, 
        f1  = bore_flat,
        f2  = bore_flat,
        h   = bore_bezel * 2, 
        $fn = cylinder_res
      );
      translate([0, 0, wheel_width - bore_bezel * 2])
        flattenedCylinder(
          r1  = bore_dia / 2 - bore_bezel, 
          r2  = bore_dia / 2 + bore_bezel, 
          f1  = bore_flat,
          f2  = bore_flat,
          h   = bore_bezel * 2, 
          $fn = cylinder_res
        );
    }
    // Seeds
    for(theta = [0 : (360 / (seed_count / seed_rows)) : 360 - (360 / (seed_count / seed_rows))]) {
      for(row = [0 : 1 : seed_rows - 1]) {
        rotate([0, 0, theta + (360 / seed_count * row)])
          translate([wheel_dia / 2, 0, wheel_width * (row + 0.5) / (seed_rows)])
            if(seed_shape == "v") {
              rotate([0,270,0])
              cylinder(h=seed_dia/2,d1=seed_dia,d2=0,$fn=seed_res);
            } else {
              sphere(d=seed_dia, $fn=seed_res);
            }
      }
    }
  }

}