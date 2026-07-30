import os
import cv2
import numpy as np

IMAGE_PATH = "image.png"
if not os.path.exists(IMAGE_PATH):
    IMAGE_PATH = "../image.png"

RTL_OUTPUT = "gradient_output.mem"
if not os.path.exists(RTL_OUTPUT):
    RTL_OUTPUT = "../gradient_output.mem"

WIDTH = 642
HEIGHT = 350

img = cv2.imread(IMAGE_PATH, cv2.IMREAD_GRAYSCALE)
if img is None:
    raise RuntimeError(f"Could not open image file: {IMAGE_PATH}")
assert img.shape == (HEIGHT, WIDTH)

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

rtl_values = []
with open(RTL_OUTPUT) as f:
    for line in f:
        rtl_values.append(int(line.strip()))
rtl_values = np.array(rtl_values, dtype=np.int32)

expected = (WIDTH-2)*(HEIGHT-2)
if len(rtl_values) != expected:
    print(f"Warning: RTL values count ({len(rtl_values)}) does not match expected count ({expected})")

rtl_gradient = np.zeros((HEIGHT, WIDTH), dtype=np.int32)
idx = 0
for y in range(2, HEIGHT):
    for x in range(2, WIDTH):
        if idx < len(rtl_values):
            rtl_gradient[y, x] = rtl_values[idx]
        idx += 1

difference = rtl_gradient != python_gradient
mismatches = np.count_nonzero(difference)

print(f"RTL vs Python Gradient Verification:")
print(f"  Processed pixels : {len(rtl_values)}")
print(f"  Mismatches       : {mismatches}")

if mismatches > 0:
    ys, xs = np.where(difference)
    print("First mismatches:")
    for i in range(min(10, len(xs))):
        x, y = xs[i], ys[i]
        print(f"  ({x},{y}) RTL={rtl_gradient[y,x]} PY={python_gradient[y,x]}")

os.makedirs("docs/images", exist_ok=True)
rtl_img = np.clip(rtl_gradient, 0, 255).astype(np.uint8)
py_img  = np.clip(python_gradient, 0, 255).astype(np.uint8)
diff    = np.clip(np.abs(rtl_gradient - python_gradient), 0, 255).astype(np.uint8)

cv2.imwrite("docs/images/rtl_gradient.png", rtl_img)
cv2.imwrite("docs/images/python_gradient.png", py_img)
cv2.imwrite("docs/images/gradient_difference.png", diff)
