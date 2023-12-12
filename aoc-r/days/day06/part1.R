here::i_am("days/day06/part1.R")
library(here)

source(here("R", "utils.R"))

library(stringr)
library(purrr)

compute <- function(s = "") {
  input <-
    str_split_1(s, "\n") |>
    str_split_fixed(":", 2) |>
    _[, 2] |>
    str_split("\\s+")

  time <- as.numeric(input[[1]][-1])
  distance <- as.numeric(input[[2]][-1])

  wins <- 1
  for (i in seq_along(time)) {
    possible_holds <- seq(1, time[[i]] - 1)
    possible_distances <- (time[[i]] - possible_holds) * possible_holds

    wins <- wins * sum(possible_distances > distance[[i]])
  }

  wins
}


input_small <- "Time:      7  15   30
Distance:  9  40  200"
expected_small <- 288

testthat::expect_equal(compute(input_small), expected_small)

input_large <- read_input(here("days/day06"))
print(compute(input_large))

