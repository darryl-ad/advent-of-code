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
import math

with open(path) as f:
    data = f.read().splitlines()


def calc_win_times(T, S):
    # t^2 - Tt + S = 0
    t1 = (T + (T**2 - 4 * S) ** 0.5) / 2
    t2 = (T - (T**2 - 4 * S) ** 0.5) / 2
    start = min([t1, t2])
    end = max([t1, t2])

    # Check if exact solution, to win the distanc must be greater
    start = int(start + 1 if start % 1 == 0 else math.ceil(start))
    end = int(end - 1 if end % 1 == 0 else math.floor(end))
    t_list = list(range(start, end + 1))

    return t_list, len(t_list)


def solution(data):
    times = [int(x) for x in data[0].split(":")[-1].strip().split()]
    distances = [int(x) for x in data[1].split(":")[-1].strip().split()]

    part1 = 1
    for T, S in zip(times, distances):
        _, count = calc_win_times(T, S)

        part1 *= count

    times2 = int(data[0].split(":")[-1].strip().replace(" ", ""))
    distances2 = int(data[1].split(":")[-1].strip().replace(" ", ""))
    _, part2 = calc_win_times(times2, distances2)

    return part1, part2


sol = solution(data)

# OUTPUT
end = time.perf_counter()
print(f"Solution = {sol}")
print(f"Time = {(end-start)*1000:.3f} ms")
