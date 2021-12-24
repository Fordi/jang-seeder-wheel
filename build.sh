#!/bin/bash
ENTRY="seed_roller.scad"
PRESETS="seed_roller.json"
RENDER_DIR="stl"

OPENSCAD="$(which openscad)"

if [[ -x "$OPENSCAD" ]]; then
  mkdir -p "$RENDER_DIR"
  while read type; do
    if [[ ! -f "$RENDER_DIR/$type.stl" ]]; then
      echo "Rendering $type"
      openscad "$ENTRY" -p "$PRESETS" -P "$type" --render -o "$RENDER_DIR/$type.stl"
    fi
  done < <(jq -r '.parameterSets | keys[]' "$PRESETS")
else
  echo "No OpenSCAD installed; skipping render step" >&2
fi