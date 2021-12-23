/**
 * Parametric Jang Seeder Wheel
 * Author: Bryan Elliott <fordiman@gmail.com>
 * Contributors: 
 *  [Bryan Elliott](https://github.com/Fordi)
 *  [fouroakfarm](https://www.thingiverse.com/fouroakfarm/designs)
 * License: [CC-Attribution 4.0](https://creativecommons.org/licenses/by/4.0/)
 * Source code: https://github.com/Fordi/jang-seeder-wheel
**/

function chord(r, f) = sin(acos((r - f) / r)) * r;

module flattenedCylinder(r1, r2, h, f1, f2, $fn) {
  difference() {
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