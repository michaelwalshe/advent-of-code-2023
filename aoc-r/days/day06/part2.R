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
    str_replace_all("\\s+", "")

  time <- as.numeric(input[[1]])
  distance <- as.numeric(input[[2]])

  # Naive approach works?
  possible_holds <- seq(1, time - 1)
  possible_distances <- (time - possible_holds) * possible_holds

  sum(possible_distances > distance)
}


input_small <- "Time:      7  15   30
Distance:  9  40  200"
expected_small <- 71503

testthat::expect_equal(compute(input_small), expected_small)

input_large <- read_input(here("days/day06"))
print(compute(input_large))

