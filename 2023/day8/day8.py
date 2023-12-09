# BOILERPLATE
import os
import time

example = False
if example:
    path = os.path.dirname(__file__) + "\example2.txt"
else:
    path = os.path.dirname(__file__) + "\input.txt"
start = time.perf_counter()


# IMPLEMENTATION
import math

with open(path) as f:
    data = f.read().splitlines()


def parse(data):
    instructs = data[0]
    data = data[2:]

    nodes = []
    ptrs = []
    for line in data:
        node, ptr = line.replace(" ", "").split("=")
        ptr = ptr.replace("(", "").replace(")", "").split(",")
        nodes.append(node)
        ptrs.append(ptr)

    return instructs, nodes, ptrs


def next_node(node, nodes, ptrs, instruction):
    idx = nodes.index(node)

    if instruction == "L":
        return ptrs[idx][0]
    elif instruction == "R":
        return ptrs[idx][1]
    else:
        raise Exception("Invalid instruction")


def get_A_nodes(nodes):
    A_nodes = []
    for node in nodes:
        if node[-1] == "A":
            A_nodes.append(node)
    return A_nodes


def check_if_Z_node(node):
    if node[-1] != "Z":
        return False
    return True


def find_zzz(data):
    steps = 0
    i = 0
    node = "AAA"
    while not node == "ZZZ":
        node = next_node(node, nodes, ptrs, instructs[i])
        steps += 1
        i = i + 1 if i < len(instructs) - 1 else 0  # Instructions can repeat

    return steps


def find_xyz(data, start_node):
    steps = 0
    i = 0
    node = start_node
    while not check_if_Z_node(node):
        node = next_node(node, nodes, ptrs, instructs[i])
        steps += 1
        i = i + 1 if i < len(instructs) - 1 else 0  # Instructions can repeat

    return steps


def run_part2(data):
    # Find the steps for each __A node until __Z
    # Then assume that they loop at this period
    # The number where they sync is the lowest common mutliple of the periods
    # There is NOTHING in the question to suggest that this is the case - flawed question.
    ghost_nodes = get_A_nodes(nodes)
    steps = []
    for node in ghost_nodes:
        steps.append(find_xyz(data, node))

    ans = math.lcm(*steps)
    return ans


instructs, nodes, ptrs = parse(data)
sol = (find_zzz(data), run_part2(data))


# OUTPUT
end = time.perf_counter()
print(f"Solution = {sol}")
print(f"Time = {(end-start)*1000:.3f} ms")
