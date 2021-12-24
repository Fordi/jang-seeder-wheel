# Jang Seeder Wheel

This is a parametric seed roller, with default parameters for a Jang seeder. You can adjust things like the diameter and borehole to adjust for your printer's tolerances. You can also adjust the number of seed cells and their size.

I started from an existing Jang wheel, took measurements, and implemented a fully parameterized version out of shape primitives.

The transcluded version (`seed_wheel.scad`) and a render of every roller preset is available [on Thingiverse](https://www.thingiverse.com/thing:4462838).

# Usage

Running this command will open up OpenSCAD.  If you open up the Customizer, you'll see a bunch of presets for known Jang seed rollers.

```
openscad customizer.scad
```

If you just want to generate a known STL:

```
openscad -p customizer.json -P "Jang M-12" customizer.scad --render -o seed_wheel_m-12.stl
```

If you want to build the transcluded script from sources:

```bash
./build.sh
```

To render all the presets in `customizer.json` into `./stl/`.

```
./build.sh render
```

> Note: there are 52 Jang wheels, and they each take 2-3 minutes to render.  You're looking at about 2 hours of rendering.

