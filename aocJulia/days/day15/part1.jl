using Chain
using Pipe
using Test

using aocJulia: helpers

function hash(s)
    v = 0
    for c in s
        v += Int(c)
        v *= 17
        v %= 256
    end
    return v
end

function compute(s)
    return split(chomp(s), ",") .|> hash |> sum
end


INPUT_S = """rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"""
EXPECTED = 1320

@test compute(INPUT_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))

@time println(compute(INPUT_TXT))
