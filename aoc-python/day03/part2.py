from __future__ import annotations

import argparse
import math
import os.path

import pytest

import support

INPUT_TXT = os.path.join(os.path.dirname(__file__), 'input.txt')


def peek(arr: list[list[str]], i: int, j: int) -> str:
    try:
        return arr[j][i]
    except IndexError:
        return ""


def compute(s: str) -> int:
    lines = s.splitlines()
    grid = [list(line) for line in lines]
    tot = 0
    for j, line in enumerate(lines):
        for i, c in enumerate(line):
            # For each character in the grid, plus coords
            if c != "*":
                # Ignore non-gears
                continue
            gears = []
            for x, y in support.adjacent_8(i, j):
                # Check all adjoining blocks for numbers
                num = ""
                if grid[y][x].isnumeric():
                    # If find number, then crawl in both directions
                    # and consume all adjacent numbers
                    x2 = x
                    while (c2 := peek(grid, x2, y)).isnumeric():
                        grid[y][x2] = " "
                        num += c2
                        x2 += 1
                    x3 = x - 1
                    while (c3 := peek(grid, x3, y)).isnumeric():
                        grid[y][x2] = " "
                        num = c3 + num
                        x3 -= 1
                if num:
                    # If found number, add to the gears
                    gears.append(int(num))
            if len(gears) > 1:
                # With at least two gears, compute gear ratio and add
                tot += math.prod(gears)

    return tot


INPUT_S = '''\
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
'''
EXPECTED = 467835


@pytest.mark.parametrize(
    ('input_s', 'expected'),
    (
        (INPUT_S, EXPECTED),
    ),
)
def test(input_s: str, expected: int) -> None:
    assert compute(input_s) == expected


def main() -> int:
    print(compute(INPUT_S))
    assert compute(INPUT_S) == EXPECTED

    parser = argparse.ArgumentParser()
    parser.add_argument('data_file', nargs='?', default=INPUT_TXT)
    args = parser.parse_args()

    with open(args.data_file) as f, support.timing():
        print(compute(f.read()))

    return 0


if __name__ == '__main__':
    raise SystemExit(main())
