/**
 * Parametric Jang Seeder Wheel
 * Author: Bryan Elliott <fordiman@gmail.com>
 * Contributors: 
 *  [Bryan Elliott](https://github.com/Fordi)
 *  [fouroakfarm](https://www.thingiverse.com/fouroakfarm/designs)
 * License: [CC-Attribution 4.0](https://creativecommons.org/licenses/by/4.0/)
 * Source code: https://github.com/Fordi/jang-seeder-wheel
**/

include<./jang_seeder_wheel.scad>
include<./jang_seeder_wheel.scad>

// Wheel diameter
wheel_dia=60;
// Wheel width
wheel_width=20;

// Thickness of rim
rim_thickness=4;
// Thickness of slope to disc
rim_slope=5;
// Thickness of disc
disc_thickness=6;

// Diameter of circular part of bore
bore_dia=15.25;
// Distance from edge to flatten bore
bore_flat=2;
// Thickness of bore wall (hub)
bore_wall=4;
// Thickness of ribs (for added support)
bore_rib_depth=0.5;
// Width of bore bezel
bore_bezel=0.5;

// Number of support spokes
spoke_count=9;
// Thickness of spokes
spoke_thickness=1.5;
// Height of spokes through wheel
spoke_height=13;

// Numberof total seed cells
seed_count=12;
// Rows of seed cells
seed_rows=1;
// Diameter of each seed cell
seed_dia=3.5;

// Shape of seed imprint
seed_shape="v"; // [s:sphere, v:cone]

// Resolution of cylinders
cylinder_res=90;

// Resolution of seeds
seed_res=30;

jangSeederWheel(
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
  seed_shape="v",
  cylinder_res=90,
  seed_res=30
);

