using Chain
using Test

using aocJulia: helpers


function compute(s)
    lines = split(chomp(s), "\n")
    cards = zeros(Int, length(lines), 2)
    for (i, line) in enumerate(lines)
        winning_numbers, my_numbers = @chain begin
            split(line, ":")[2] # Split into Card ID and lottery numbers
            split("|") # Split into two vectors, winning and mine
            split.() # Split by whitespace, parse as integers
            map(v -> parse.(Int, v), _)
        end
        n_wins = length(intersect(winning_numbers, my_numbers))
        # save n_wins plus number of copies into matrix
        cards[i, :] = [n_wins, 1]
    end

    # For each card, keeping track of card ID
    for (i, (n_wins, n_copies)) in enumerate(eachrow(cards))
        # Repeat for each copy of the card we have
        for _ in 1:n_copies
            # Increment the number of copies for the next
            # n_wins cards
            for n in 1:n_wins
                cards[i + n, 2] += 1
            end
        end
    end

    return sum(cards[:, 2])
end


INPUT_S = """Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
"""

EXPECTED = 30

@test compute(INPUT_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))

@time println(compute(INPUT_TXT))
