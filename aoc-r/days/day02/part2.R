here::i_am("days/day02/part1.R")
library(here)

source(here("R", "utils.R"))

library(stringr)
library(purrr)

compute <- function(s = "") {
  ball_power <- 0

  for (game in str_split_1(s, "\\n")) {
    min_balls <- c(red = 0, green = 0, blue = 0)

    for (set in game |> str_split_1(":") |> _[[2]] |> str_split_1(";")) {
      # Extract numbers, assign colour names
      n_balls <- as.numeric(str_extract_all(set, "\\d+", simplify = TRUE))
      names(n_balls) <- str_extract_all(set, "blue|red|green", simplify = TRUE)

      # Fill in missing balls with 0
      n_balls[setdiff(c("blue", "red", "green"), names(n_balls))] <- 0

      # Re-order, then parallel max to get new minimum possible ball nos
      n_balls <- n_balls[names(min_balls)]
      min_balls <- pmax(min_balls, n_balls)
    }

    ball_power <- ball_power + prod(min_balls)
  }

  return(ball_power)
}


input_small <- "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
expected_small <- 2286

testthat::expect_equal(compute(input_small), expected_small)

input_large <- read_input(here("days/day02"))
print(compute(input_large))

