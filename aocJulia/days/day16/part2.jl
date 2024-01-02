using Chain
using Pipe
using Test

using aocJulia: helpers

struct Beam
    x::Int
    y::Int
    dx::Int
    dy::Int
end

function pos(beam::Beam)
    return (beam.x, beam.y)
end

function dir(beam::Beam)
    return (beam.dx, beam.dy)
end

function move(beam::Beam)
    return Beam(beam.x + beam.dx, beam.y + beam.dy, beam.dx, beam.dy)
end

function reflect(beam::Beam, c::Char)
    if c == '\\'
        return Beam(beam.x, beam.y, beam.dy, beam.dx)
    elseif c == '/'
        return Beam(beam.x, beam.y, -beam.dy, -beam.dx)
    else
        return beam
    end
end

function Base.split(beam::Beam, c::Char)
    if c == '|'
        if dir(beam) ∈ ((1, 0), (-1, 0))
            return [
                Beam(beam.x, beam.y, 0, 1),
                Beam(beam.x, beam.y, 0, -1)
            ]
        else
            return [beam]
        end
    elseif c == '-'
        if dir(beam) ∈ ((0, 1), (0, -1))
            return [
                Beam(beam.x, beam.y, 1, 0),
                Beam(beam.x, beam.y, -1, 0)
            ]
        else
            return [beam]
        end
    else
        return [beam]
    end
end

function compute_1(start_beam, pipes, max_i, max_j)
    energised_tiles = Set{Tuple{Int, Int}}()
    seen_beams = Set{Beam}()

    beams = [start_beam]
    while length(beams) > 0

        beams2 = Vector{Beam}()
        for beam in beams
            push!(energised_tiles, pos(beam))
            push!(seen_beams, beam)
            
            pipe = get(pipes, pos(beam), '.')
            if pipe == '.'
                new_beams = [move(beam)]
            elseif pipe ∈ ('\\', '/')
                new_beams = [move(reflect(beam, pipe))]
            elseif pipe ∈ ('|', '-')
                new_beams = move.(split(beam, pipe))
            end
            
            for new_beam in new_beams
                if new_beam.x > max_j || new_beam.y > max_i || new_beam.x < 1 || new_beam.y < 1
                    continue
                end
                if new_beam ∈ seen_beams
                    continue
                end
                push!(beams2, new_beam)
            end
        end
        beams = beams2
    end

    return length(energised_tiles)
end


function compute(s)
    pipes = Dict{Tuple{Int, Int}, Char}()
    s = chomp(s)
    for (j, line) in split(s, '\n') |> enumerate
        for (i, c) in enumerate(line)
            if c ∈ ('|', '-', '\\', '/')
                pipes[(i, j)] = c
            end
        end
    end

    max_i = length(split(s, '\n'))
    max_j = length((split(s, '\n')[1]))

    energies = Vector{Integer}()

    f = b -> compute_1(b, pipes, max_i, max_j)
    for i in 1:max_i
        push!(energies, f(Beam(i, 1, 0, 1)))
        push!(energies, f(Beam(i, max_j, 0, -1)))
    end
    for j in 1:max_j
        push!(energies, f(Beam(1, j, 1, 0)))
        push!(energies, f(Beam(max_i, j, -1, 0)))
    end

    return maximum(energies)
end

INPUT_S = r""".|...\....
|.-.\.....
.....|-...
........|.
..........
.........\
..../.\\..
.-.-/..|..
.|....-|.\
..//.|....""".pattern
EXPECTED = 51



@test compute(INPUT_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))

@time println(compute(INPUT_TXT))
