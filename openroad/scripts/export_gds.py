import os
import pya

pdk = os.environ.get("PDK_ROOT", os.path.expanduser("~/.ciel/ciel/sky130/versions/8afc8346a57fe1ab7934ba5a6056ea8b43078e71/sky130A"))
tech_lef = os.path.join(pdk, "libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef")
cell_lef = os.path.join(pdk, "libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef")
cell_gds = os.path.join(pdk, "libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds")

def_file = os.path.abspath("results/top_sky130.def")
if not os.path.exists(def_file):
    def_file = os.path.abspath("openroad/results/top_sky130.def")

out_gds = os.path.abspath("results/top_sky130.gds")
if not os.path.exists(os.path.dirname(out_gds)):
    out_gds = os.path.abspath("openroad/results/top_sky130.gds")

print(f"[INFO] Merging DEF ({def_file}) with Sky130 HD cell library GDS...")

opt = pya.LoadLayoutOptions()
opt.lefdef_config.lef_files = [tech_lef, cell_lef]
opt.lefdef_config.macro_layout_files = [cell_gds]
opt.lefdef_config.read_lef_with_def = True

layout = pya.Layout()
layout.read(def_file, opt)

print(f"[INFO] Writing final signoff GDSII file: {out_gds}")
layout.write(out_gds)
print(f"[INFO] GDSII Streamout Complete! File size: {round(os.path.getsize(out_gds)/(1024*1024), 2)} MB")
