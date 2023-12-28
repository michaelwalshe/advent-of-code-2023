from pathlib import Path

import pytest

import support


def compute(s: str) -> int:
    round_rocks = []
    cube_rocks = set()
    for i, line in enumerate(s.splitlines()):
        for j, c in enumerate(line):
            if c == 'O':
                round_rocks.append((j, i))
            elif c == '#':
                cube_rocks.add((j, i))

    final_round_rocks = set()
    for r in round_rocks:
        i = r[1]
        while i > 0:
            if (r[0], i-1) in cube_rocks or (r[0], i-1) in final_round_rocks:
                break
            i -= 1

        final_round_rocks.add((r[0], i))

    dist_to_south = len(s.splitlines())
    return sum(dist_to_south - r[1] for r in final_round_rocks)

INPUT_S = '''\
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
'''
EXPECTED = 136


@pytest.mark.parametrize(
    ('input_s', 'expected'),
    (
        (INPUT_S, EXPECTED),
    ),
)
def test(input_s: str, expected: int) -> None:
    assert compute(input_s) == expected


INPUT_TXT = Path(__file__).parent / 'input.txt'


def main() -> int:
    with open(INPUT_TXT) as f, support.timing():
        print(compute(f.read()))

    return 0


if __name__ == '__main__':
    raise SystemExit(main())
