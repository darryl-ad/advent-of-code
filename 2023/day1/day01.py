import os
import time
path = os.path.dirname(__file__) + "\input.txt"

start = time.perf_counter()

def get_ordered_map():   
    num_map = {
        "one": 1,
        "two": 2,
        "three": 3,
        "four": 4,
        "five":5,
        "six":6,
        "seven":7,
        "eight":8,
        "nine":9,
    }
    order = sorted(num_map.keys(), key=len)
    ordered_map = {k: num_map[k] for k in order}
    return ordered_map

def first_digit(line, map):
    for i in range(len(line)):
        if line[i].isdigit():
            return line[i]
        
        for k in map.keys():
            if line[i:].startswith(k):
                return str(map[k])
            
def last_digit(line, map):
    for i in reversed(range(len(line))):
        if line[i].isdigit():
            return line[i]
        
        for k in map.keys():
            if line[:i+1].endswith(k):
                return str(map[k])        

def solution(path):
    with open(path) as f:
        data = f.read()
        
    map = get_ordered_map()
    data_split = data.splitlines()
    sum1 = 0
    sum2 = 0
    for i in range(len(data_split)):
        line = data_split[i]
        digits1 = [s for s in list(line) if s.isdigit()]
        digits2 = [first_digit(line,map), last_digit(line,map)]
        
        sum1 += int(digits1[0] + digits1[-1])
        sum2 += int(digits2[0] + digits2[-1])

    return [sum1, sum2]
    
end = time.perf_counter()
print(f"Solution = {solution(path)}")
print(f"Time = {(end-start)*1000:.4f} ms")

    
