from __future__ import annotations

import argparse
import os.path

import pytest

import support

INPUT_TXT = os.path.join(os.path.dirname(__file__), "input.txt")


def peek(grid: list[list[str]], i: int, j: int) -> str:
    if i < 0 or i >= len(grid) or j < 0 or j >= len(grid[0]):
        return ""
    return grid[i][j]


def manhatten_dist(i1: int, j1: int, i2: int, j2: int) -> int:
    return abs(i1 - i2) + abs(j1 - j2)


def compute(s: str) -> int:
    grid = [list(r) for r in s.splitlines()]

    # Find and double all blank rows/cols
    blank_rows = []
    blank_cols = []
    for i, row in enumerate(grid):
        if all(c == "." for c in row):
            blank_rows.append(i)
    for j in range(len(grid[0])):
        if all(row[j] == "." for row in grid):
            blank_cols.append(j)

    galaxies = []
    for i, row in enumerate(grid):
        for j, c in enumerate(row):
            if c == "#":
                gi = i + len([r for r in blank_rows if r <= i]) * 999_999
                gj = j + len([c for c in blank_cols if c <= j]) * 999_999
                galaxies.append((gi, gj))

    galaxy_paths = {}
    for i, (i1, j1) in enumerate(galaxies):
        for j, (i2, j2) in enumerate(galaxies):
            if i == j:
                continue
            if ((i2, j2), (i1, j1)) in galaxy_paths:
                continue
            galaxy_paths[((i1, j1), (i2, j2))] = manhatten_dist(i1, j1, i2, j2)

    # Summ all path lengths
    return sum(p for p in galaxy_paths.values())


INPUT_S = """\
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#....."""
EXPECTED = 374


@pytest.mark.parametrize(
    ("input_s", "expected"),
    ((INPUT_S, EXPECTED),),
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
