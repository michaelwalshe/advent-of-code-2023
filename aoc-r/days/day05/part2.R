here::i_am("days/day05/part1.R")
library(here)

source(here("R", "utils.R"))

library(stringr)
library(purrr)

compute <- function(s = "") {
  maps <- vector("list")
  seed_ranges <-
    str_split_1(s, "\n\n")[1] |>
    str_split_1(":") |>
    _[2] |>
    str_split_1(" ") |>
    as.numeric() |>
    _[-1]

  for (section in str_split_1(s, "\n\n")[-1]) {
    lines <- str_split_1(section, "\n")

    current_map <- lines[1] |> str_split_1(" ") |> _[1]

    maps[[current_map]] <- lines[-1] |> str_split_fixed(" ", 3) |> as.numeric() |> matrix(ncol=3)
  }

  for (map in maps) {
    range_length <- map[,3]
    source_min <- map[,2]
    source_max <- source_min + range_length - 1
    destination_min <- map[,1]
    destination_max <- destination_min + range_length - 1

    new_seeds <- double()

    for (i in seq(1, length(seed_ranges), by=2)) {
      seed_min <- seed_ranges[[i]]
      seed_max <- seed_min + seed_ranges[[i+1]] - 1

      for (j in seq_along(source_min)) {
        if (source_min[[j]] <= seed_min & seed_max <= source_max[[j]]) {
          # Entirely within range, source_min < seed_min < seed_max < source_max
          new_seeds <- c(
            new_seeds,
            # New min, get destination minus source for delta, plus  min seed val
            seed_min + (destination_min[[j]] - source_min[[j]]),
            # Get range of seeds included, in this case all
            seed_max - seed_min + 1
          )
          # Consumes all seeds
          seed_min <- NA
          seed_max <- NA
          break
        } else if (source_min[[j]] <= seed_min & seed_min <= source_max[[j]]) {
          # Left side within range, source_min < seed_min < source_max < seed_max
          new_seeds <- c(
            new_seeds,
            # New min, equiv. previous
            seed_min + (destination_min[[j]] - source_min[[j]]),
            # New range is between the min and the max within sources
            source_max[[j]] - seed_min + 1
          )
          # Consume left half of seeds
          seed_min <- source_max[[j]]
        } else if (source_min[[j]] <= seed_max & seed_max <= source_max[[j]]) {
          # Right side within range, seed_min < source_min < seed_max < source_max
          new_seeds <- c(
            new_seeds,
            # Same min
            destination_min[[j]],
            # New range is between the source_min and the seed_max within sources
            seed_max - source_min[[j]] + 1
          )
          # Consume right half of seeds
          seed_max <- source_min[[j]]
        }
      }

      if (!is.na(seed_min)) {
        # Some unmapped seeds
        new_seeds <- c(new_seeds, seed_min, seed_max - seed_min + 1)
      }
    }

    seed_ranges <- new_seeds
  }

  return(min(seed_ranges[seq(1, length(seed_ranges), 2)]))
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
expected_small <- 46

testthat::expect_equal(compute(input_small), expected_small)

input_large <- read_input(here("days/day05"))
print(compute(input_large))

