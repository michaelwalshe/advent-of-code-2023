using Chain
using Pipe
using Test

using aocJulia: helpers


function compute(s)
    return parse.(Int, split(s))
end


INPUT_S = """

"""
EXPECTED = 0

@test compute(INPUT_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))

@time println(compute(INPUT_TXT))
