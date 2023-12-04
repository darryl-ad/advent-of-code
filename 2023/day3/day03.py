# BOILERPLATE
import os
import time

example = False
if example:
    path = os.path.dirname(__file__) + "\example.txt"
else:
    path = os.path.dirname(__file__) + "\input.txt"
start = time.perf_counter()


# IMPLEMENTATION
import re

with open(path) as f:
    data = f.read()

nums = []
syms_y = []
for row, line in enumerate(data.splitlines()):
    these_nums = re.findall(r"\d+", line)
    these_syms = re.findall(r"[^.\d]", line)

    for n in these_nums:
        idx_n = line.index(n)

        nums.append({"val": int(n), "x": row, "y1": idx_n, "y2": idx_n + len(n) - 1})

    this_y = [idx_s for idx_s, s in enumerate(line) if s in these_syms]
  
    syms_y.append(this_y)

sum = 0
for n in range(len(nums)):
    num = nums[n]["val"]
    row = nums[n]["x"]
    y1 = nums[n]["y1"]
    y2 = nums[n]["y2"]

    search_rows = range(max(0, row - 1), min(row + 1, len(syms_y)-1) + 1)
    for r in search_rows:
        if syms_y[r] is not None and any(
            [(y1 - 1) <= y <= (y2 + 1) for y in syms_y[r]]
        ):
            sum += num
            break

print(sum)

# OUTPUT
# end = time.perf_counter()
# print(f"Solution = {sol}")
# print(f"Time = {(end-start)*1000:.3f} ms")
