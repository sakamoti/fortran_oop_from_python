from custom import CustomCircle

circles = [CustomCircle(x) for x in range(1, 4)]

for circle in circles:
    circle.showinfo()

print("\n# ---- get area as PyObject ---")
for circle in circles:
    area = circle.calculatearea()
    print(type(area), area)
