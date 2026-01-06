from pathlib import Path

import pytest
import matplotlib.pyplot as plt
import math as m
from shapely import Point, Polygon, LinearRing

import support

DIRS = {"R": +0 + 1j, "L": +0 - 1j, "U": +1 + 0j, "D": -1 - 0j}

DIRS2 = {"0": +0 + 1j, "2": +0 - 1j, "3": +1 + 0j, "1": -1 - 0j}


def compute(s: str) -> int:
    edges: list[tuple[float, float]] = [(0, 0)]
    posn = 0 + 0j

    for line in s.splitlines():
        _, _, hex_dir = line.split()
        hex_dir = hex_dir.strip("()")

        posn += DIRS2[hex_dir[-1]] * int(hex_dir[1:-1], 16)

        edges.append((posn.real, posn.imag))

    lagoon = Polygon(edges)

    plt.plot(*lagoon.exterior.xy)

    return int(lagoon.buffer(0.5, cap_style="square", join_style="mitre").area)


INPUT_S = """\
R 6 (#70c710)
D 5 (#0dc571)
L 2 (#5713f0)
D 2 (#d2c081)
R 2 (#59c680)
D 2 (#411b91)
L 5 (#8ceee2)
U 2 (#caa173)
L 1 (#1b58a2)
U 2 (#caa171)
R 2 (#7807d2)
U 3 (#a77fa3)
L 2 (#015232)
U 2 (#7a21e3)
"""
EXPECTED = 952408144115


@pytest.mark.parametrize(
    ("input_s", "expected"),
    ((INPUT_S, EXPECTED),),
)
def test(input_s: str, expected: int) -> None:
    assert compute(input_s) == expected


INPUT_TXT = Path(__file__).parent / "input.txt"


def main() -> int:
    print(compute(INPUT_S))

    with open(INPUT_TXT) as f, support.timing():
        print(compute(f.read()))

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
