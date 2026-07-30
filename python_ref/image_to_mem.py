import sys
import cv2

IMAGE_FILE = "img.jpg"
OUTPUT_MEM = "image.mem"

img = cv2.imread(IMAGE_FILE, cv2.IMREAD_GRAYSCALE)
if img is None:
    print(f"Error: Could not open {IMAGE_FILE}", file=sys.stderr)
    sys.exit(1)

height, width = img.shape
print(f"Loaded image: {width}x{height}")

with open(OUTPUT_MEM, "w") as f:
    for pixel in img.flatten():
        f.write(f"{pixel:02X}\n")

print(f"Wrote {width * height} pixels to {OUTPUT_MEM}")
