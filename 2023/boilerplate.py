# BOILERPLATE
import os
import time

example = True
if example:
    path = os.path.dirname(__file__) + "\example.txt"
else:
    path = os.path.dirname(__file__) + "\input.txt"
start = time.perf_counter()


# IMPLEMENTATION
with open(path) as f:
    data = f.read().splitlines()
    

# OUTPUT
# end = time.perf_counter()
# print(f"Solution = {sol}")
# print(f"Time = {(end-start)*1000:.3f} ms")

    
