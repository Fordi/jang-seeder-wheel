#!/bin/bash
ENTRY="customizer.scad"
OUTPUT="seed_wheel.scad"
RENDER="seed_wheel.stl"

if ! which node > /dev/null 2>&1 || ! which npm > /dev/null 2>&1; then
  echo "No node available; please install it" >&2
  exit -1
fi

if [[ ! -d build/node_modules ]]; then
  cd build
  npm ci
  cd ..
fi

echo "Transcluding $ENTRY to $OUTPUT"
node build customizer.scad seed_wheel.scad

OPENSCAD="$(which openscad)"
if [[ "$OPENSCAD" == "" && -x /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD ]]; then
  OPENSCAD="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
fi
if [[ -x "$OPENSCAD" ]]; then
  echo "Rendering sample to $RENDER"
  "$OPENSCAD" seed_wheel.scad --render -o "$RENDER"
else
  echo "No OpenSCAD installed; skipping render step" >&2
fi