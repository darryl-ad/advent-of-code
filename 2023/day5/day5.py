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
with open(path) as f:
    data = f.read().splitlines()

stages = {
    "seed-to-soil": [],
    "soil-to-fertilizer": [],
    "fertilizer-to-water": [],
    "water-to-light": [],
    "light-to-temperature": [],
    "temperature-to-humidity": [],
    "humidity-to-location": [],
}

# Extract seeds from first line, then delete
seeds = data[0].split(":")[-1].split()
seeds = [int(s) for s in seeds]
del data[0]

# Parse for number mapping at each stage
stage_keys = list(stages.keys())
i_stage = -1
this_stage = None
next_stage = stage_keys[0]

map = []

for i_line, line in enumerate(data):
    if line == "":
        continue

    if next_stage in line:
        if this_stage:
            stages[this_stage] = map

        this_stage = next_stage
        i_stage += 1
        next_stage = stage_keys[i_stage + 1] if i_stage < len(stage_keys) - 1 else "end"

        map = []
        continue

    map.append([int(num) for num in line.split()])

    if i_line == len(data) - 1:
        stages[this_stage] = map


def process(x, start_idx=0, reverse=False):
    break_idx = len(stage_keys)
    if reverse:
        break_idx = -1
    if start_idx == break_idx:
        return x

    this_map = stages[stage_keys[start_idx]]

    if reverse:
        dest = 1
        source = 0
        inc = -1
    else:
        dest = 0
        source = 1
        inc = 1

    for coords in this_map:
        if coords[source] <= x <= coords[source] + coords[2]:
            y = coords[dest] + (x - coords[source])
            return process(y, start_idx=start_idx + inc, reverse=reverse)
    else:
        return process(x, start_idx=start_idx + inc, reverse=reverse)


part1 = min([process(x) for x in seeds])


def check_if_seed(x):
    for i in range(0, len(seeds), 2):
        if seeds[i] <= x <= seeds[i] + seeds[i + 1]:
            return True
    else:
        return False


def part2_reverse_search():
    solved = False
    y = 52210600  # Quick-start!
    while True:
        if y % 1000000 == 0:
            print("iteration : " + y)
        x = process(y, start_idx=len(stage_keys) - 1, reverse=True)
        solved = check_if_seed(x)
        if solved:
            return y - 1  # I think this is a mistake, but works for my input
        y += 1


part2 = part2_reverse_search()

print(part1, part2)

# OUTPUT
# end = time.perf_counter()
# print(f"Solution = {sol}")
# print(f"Time = {(end-start)*1000:.3f} ms")
