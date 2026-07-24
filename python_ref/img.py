import cv2
img = cv2.imread("img.jpg", 0)
flat = img.flatten()
print(flat[:20])
with open("image.mem", "w") as f:
    for pixel in flat:
        f.write(f"{pixel:02X}\n")
print(img.dtype)
print(img.min())
print(img.max())
