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
import string

with open(path) as f:
    data = f.read().splitlines()


def get_priority(item):
    if item.isupper():
        return string.ascii_lowercase.index(item.lower()) + 27
    else:
        return string.ascii_lowercase.index(item) + 1


sum = 0
sum2 = 0
group = []
for idx, s in enumerate(data):
    first_half = s[: len(s) // 2]
    second_half = s[len(s) // 2 :]
    item = list(set(first_half).intersection(second_half))[0]
    priority = get_priority(item)
    sum += priority

    group.append(s)
    if (idx + 1) % 3 == 0:
        item2 = list(set(group[0]).intersection(group[1]).intersection(group[2]))[0]
        priority2 = get_priority(item2)
        sum2 += priority2
        group.clear()

print(sum)
print(sum2)
# OUTPUT
end = time.perf_counter()
# print(f"Solution = {sol}")
print(f"Time = {(end-start)*1000:.3f} ms")
