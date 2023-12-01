here::i_am("days/day01/part1.R")
library(here)

source(here("R", "utils.R"))

library(stringr)
library(purrr)

compute <- function(s = "") {
  numbers <- c("one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten")
  numbers_c <- as.character(1:9)

  find_numbers <- function(x) {
    # Switch from regex to two pointer as need overlapping
    # matches, e.g. twone -> two, one
    len_x <- str_length(x)
    out <- character(len_x)
    l <- 1
    r <- 1
    out_index <- 1
    while (TRUE) {
      if (l > len_x) {
        break
      }

      chars <- str_sub(x, l, r)

      if (chars %in% numbers || chars %in% numbers_c) {
        out[out_index] <- chars
        out_index <- out_index + 1
        l <- l + 1
        r <- l
      } else {
        r <- r + 1
      }

      # Can have max 5 chars in word number, so that
      # is max size of window
      if (r - l >= 5 || r > len_x) {
        l <- l + 1
        r <- l
      }
    }
    return(out[out != ""])
  }


  s |>
    str_split_1("\n") |>
    map(find_numbers) |>
    map(\(x) {
      # If have a digit, return as-is, otherwise find index
      # of the word in our numbers vector
      n <- suppressWarnings(as.numeric(x))
      ifelse(
        !is.na(n),
        n,
        match(x, numbers)
      )
    }) |>
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
