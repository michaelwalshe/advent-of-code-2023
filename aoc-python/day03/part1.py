from __future__ import annotations

import argparse
import os.path

import pytest

import support

INPUT_TXT = os.path.join(os.path.dirname(__file__), 'input.txt')


def compute(s: str) -> int:
    lines = s.splitlines()
    to_check = set()
    for j, line in enumerate(lines):
        for i, c in enumerate(line):
            if c == ".":
                continue
            elif not c.isnumeric():
                for x, y in support.adjacent_8(i, j):
                    to_check.add((x, y))

    tot = 0
    is_number = False
    to_add = False
    char_num = ""
    for j, line in enumerate(lines):
        for i, c in enumerate(line):
            if not c.isnumeric() and is_number:
                if to_add:
                    tot += int(char_num)
                char_num = ""
                is_number = False
                to_add = False

            if c.isnumeric():
                char_num += c
                is_number = True

            if not to_add and is_number and (i, j) in to_check:
                to_add = True
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
EXPECTED = 4361


@pytest.mark.parametrize(
    ('input_s', 'expected'),
    (
        (INPUT_S, EXPECTED),
    ),
)
def test(input_s: str, expected: int) -> None:
    assert compute(input_s) == expected


def main() -> int:
    assert compute(INPUT_S) == EXPECTED

    parser = argparse.ArgumentParser()
    parser.add_argument('data_file', nargs='?', default=INPUT_TXT)
    args = parser.parse_args()

    with open(args.data_file) as f, support.timing():
        print(compute(f.read()))

    return 0


if __name__ == '__main__':
    raise SystemExit(main())
