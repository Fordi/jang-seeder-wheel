#!/bin/bash
ENTRY="customizer.scad"
PARAMS="customizer.json"
OUTPUT="seed_wheel.scad"
RENDER_DIR="stl"

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

if [[ -x "$OPENSCAD" && "$1" == "render" ]]; then
  mkdir -p "$RENDER_DIR"
  while read type; do
    echo "Rendering $type"
    openscad "$ENTRY" -p "$PARAMS" -P "$type" --render -o "$RENDER_DIR/$type.stl"
  done < <(cat "$PARAMS" | jq -r '.parameterSets | keys[]')
else
  echo "No OpenSCAD installed; skipping render step" >&2
fi