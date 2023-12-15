here::i_am("days/day10/part1.R")
library(here)

source(here("R", "utils.R"))

library(stringr)
library(purrr)
library(fastmap)

connections = list(
  # Whether a pipe char has an output at: UP, RIGHT, DOWN, LEFT
  "L" = c(1, 1, 0, 0),
  "7" = c(0, 0, 1, 1),
  "F" = c(0, 1, 1, 0),
  "J" = c(1, 0, 0, 1),
  "|" = c(1, 0, 1, 0),
  "-" = c(0, 1, 0, 1),
  "." = c(0, 0, 0, 0)
)
# Convert to bools for use as an index of directions
connections <- map(connections, \(x) as.logical(x))

directions <- list(
  c(-1, 0), # UP
  c(0, 1),  # RIGHT
  c(1, 0),  # DOWN
  c(0, -1)  # LEFT
)

compute <- function(s = "") {
  grid <- s |> str_split_1("\n")
  grid <- str_split_fixed(grid, "", n=nchar(grid[1]))

  start = unname(which(grid == "S", arr.ind=TRUE))

  i <- start[1]
  j <- start[2]
  # Find the pipe next to S that could lead into it, this is where we'll start
  for (idx in seq_along(directions)) {
    d <- directions[[idx]]
    if (
         i + d[1] <= 0
      || i + d[1] > nrow(grid)
      || j + d[2] <= 0
      || j + d[2] > ncol(grid)
    ) {
      # Skip if out of bounds
      next
    }
    pipe <- grid[i + d[1], j + d[2]]
    for (d2 in directions[connections[[pipe]]]) {
      if (all(d2 == -d)) {
        i <- i + d[1]
        j <- j + d[2]
        break
      }
    }
  }

  # pipe_indices keeps track of where we've been, initialise to a long matrix of NAs
  pipe_indices <- matrix(NA, nrow=length(grid), ncol=2)
  # First two pipes are our Start, and the next randomly chosen one
  pipe_indices[1:2, 1:2] <- matrix(c(start, i, j), nrow=2, byrow=TRUE)
  for (pidx in 3:nrow(pipe_indices)) {
    # Beginning at third pipe (all loops will be at least 4, and have found first two pipes)
    for (d in directions[connections[[grid[i, j]]]]) {
      # Check all valid directions for this pipe
      if (all(c(i + d[1], j + d[2]) == pipe_indices[pidx-2, ])) {
        # Don't go backwards
        next
      }
      # Update current posn, and add to pipes visited
      i <- i + d[1]
      j <- j + d[2]
      pipe_indices[pidx,] <- c(i, j)
      break
    }
    # If have returned to start then done!
    if (grid[i, j] == "S") break
  }

  # Remove excess pipes, NAs and repeated start
  pipe_indices <- na.omit(pipe_indices)
  pipe_indices <- pipe_indices[-nrow(pipe_indices),]
  # Assign a step count to each pipe, e.g. 0 1 2 3 4 5 6 5 4 3 2 1
  distances <- c(seq(0, ceiling(nrow(pipe_indices) / 2)), seq(ceiling(nrow(pipe_indices) / 2) - 1, 1, by=-1))

  # Quick check, create a grid that shows the path walked
  pipe_grid <- matrix(rep(".", length(grid)), nrow=nrow(grid))
  for (idx in seq_len(nrow(pipe_indices))) {
    ij <- pipe_indices[idx,]
    i <- ij[1]
    j <- ij[2]
    pipe_grid[i, j] <- grid[i, j]
  }
  apply(pipe_grid, 1, \(x) paste(x, collapse = "")) |> paste(collapse="\r\n") |> cat()

  return(max(distances))
}


simple_input <- "-L|F7
7S-7|
L|7||
-L-J|
L|-JF"
expected_simple <- 4
input_small <- "7-F7-
.FJ|7
SJLL7
|F--J
LJ.LJ"
expected_small <- 8


testthat::expect_equal(compute(simple_input), expected_simple)
testthat::expect_equal(compute(input_small), expected_small)

input_large <- read_input(here("days/day10"))
print(compute(input_large))

