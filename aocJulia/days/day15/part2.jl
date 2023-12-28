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

struct Lens
    label::String
    value::Int
end

function compute(s)
    boxes = Dict{Int, AbstractVector{Lens}}()
    for instr in split(chomp(s), ",")
        # Parse intruction into label, operation, and value
        if occursin('-', instr)
            label = instr[1:end-1]
            op = '-'
        else
            (label, value) = split(instr, "=")
            value = parse(Int, value)
            op = '='
        end
        
        box = hash(label)
        if op == '-'
            # If we have a box, remove this label if exists
            !haskey(boxes, box) && continue
            boxes[box] = filter(l -> l.label != label, boxes[box])
        else
            # Create new lens to add, if first time then just create vec
            lens = Lens(label, value)
            if !haskey(boxes, box)
                boxes[box] = [lens]
                continue
            end
            # Else, either replace lens in place or add to end of vec
            box_vec = boxes[box]
            nobreak = true
            for i in eachindex(box_vec)
                if box_vec[i].label == label
                    box_vec[i] = lens
                    nobreak = false
                    break
                end
            end
            nobreak && push!(box_vec, lens)
            boxes[box] = box_vec
        end
    end

    tot = 0
    for (box_num, box_vec) in boxes
        for (slot, lens) in enumerate(box_vec)
            tot += (1 + box_num) * slot * lens.value
        end
    end
    return tot
end


INPUT_S = """rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"""
EXPECTED = 145

@test compute(INPUT_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))

@time println(compute(INPUT_TXT))
