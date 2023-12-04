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
def is_part(row, y1, y2, data):
    y1 = max(0, y1-1)
    y2 = min(len(data[0])-1, y2+1)
    x1 = max(0, row-1)
    x2 = min(len(data)-1, row+1)

    is_part = False
    for x in range(x1, x2+1):
        for y in range(y1, y2+1):
            if data[x][y].isdigit() or data[x][y] == ".":
                continue
            else:
                is_part = True
                break
        
        if is_part:
            break
    
    return is_part

def parse_for_nums(line):
    nums = []
    idxs = []
    num = []
    for i, c in enumerate(line):
        if not c.isdigit():
            if num:
                nums.append(num)
                idxs.append(idx)
                num = None
            continue
        else:
            if not num:
                num = c
                idx = i
            else:
                num +=c
            
            if i == len(line) - 1:
                nums.append(num)
                idxs.append(idx)
            
    return nums, idxs
        

with open(path) as f:
    data = f.read().splitlines()

parts = []
part_sum = 0
for i_row, line in enumerate(data):

    line = line.strip()
    line_list = list(line)
    these_nums, idxs = parse_for_nums(line)

    for n, idx_n in zip(these_nums, idxs):
    
        if is_part(i_row, idx_n, idx_n + len(n) - 1 , data):
            parts.append(int(n))
            part_sum += int(n)
            


print(part_sum)

            
# OUTPUT
# end = time.perf_counter()
# print(f"Solution = {sol}")
# print(f"Time = {(end-start)*1000:.3f} ms")
