from pathlib import Path

import support

YEAR = 2023

HERE = Path.home() / f"source/personal/advent-of-code-{YEAR}/aoc-python"

support.create_day(12, YEAR, HERE)
