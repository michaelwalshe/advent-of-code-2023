from __future__ import annotations

import argparse
from dataclasses import dataclass
import os.path

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

    current_node = nodes["AAA"]
    n_moves = 0
    while current_node.id != "ZZZ":
        current_node = nodes[
            current_node.nodes[instructions[n_moves % len(instructions)]]
        ]
        n_moves += 1
    return n_moves


INPUT_S = """\
RL\n

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
"""
EXPECTED = 2

INPUT_S2 = """\
LLR\n

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)
"""
EXPECTED2 = 6


@pytest.mark.parametrize(
    ("input_s", "expected"),
    (
        (INPUT_S, EXPECTED),
        (INPUT_S2, EXPECTED2),
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
