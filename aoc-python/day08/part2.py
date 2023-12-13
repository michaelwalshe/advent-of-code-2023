from __future__ import annotations

import argparse
import os.path
import math
from dataclasses import dataclass

import pytest

import support

INPUT_TXT = os.path.join(os.path.dirname(__file__), "input.txt")


@dataclass
class Node:
    id: str
    nodes: dict[str, str]


def compute(s: str) -> int:
    instr_map = s.split("\n\n")

    instructions = instr_map[0]

    nodes = {}
    for line in instr_map[1].splitlines():
        id = line[0:3]
        left = line[7:10]
        right = line[12:15]
        nodes[id] = Node(id, {"L": left, "R": right})

    starting_nodes = [id for id in nodes if id[2] == "A"]
    node_moves_to_z = []
    for id in starting_nodes:
        n_moves = 0
        current_node = nodes[id]
        while not current_node.id.endswith("Z"):
            current_node = nodes[
                current_node.nodes[instructions[n_moves % len(instructions)]]
            ]
            n_moves += 1
        node_moves_to_z.append(n_moves)

    return math.lcm(*node_moves_to_z)


INPUT_S = """LR\n

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)
"""
EXPECTED = 6



@pytest.mark.parametrize(
    ("input_s", "expected"),
    (
        (INPUT_S, EXPECTED),
    ),
)
def test(input_s: str, expected: int) -> None:
    assert compute(input_s) == expected


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("data_file", nargs="?", default=INPUT_TXT)
    args = parser.parse_args()

    with open(args.data_file) as f, support.timing():
        print(compute(f.read()))

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
