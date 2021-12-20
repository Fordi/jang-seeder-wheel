#!/bin/bash
if [[ ! -d build/node_modules ]]; then
  cd build
  npm ci
  cd ..
fi
node build customizer.scad seed_wheel.scad
