import cv2
import numpy as np

# Configuration
IMAGE_PATH = "../image.png"
RTL_OUTPUT = "../gradient_output.mem"
WIDTH = 642
HEIGHT = 350

# Read image
img = cv2.imread(IMAGE_PATH, cv2.IMREAD_GRAYSCALE)
if img is None:
    raise RuntimeError("Could not open image.")
assert img.shape == (HEIGHT, WIDTH)

# Compute Python Gradient
python_gradient = np.zeros((HEIGHT, WIDTH), dtype=np.int32)
for y in range(2, HEIGHT):
    for x in range(2, WIDTH):
        p00 = int(img[y-2, x-2])
        p01 = int(img[y-2, x-1])
        p02 = int(img[y-2, x])
        p10 = int(img[y-1, x-2])
        p11 = int(img[y-1, x-1])
        p12 = int(img[y-1, x])
        p20 = int(img[y, x-2])
        p21 = int(img[y, x-1])
        p22 = int(img[y, x])
        gx = (
            -p00 + p02
            - (p10 << 1) + (p12 << 1)
            - p20 + p22
        )
        gy = (
             p00 + (p01 << 1) + p02
            - p20 - (p21 << 1) - p22
        )
        python_gradient[y, x] = abs(gx) + abs(gy)

# Read RTL Gradient
rtl_values = []
with open(RTL_OUTPUT) as f:
    for line in f:
        rtl_values.append(int(line.strip()))
rtl_values = np.array(rtl_values, dtype=np.int32)
print("RTL Gradient Values :", len(rtl_values))
expected = (WIDTH-2)*(HEIGHT-2)
print("Expected            :", expected)
if len(rtl_values) != expected:
    print("WARNING: Pixel count mismatch")

# Reconstruct RTL Gradient Image
rtl_gradient = np.zeros((HEIGHT, WIDTH), dtype=np.int32)
idx = 0
for y in range(2, HEIGHT):
    for x in range(2, WIDTH):
        if idx < len(rtl_values):
            rtl_gradient[y, x] = rtl_values[idx]
        idx += 1

# Compare
difference = rtl_gradient != python_gradient
mismatches = np.count_nonzero(difference)
print("\n=================================")
print("Gradient Mismatches :", mismatches)
print("=================================\n")
ys, xs = np.where(difference)
print("First 20 mismatches:\n")
for i in range(min(20, len(xs))):
    x = xs[i]
    y = ys[i]
    print(
        f"({x:3d},{y:3d}) "
        f"RTL={rtl_gradient[y,x]:4d} "
        f"PY={python_gradient[y,x]:4d}"
    )

# Difference Statistics
error = np.abs(rtl_gradient - python_gradient)
print("\nMaximum Error :", np.max(error))
print("Average Error :", np.mean(error))

# Save Images
rtl_img = np.clip(rtl_gradient,0,255).astype(np.uint8)
py_img  = np.clip(python_gradient,0,255).astype(np.uint8)
diff    = np.clip(error,0,255).astype(np.uint8)
cv2.imwrite("rtl_gradient.png", rtl_img)
cv2.imwrite("python_gradient.png", py_img)
cv2.imwrite("gradient_difference.png", diff)
print("\nGenerated:")
print(" rtl_gradient.png")
print(" python_gradient.png")
print(" gradient_difference.png")
