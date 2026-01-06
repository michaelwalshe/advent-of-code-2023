from typing import Generator
from heapq import heappop, heappush, heapify
from pathlib import Path
import math as m
import pytest

import support


class Point(complex):
    @property
    def _complex(self) -> complex:
        return complex(self)

    def __lt__(self, other: complex):
        return self.real < other.real and self.imag < other.imag

    def __add__(self, other: complex):
        return Point(self._complex + other)


class Dir(complex):
    @property
    def _complex(self) -> complex:
        return complex(self)

    def __lt__(self, other: complex):
        return self.real < other.real and self.imag < other.imag

    def __mul__(self, other: complex | int | float):
        return Dir(self._complex * other)


def get_next(
    p: Point,
    dir: Dir,
    heat: int,
    grid: dict[Point, int],
    seen: dict[tuple[Point, Dir], int],
) -> Generator[tuple[int, Point, Dir]]:
    dist = 1

    while dist <= 10:
        next_p = p + dir * dist

        if next_p not in grid:
            break

        heat += grid[next_p]

        if dist >= 4:
            for next_dir in (dir * -1j, dir * 1j):
                if seen.get((next_p, next_dir), m.inf) > heat:
                    yield heat, next_p, next_dir

        dist += 1


def compute(s: str) -> int:
    grid: dict[Point, int] = {}
    lines = s.splitlines()
    for j, line in enumerate(lines):
        for i, c in enumerate(line):
            grid[Point(i, -1 * j)] = int(c)
    start = Point(0, 0)
    end = Point((len(lines[0]) - 1), (1 - len(lines)))

    queue = [(0, start, Dir(1, 0)), (0, start, Dir(0, -1))]
    heapify(queue)
    seen = {
        (start, Dir(1, 0)): 0,
        (start, Dir(0, -1)): 0,
    }
    min_heat = m.inf
    while queue:
        curr_heat, curr_point, curr_dir = heappop(queue)
        for next_heat, next_point, next_dir in get_next(
            curr_point, curr_dir, curr_heat, grid, seen
        ):
            if next_point == end:
                min_heat = min(min_heat, next_heat)
            else:
                seen[(next_point, next_dir)] = next_heat
                heappush(queue, (next_heat, next_point, next_dir))

    return int(min_heat)


INPUT_S = """\
2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533
"""
EXPECTED = 94

INPUT_S2 = """\
111111111111
999999999991
999999999991
999999999991
999999999991
"""
EXPECTED2 = 71


@pytest.mark.parametrize(
    ("input_s", "expected"),
    (
        (INPUT_S, EXPECTED),
        (INPUT_S2, EXPECTED2),
    ),
)
def test(input_s: str, expected: int) -> None:
    assert compute(input_s) == expected


INPUT_TXT = Path(__file__).parent / "input.txt"


def main() -> int:
    print(compute(INPUT_S))
    print(compute(INPUT_S2))

    with open(INPUT_TXT) as f, support.timing():
        print(compute(f.read()))

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
