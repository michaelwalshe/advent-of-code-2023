from dataclasses import dataclass, field
from pathlib import Path

import pytest


@dataclass(frozen=True)
class HSpringRow:
    row_len: int
    contig_broken: tuple[int, ...]
    unknown_springs: frozenset[int]
    broken_springs: frozenset[int]


@dataclass
class SpringRow:
    row_len: int
    contig_broken: tuple[int, ...]
    unknown_springs: set[int] = field(default_factory=set)
    broken_springs: set[int] = field(default_factory=set)

    def freeze(self) -> HSpringRow:
        return HSpringRow(
            self.row_len,
            self.contig_broken,
            frozenset(self.unknown_springs),
            frozenset(self.broken_springs),
        )


def count_contiguous(spring_row: SpringRow) -> tuple[int, ...]:
    contig = []
    curr_len = 0

    if spring_row.unknown_springs:
        start = max(spring_row.unknown_springs)
    else:
        start = 0

    for i in range(start, spring_row.row_len):
        if i in spring_row.broken_springs:
            if (i - 1) in spring_row.broken_springs:
                curr_len += 1
            else:
                curr_len = 1
        elif curr_len >= 1:
            contig.append(curr_len)
            curr_len = 0
    if curr_len >= 1:
        contig.append(curr_len)
    return tuple(contig)


def num_arrangements(s: SpringRow) -> int:
    valid_rows = set()
    queue = [s]
    while queue:
        curr_s = queue.pop()

        if not curr_s.unknown_springs:
            if count_contiguous(curr_s) == curr_s.contig_broken:
                valid_rows.add(tuple(sorted(curr_s.broken_springs)))
            continue

        next_unknown = max(curr_s.unknown_springs)
        next_b1 = curr_s.broken_springs | {next_unknown}
        next_b2 = curr_s.broken_springs
        for next_b in (next_b1, next_b2):
            # Spring is fixed or broken
            next_s = SpringRow(
                curr_s.row_len,
                contig_broken=curr_s.contig_broken,
                unknown_springs=curr_s.unknown_springs - {next_unknown},
                broken_springs=next_b,
            )
            contig = count_contiguous(next_s)
            if len(contig) in (0, 1) or (
                contig[1:] == next_s.contig_broken[-len(contig) + 1 :]
            ):
                queue.append(next_s)

    return len(valid_rows)


def compute(s: str) -> int:
    spring_rows = []
    for line in s.splitlines():
        spring_str, contig_str = line.split()
        spring_row = SpringRow(
            row_len=len(spring_str),
            contig_broken=tuple(map(int, contig_str.split(","))),
        )
        for i, c in enumerate(spring_str):
            if c == "?":
                spring_row.unknown_springs.add(i)
            elif c == "#":
                spring_row.broken_springs.add(i)
        spring_rows.append(spring_row)

    tot_methods = 0
    for spring_row in spring_rows:
        tot_methods += num_arrangements(spring_row)

    return tot_methods


INPUT_S = """\
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
"""
EXPECTED = 21


@pytest.mark.parametrize(
    ("input_s", "expected"),
    ((INPUT_S, EXPECTED),),
)
def test(input_s: str, expected: int) -> None:
    assert compute(input_s) == expected


INPUT_TXT = Path(__file__).parent / "input.txt"


def main() -> int:
    print(compute(INPUT_S))

    with open(INPUT_TXT) as f:
        print(compute(f.read()))

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
