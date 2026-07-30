#!/bin/bash
set -eo pipefail

if [ -z "$PDK_ROOT" ]; then
  export PDK_ROOT=$(find ~/.ciel/ciel/sky130/versions -maxdepth 1 -mindepth 1 -type d 2>/dev/null | sort | tail -n1)/sky130A
fi
if [ -z "$PDK_ROOT" ] || [ ! -d "$PDK_ROOT" ]; then
  export PDK_ROOT=$(find ~/.volare/volare/sky130/versions -maxdepth 1 -mindepth 1 -type d 2>/dev/null | sort | tail -n1)/sky130A
fi

if [ -z "$PDK_ROOT" ] || [ ! -d "$PDK_ROOT" ]; then
  echo "Error: PDK_ROOT is not set and could not be detected."
  exit 1
fi

echo "Running physical design flow with PDK_ROOT: $PDK_ROOT"

mkdir -p logs results reports

openroad -exit scripts/01_floorplan.tcl | tee logs/01_floorplan.log
openroad -exit scripts/02_place.tcl | tee logs/02_place.log
openroad -exit scripts/03_cts.tcl | tee logs/03_cts.log
openroad -exit scripts/04_route.tcl | tee logs/04_route.log
openroad -exit scripts/05_sta.tcl | tee logs/05_sta.log
openroad -exit scripts/06_gds.tcl | tee logs/06_gds.log

echo "Physical design flow complete."
