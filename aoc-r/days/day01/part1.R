here::i_am("days/day01/part1.R")
library(here)

source(here("R", "utils.R"))

library(stringr)
library(purrr)

compute <- function(s = "") {
  s |>
    str_split_1("\n") |>
    stringr::str_extract_all("\\d") |>
    map_dbl(\(x) as.numeric(paste0(x[1], x[length(x)]))) |>
    sum()
}


input_small <- "1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet"
expected_small <- 142

testthat::expect_equal(compute(input_small), expected_small)

input_large <- read_input(here("days/day01"))
print(compute(input_large))
