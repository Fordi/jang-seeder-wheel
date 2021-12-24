# Parametric Seed Roller

This is a parametric seed roller with default parameters and presets for Jang JP or JPH series rollers.

<img src="https://github.com/Fordi/jang-seeder-wheel/raw/main/Jang_F-12_PLA_Orange.jpg" width="320" alt="Jang F-12 sample print" />

You can adjust things like the diameter and borehole to adjust for your printer's tolerances. You can also adjust the number of seed cells and their size.

I started from an existing Jang wheel, took measurements, and implemented a fully parameterized version out of shape primitives.  Then [fernplant](https://github.com/fernplant) was nice enough to add other shapes.

The renders of every roller preset are available [on Thingiverse](https://www.thingiverse.com/thing:4462838).

# Usage

Running this command will open up OpenSCAD.  If you open up the Customizer, you'll see a bunch of presets for known Jang seed rollers.

```
openscad seed_roller.scad
```

If you just want to generate a known STL:

```
openscad -p seed_roller.json -P "Jang M-12" seed_roller.scad --render -o seed_roller_jang_m-12.stl
```

To render all the presets in `customizer.json` into `./stl/`.

```
./build.sh
```

> Note: there are 52 Jang wheels, and they each take 2-3 minutes to render.  You're looking at about 2 hours of rendering.

