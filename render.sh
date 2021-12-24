#!/bin/bash
ENTRY="$(dirname "$0")/seed_roller.scad"
PRESETS="$(dirname "$0")/seed_roller.json"
RENDER_DIR="$(dirname "$0")/stl"

OPENSCAD="$(which openscad)"

function render() {
  echo "Rendering $1"
  echo openscad "$ENTRY" -p "$PRESETS" -P "$1" --render -o "$2/$1.stl"
}

function list_presets() {
  jq -r '.parameterSets | keys[]' "$PRESETS"
}

if [[ -x "$OPENSCAD" ]]; then
  if [[ "$1" == "all" ]]; then
    mkdir -p "$RENDER_DIR"
    while read type; do
      if [[ ! -f "$RENDER_DIR/$type.stl" ]]; then
        render "$type" "$RENDER_DIR"
      fi
    done < <(list_presets)
  elif [[ "$1" == "list" ]]; then
    list_presets
  else
    while [[ "$1" != "" ]]; do
      render "$1" "."
      shift
    done
  fi
else
  echo "No OpenSCAD installed; skipping render step" >&2
fi