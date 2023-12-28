from pathlib import Path
import numpy as np

import pytest

import support


def print_rocks(rocks):
    support.print_coords_hash([(y, x) for x, y in zip(*rocks.nonzero())])


def compute(s: str) -> int:
    cube_rocks = np.zeros((len(s.splitlines()), len(s.splitlines()[0])), dtype=np.int8)
    round_rocks = cube_rocks.copy()
    for i, line in enumerate(s.splitlines()):
        for j, c in enumerate(line):
            if c == "O":
                round_rocks[i, j] = 1
            elif c == "#":
                cube_rocks[i, j] = 1

    seen_rocks = {}
    for itr in range(1, 1_000_000_000):
        for _ in range(4):
            for i, j in zip(*round_rocks.nonzero()):
                # Find the idxs of rocks in this column, either constant or round
                rocks = np.argwhere(cube_rocks[:i, j] | round_rocks[:i, j])
                # Get next possible rock posn
                i2 = rocks.max() + 1 if rocks.size > 0 else 0
                # Remove old rock, set new rock
                round_rocks[i, j] = 0
                round_rocks[i2, j] = 1
            # Rotate clockwise
            round_rocks = np.rot90(round_rocks, -1)
            cube_rocks = np.rot90(cube_rocks, -1)

        round_rocks_tpl = tuple(tuple(r) for r in round_rocks)
        if (
            round_rocks_tpl in seen_rocks
            and (1_000_000_000 - itr) % (itr - seen_rocks[round_rocks_tpl]) == 0
        ):
            # If we've seen this before, and have an integer
            # number of cycles left, then are on the end state so exit and calculate
            break
        seen_rocks[round_rocks_tpl] = itr

    max_i = round_rocks.shape[0]
    vals = round_rocks * np.arange(max_i, stop=0, step=-1).reshape(max_i, 1)
    return np.sum(vals)


INPUT_S = """\
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
"""
EXPECTED = 64


@pytest.mark.parametrize(
    ("input_s", "expected"),
    ((INPUT_S, EXPECTED),),
)
def test(input_s: str, expected: int) -> None:
    assert compute(input_s) == expected


INPUT_TXT = Path(__file__).parent / "input.txt"


def main() -> int:
    compute(INPUT_S)
    with open(INPUT_TXT) as f, support.timing():
        print(compute(f.read()))

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
