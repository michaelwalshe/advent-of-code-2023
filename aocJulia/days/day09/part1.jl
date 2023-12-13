using Chain
using Pipe
using Test

using aocJulia: helpers


function compute(s)
    seqs = @chain s begin
        chomp
        split("\n")
        split.(Ref(" "))
        map(x -> parse.(Int, x), _)
    end

    tot = 0
    for seq in seqs
        while any(seq .!= 0)
            tot += seq[end]
            seq = diff(seq)
        end
    end

    return tot
end


INPUT_S = """0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45"""
EXPECTED = 114

@test compute(INPUT_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))

@time println(compute(INPUT_TXT))
