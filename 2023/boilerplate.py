import os
import time
path = os.path.dirname(__file__) + "\input.txt"
start = time.perf_counter()



end = time.perf_counter()
print(f"Solution = {solution(path)}")
print(f"Time = {(end-start)*1000:.4f} ms")

    
