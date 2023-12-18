from pathlib import Path
from typing import Literal

import pytest
import numpy as np

import support


def find_symmetry(grid: np.ndarray, orientation: Literal["v", "h"]) -> int:
    """Return the number of rows above, or the number of cols to the left,
    of the line of symmetry.

    Return if no symmetry is found.
    """
    if orientation == "h":
        grid = grid.T

    # Find the number of cols to the left of the line of symmetry
    for i in range(grid.shape[1] - 1):
        # Make sure left and right are the same size
        if i < grid.shape[1] // 2:
            left = grid[:, : (i + 1)]
            right = grid[:, (i + 1) : 2 * (i + 1)]
        else:
            left = grid[:, (i - (grid.shape[1] - 2 - i)) : (i + 1)]
            right = grid[:, (i + 1) :]

        # Bitwise XOR, and sum, to check that exact match
        if np.sum(left ^ np.fliplr(right)) == 0:
            # Found reflection, add columns to the left
            return i + 1
    return 0


def compute(s: str) -> int:
    grids = s.split("\n\n")

    tot = 0
    for grid in grids:
        # Convert to 1s and 0s
        grid = np.array(
            [[1 if c == "#" else 0 for c in row] for row in grid.splitlines()]
        )
        # Check vertical reflection
        i = find_symmetry(grid, "v")
        if not i:
            # Check horizontal reflection
            tot += 100 * find_symmetry(grid, "h")
        else:
            tot += i

    return tot


INPUT_S = """\
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
"""
EXPECTED = 405


@pytest.mark.parametrize(
    ("input_s", "expected"),
    ((INPUT_S, EXPECTED),),
)
def test(input_s: str, expected: int) -> None:
    assert compute(input_s) == expected


INPUT_TXT = Path(__file__).parent / "input.txt"


def main() -> int:
    with open(INPUT_TXT) as f, support.timing():
        print(compute(f.read()))

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
