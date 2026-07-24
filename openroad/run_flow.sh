#!/bin/bash
set -e

echo "============================================"
echo " image_pipeline: OpenROAD Physical Design"
echo " Technology: Sky130 HD"
echo "============================================"

mkdir -p logs results reports

echo "[FLOW] ===== Stage 1/6: FLOORPLAN ====="
openroad -exit scripts/01_floorplan.tcl | tee logs/01_floorplan.log

echo "[FLOW] ===== Stage 2/6: PLACEMENT ====="
openroad -exit scripts/02_place.tcl | tee logs/02_place.log

echo "[FLOW] ===== Stage 3/6: CTS ====="
openroad -exit scripts/03_cts.tcl | tee logs/03_cts.log

echo "[FLOW] ===== Stage 4/6: ROUTING ====="
openroad -exit scripts/04_route.tcl | tee logs/04_route.log

echo "[FLOW] ===== Stage 5/6: STA SIGNOFF ====="
openroad -exit scripts/05_sta.tcl | tee logs/05_sta.log

echo "[FLOW] ===== Stage 6/6: GDSII STREAMOUT ====="
openroad -exit scripts/06_gds.tcl | tee logs/06_gds.log


echo "============================================"
echo " PHYSICAL DESIGN FLOW COMPLETE"
echo "============================================"

