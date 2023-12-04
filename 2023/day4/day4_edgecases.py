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
    
def get_score(line):
    nums = line.split(":")[1].split("|")
    win_nums = nums[0].split()
    our_nums = nums[1].split()

    common = list(set(win_nums).intersection(our_nums))

    winning_count = len(common)
    score = 0
    if winning_count > 0:
        score = 1 + (2 ** (winning_count - 1) - 1)
    
    return (score, winning_count)


# Part 1
n = len(data)
sum1 = 0
scores = [0] * n
winning_count = [0] * n
for idx_l, line in enumerate(data):
    
    scores[idx_l], winning_count[idx_l] = get_score(line)

sum1 = sum(scores)
    
# Part 2
card_count = [1] * n
for idx_c in range(n):
    n_c = card_count[idx_c]
    n_w = winning_count[idx_c]
    
    if n_w == 0:
        continue
    
    n_assign = [1] * n_w # Assign 1 card to next n_w rows
    n_assign.insert(0, 0) # Need to cover case if final card is a win. where do they get assigned? With this logic they get assigned to the final row, which would cause infinite recursion
    # Check if there are enough rows remaining, if not, backfill
    # Is this right, or do OOB cards just not count?
    while len(n_assign) > n - idx_c:
        n_assign[-2] += n_assign[-1]
        n_assign[-1].pop()
         
    for idx_w, n_ass in enumerate(n_assign):
        card_count[idx_c + idx_w] += n_c * n_ass
    
sum2 = sum(card_count)

print(sum1)
print(sum2)


# OUTPUT
# end = time.perf_counter()
# print(f"Solution = {sol}")
# print(f"Time = {(end-start)*1000:.3f} ms")
