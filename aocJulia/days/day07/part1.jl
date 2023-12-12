using Chain
using Pipe
using Test

using aocJulia: helpers

const CARD_ORDER = Dict('A' => 13, 'K' => 12, 'Q' => 11, 'J' => 10, 'T' => 9, '9' => 8, '8' => 7, '7' => 6, '6' => 5, '5' => 4, '4' => 3, '3' => 2, '2' => 1,)


struct Hand
    cards::AbstractString
    bid::Number
    value::Number

    function Hand(cards::AbstractString, bid::Number)
        new(cards, bid, assign_value(cards))
    end
end

function Base.isless(h1::Hand, h2::Hand)
    if h1.value == h2.value
        for (c1, c2) in zip(h1.cards, h2.cards)
            if CARD_ORDER[c1] != CARD_ORDER[c2]
                return Bool(CARD_ORDER[c1] < CARD_ORDER[c2])
            end
        end
    else
        return Bool(h1.value < h2.value)
    end
end

function assign_value(cards::AbstractString)
    card_counts = [(i, count(==(i), cards)) for i in unique(cards)]
    if length(card_counts) == 1
        return 7
    elseif length(card_counts) == 2
        if maximum(t -> t[2], card_counts) == 4
            return 6
        else
            return 5
        end
    elseif length(card_counts) == 3
        if maximum(t -> t[2], card_counts) == 3
            return 4
        else
            return 3
        end
    elseif length(card_counts) == 4
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
EXPECTED = 6440

@test compute(INPUT_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))

@time println(compute(INPUT_TXT))
