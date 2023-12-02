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
# NOTE: Avoided numpy, but used regex
import re


def list_product(my_list):
    product = 1
    for i in my_list:
        product *= i
    return product


def check_possible(count, allowed):
    delta = [a - c for a, c in zip(allowed, count)]

    if all(d >= 0 for d in delta):
        return True


def solution(data, colours, allowed):
    data = data.replace(" ", "").splitlines()
    ID_sum = 0
    power_sum = 0

    for idx, line in enumerate(data):
        count = [0] * len(colours)

        game = line.split(":")[-1]
        cubes = re.split(";|,", game)

        for i, col in enumerate(colours):
            most_col = max([int(i.replace(col, "")) for i in cubes if col in i])
            count[i] = most_col if most_col > count[i] else count[i]

        power_sum += list_product(count)

        if check_possible(count, allowed):
            ID_sum += idx + 1

    return ID_sum, power_sum


with open(path) as f:
    data = f.read()

colours = ["red", "green", "blue"]
allowed = [12, 13, 14]

sol = solution(data, colours, allowed)

# OUTPUT
end = time.perf_counter()
print(f"Solution = {sol}")
print(f"Time = {(end-start)*1000:.3f} ms")
