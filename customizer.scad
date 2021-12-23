/**
 * Parametric Jang Seeder Wheel
 * Author: Bryan Elliott <fordiman@gmail.com>
 * Contributors: 
 *  [Bryan Elliott](https://github.com/Fordi)
 *  [fouroakfarm](https://www.thingiverse.com/fouroakfarm/designs)
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
bore_dia=15.25;
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
seed_shape = "sphere"; // [sphere:sphere, cone:cone, half-moon:half-moon, cross:cross, slot:slot]

// Countersink around seed in mm
seed_countersink_size=0.01;

// Depth of countersink around seed in mm
seed_countersink_depth=0.01;

// Resolution of cylinders
cylinder_res=180;

// Resolution of seeds
seed_res=30;


include<./jang_seeder_wheel.scad>

jangSeederWheel(
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

