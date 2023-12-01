here::i_am("days/day01/part1.R")
library(here)

source(here("R", "utils.R"))

library(stringr)
library(purrr)

compute <- function(s = "") {
  # Part 2 improvement, rather than sliding windows just replace all instances
  # of a word number with word<digit>word. This keeps overlaps
  numbers <- c("one", "two", "three", "four", "five", "six", "seven", "eight", "nine")
  replacement <- str_c(numbers, 1:9, numbers)

  for (i in seq_along(numbers)) {
    s <- str_replace_all(s, numbers[i], replacement[i])
  }

  s |>
    str_split_1("\n") |>
    str_extract_all("\\d") |>
    map_dbl(\(x) as.numeric(paste0(x[1], x[length(x)]))) |>
    sum()
}


input_small <- "two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen"
expected_small <- 281

testthat::expect_equal(compute(input_small), expected_small)

input_large <- read_input(here("days/day01"))
print(compute(input_large))
