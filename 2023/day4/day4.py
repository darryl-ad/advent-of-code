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
def get_score(line):
    nums = line.split(":")[1].split("|")
    win_nums = nums[0].split()
    our_nums = nums[1].split()

    common = list(set(win_nums).intersection(our_nums))

    winning_count = len(common)
    score = 0
    if winning_count > 0:
        score = 2 ** (winning_count - 1) - 1

    return (score, winning_count)


def solution(data):
    # Part 1
    sum1 = 0
    card_count = [1] * len(data)

    for idx, line in enumerate(data):
        score, n_w = get_score(line)

        sum1 += score
        n_c = card_count[idx]

        if n_w == 0:
            continue

        for idx_w in range(n_w):
            card_count[idx + idx_w + 1] += n_c

    sum2 = sum(card_count)

    return sum1, sum2


with open(path) as f:
    data = f.read().splitlines()

sol = solution(data)

# OUTPUT
end = time.perf_counter()
print(f"Solution = {sol}")
print(f"Time = {(end-start)*1000:.3f} ms")
