here::i_am("days/day02/part1.R")
library(here)

source(here("R", "utils.R"))

library(stringr)
library(purrr)

compute <- function(s = "") {
  true_balls <- c(red = 12, green = 13, blue = 14)

  games <- str_split_1(s, "\\n")
  ids <- double(length(games))

  for (i in seq_along(games)) {
    game <- games[[i]]
    id_sets <- str_split_1(game, ":")
    ids[[i]] <- id_sets[1] |> str_extract("\\d+") |> as.numeric()

    for (set in str_split_1(id_sets[[2]], ";")) {
      n_balls <- as.numeric(str_extract_all(set, "\\d+")[[1]])
      names(n_balls) <- str_extract_all(set, "blue|red|green")[[1]]

      if (any(true_balls[names(n_balls)] < n_balls)) {
        ids[[i]] <- 0
      }
    }
  }

  sum(ids)
}


input_small <- "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
expected_small <- 8

testthat::expect_equal(compute(input_small), expected_small)

input_large <- read_input(here("days/day02"))
print(compute(input_large))

