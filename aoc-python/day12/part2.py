from dataclasses import dataclass
from enum import Enum
from functools import cache
from pathlib import Path

import pytest


class Spring(Enum):
    BROKEN = "#"
    WORKING = "."
    UNKNOWN = "?"


@dataclass(frozen=True)
class SpringRow:
    springs: tuple[Spring, ...]
    contig_broken: tuple[int, ...]


@cache
def num_arrangements(s: SpringRow, n_contig: int = 0) -> int:
    # Get current and next contigous groups to check. If we have no new contiguous
    # group to check, then current contig should be 0
    curr_contig, *next_contig_broken = s.contig_broken or (0,)
    next_contig_broken = tuple(next_contig_broken)

    if not s.springs:
        # No springs left to check -> base case of arrangements
        # If this is the final contigous group, and it equals the current
        # length of contiguous group, then valid arrangement
        if len(next_contig_broken) == 0 and curr_contig == n_contig:
            return 1
        else:
            return 0

    match s.springs:
        case (Spring.UNKNOWN, *new_springs):
            # Return number of valid arrangements of each branch from here, if the spring
            # was broken or working
            return num_arrangements(
                SpringRow(tuple([Spring.BROKEN] + new_springs), s.contig_broken),
                n_contig,
            ) + num_arrangements(
                SpringRow(tuple([Spring.WORKING] + new_springs), s.contig_broken),
                n_contig,
            )
        case (Spring.BROKEN, *new_springs):
            if n_contig > curr_contig:
                # We have gone over the contiguous pattern allowed, not a valid arrangement
                return 0
            else:
                # Keep counting number of contiguous, adding 1 to current count
                return num_arrangements(
                    SpringRow(tuple(new_springs), s.contig_broken), n_contig + 1
                )
        case (Spring.WORKING, *new_springs):
            if n_contig == 0:
                # We have no current run, and have got another '.'. So continue on with the same
                # contig_broken as input
                return num_arrangements(
                    SpringRow(tuple(new_springs), s.contig_broken), 0
                )
            elif n_contig == curr_contig:
                # Have just finished a contig block, and it was of the right size! Continue checking
                # with the remaining springs, and the new contig_broken
                return num_arrangements(
                    SpringRow(tuple(new_springs), next_contig_broken), 0
                )
            else:
                # Just finished a block and it was the wrong size, so this is not a valid arrangement.
                return 0
        case _:
            raise ValueError(f"Unexpected Spring in  {s}")


def compute(s: str, n: int) -> int:
    spring_rows = []
    for line in s.splitlines():
        spring_str, contig_str = line.split()
        spring_str = "?".join([spring_str] * n)
        contig_str = ",".join([contig_str] * n)
        spring_row = SpringRow(
            tuple(Spring(s) for s in spring_str),
            tuple(map(int, contig_str.split(","))),
        )
        spring_rows.append(spring_row)

    tot_methods = 0
    for spring_row in spring_rows:
        tot_methods += num_arrangements(spring_row)

    return tot_methods


INPUT_TXT = (Path(__file__).parent / "input.txt").read_text()

INPUT_S = """\
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
"""
EXPECTED = 21
EXPECTED_2 = 525152

EXPECTED_BIG = 7361


@pytest.mark.parametrize(
    ("input_s", "expected", "n"),
    (
        (INPUT_S, EXPECTED, 1),
        (INPUT_S, EXPECTED_2, 5),
        (INPUT_TXT, EXPECTED_BIG, 1),
    ),
)
def test(input_s: str, expected: int, n: int) -> None:
    assert compute(input_s, n) == expected


def main() -> int:
    print(compute(INPUT_S, 1))
    print(compute(INPUT_S, 5))

    print(compute(INPUT_TXT, 1))
    print(compute(INPUT_TXT, 5))

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
