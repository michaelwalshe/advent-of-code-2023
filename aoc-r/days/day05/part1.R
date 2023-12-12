here::i_am("days/day05/part1.R")
library(here)

source(here("R", "utils.R"))

library(stringr)
library(purrr)

compute <- function(s = "") {
  maps <- vector("list")
  seeds <-
    str_split_1(s, "\n\n")[1] |>
    str_split_1(":") |>
    _[2] |>
    str_split_1(" ") |>
    as.numeric() |>
    _[-1]

  for (section in str_split_1(s, "\n\n")[-1]) {
    lines <- str_split_1(section, "\n")

    current_map <- lines[1] |> str_split_1(" ") |> _[1]

    maps[[current_map]] <- str_split_fixed(lines[-1], " ", 3) |> as.numeric() |> matrix(ncol=3)
  }

  for (map in maps) {
    range_length <- map[,3]
    sources <- map[,2]
    destinations <- map[,1]

    new_seeds <- double(length(seeds))

    for (i in seq_along(seeds)) {
      seed <- seeds[[i]]
      idx <- which(seed >= sources & seed <= sources + range_length)

      if (length(idx) >= 1) {
        idx <- idx[[1]]
        new_seeds[[i]] <- destinations[[idx]] - sources[[idx]] + seed
      } else {
        new_seeds[[i]] <- seed
      }
    }

    seeds <- new_seeds
  }

  return(min(seeds))
}


input_small <- "seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4"
expected_small <- 35

testthat::expect_equal(compute(input_small), expected_small)

input_large <- read_input(here("days/day05"))
print(compute(input_large))

