#!/bin/bash
ENTRY="$(dirname "$0")/seed_roller.scad"
PRESETS="$(dirname "$0")/seed_roller.json"
RENDER_DIR="$(dirname "$0")/stl"
MAX_THREADS=4

OPENSCAD="$(which openscad)"

function list_presets() {
  jq -r '.parameterSets | keys[]' "$PRESETS"
}

if [[ -x "$OPENSCAD" ]]; then
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
        openscad "$ENTRY" -p "$PRESETS" -P "$type" --render -o "$RENDER_DIR/$type.stl" &
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
      openscad "$ENTRY" -p "$PRESETS" -P "$1" --render -o "./$1.stl"
      shift
    done
  fi
else
  echo "No OpenSCAD installed; skipping render step" >&2
fi