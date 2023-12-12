using Chain
using Pipe
using Test

using aocJulia: helpers

const CARD_ORDER = Dict('A' => 13, 'K' => 12, 'Q' => 11, 'T' => 10, '9' => 9, '8' => 8, '7' => 7, '6' => 6, '5' => 5, '4' => 4, '3' => 3, '2' => 2, 'J' => 1)

"""
    Hand(cards, bid)

A hand of cards with a bid. Will compute the value of the hand, higher values are better
Compare two hands using isless(h1, h2)
"""
struct Hand
    cards::AbstractString
    bid::Number
    value::Number

    function Hand(cards::AbstractString, bid::Number)
        new(cards, bid, assign_value(cards))
    end
end

"""
    Base.isless(h1::Hand, h2::Hand)

Compare two hands, if the value is the same, compare the cards individually
"""
function Base.isless(h1::Hand, h2::Hand)
    if h1.value == h2.value
        for (c1, c2) in zip(h1.cards, h2.cards)
            if CARD_ORDER[c1] != CARD_ORDER[c2]
                return CARD_ORDER[c1] < CARD_ORDER[c2]
            end
        end
        return false
    else
        return h1.value < h2.value
    end
end

"""
    assign_value(cards::AbstractString)

Calculate the value of a hand of cards. Higher values are better.
"""
function assign_value(cards::AbstractString)
    card_counts = Dict(i => count(==(i), cards) for i in unique(cards))

    if 'J' in keys(card_counts) && card_counts['J'] != 5
        j_count = pop!(card_counts, 'J')
        card_counts[findmax(card_counts)[2]] += j_count
    end

    n_unique_cards = length(card_counts)
    max_card_count = card_counts[findmax(card_counts)[2]]

    if n_unique_cards == 1
        return 7
    elseif n_unique_cards == 2
        return max_card_count == 4 ? 6 : 5
    elseif n_unique_cards == 3
        return max_card_count == 3 ? 4 : 3
    elseif n_unique_cards == 4
        return 2
    else
        return 1
    end
end

function compute(s)
    hands_bids = split(chomp(s), "\n") .|> split
    hands = first.(hands_bids)
    bids = parse.(Int, last.(hands_bids))

    hands = Hand.(hands, bids)

    tot = 0
    for (i, hand) in enumerate(sort(hands))
        tot += hand.bid * i
    end

    return tot
end


INPUT_S = """32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
"""
EXPECTED = 5905

INPUT_TEST = """
2345A 1
Q2KJJ 13
Q2Q2Q 19
T3T3J 17
T3Q33 11
2345J 3
J345A 2
32T3K 5
T55J5 29
KK677 7
KTJJT 34
QQQJA 31
JJJJJ 37
JAAAA 43
AAAAJ 59
AAAAA 61
2AAAA 23
2JJJJ 53
JJJJ2 41
"""
EXPECTED_TEST = 6839
@test compute(INPUT_S) == EXPECTED
@test compute(INPUT_TEST) == EXPECTED_TEST

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))

@time println(compute(INPUT_TXT))
