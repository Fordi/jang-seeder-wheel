#!/bin/bash
ENTRY="$(dirname "$0")/seed_roller.scad"
PRESETS="$(dirname "$0")/seed_roller.json"
RENDER_DIR="$(dirname "$0")/stl"
MAX_THREADS=4

OPENSCAD="$(which openscad)"
# Need to update the scad to support ImplicitCAD,
# which is a _much_ faster renderer.
#
# http://www.implicitcad.org/
#
# Unfortunately, ImplicitCAD doesn't yet support `polyhedron`, which is necessary
# for rendering the hole, so we can't use it yet.  However, I did solve the 
# presets problem. 
# IMPLICITCAD="$HOME/.cabal/bin/extopenscad"

JQ="$(which jq)"
function fJQ() {
  if [[ -x "$JQ" ]]; then 
    "$JQ" "${@}"
  else
    echo "Cannot parse JSON without JQ.  https://stedolan.github.io/jq/" >&2
    exit -1
  fi
}

function render() {
  local type=$1; shift;
  local out_dir=$1; shift;
  if [[ -x "$IMPLICITCAD" ]]; then # 
    # ImplicitCAD doesn't support presets; transform the preset to variable declarations
    local preset=(
      $(fJQ -r '.parameterSets["'"$type"'"] | to_entries | .[] | "-D" + .key + "=" + (.value | @json)' "$PRESETS")
    )
    set -x
    "$IMPLICITCAD" -o "$out_dir/$type.stl" ${preset[@]} "$ENTRY"
    set +x
  elif [[ -x "$OPENSCAD" ]]; then
    "$OPENSCAD" "$ENTRY" -p "$PRESETS" -P "$type" --render --export-format binstl -o "$out_dir/$type.stl"
  else
    echo "No OpenSCAD installed.  https://openscad.org/" >&2
    # echo "No ImplicitCAD installed. http://www.implicitcad.org/" >&2
    exit -1
  fi
}

function list_presets() {
  fJQ -r '.parameterSets | keys[]' "$PRESETS"
}


if [[ "$1" == "all" ]]; then
  mkdir -p "$RENDER_DIR"
  OPEN_PIDS=()
  OPEN_RENDERS=()
  while read type; do
    if [[ ! -f "$RENDER_DIR/$type.stl" ]]; then
      while [[ "${#OPEN_PIDS[@]}" -ge "$MAX_THREADS" ]]; do
        sleep 5
        TMP=()
        TMP2=()
        i=0
        len="${#OPEN_PIDS[@]}"
        while [[ $i -lt $len ]]; do
          if ps -p "${OPEN_PIDS[$i]}" > /dev/null; then
            TMP=("${TMP[@]}" "${OPEN_PIDS[$i]}")
            TMP2=("${TMP2[@]}" "${OPEN_RENDERS[$i]}")
          else
            echo "${OPEN_RENDERS[$i]} has finished."
          fi
          let i++
        done
        OPEN_PIDS=("${TMP[@]}")
        OPEN_RENDERS=("${TMP2[@]}")
      done
      echo "Rendering $type"
      render "$type" "$RENDER_DIR" &
      PID=$!
      OPEN_PIDS=("${OPEN_PIDS[@]}" "$PID")
      OPEN_RENDERS=("${OPEN_RENDERS[@]}" "$type")
    fi
  done < <(list_presets)
  wait
elif [[ "$1" == "list" ]]; then
  list_presets
else
  while [[ "$1" != "" ]]; do
    echo "Rendering $1"
    render "$1" "./stl"
    shift
  done
fi
