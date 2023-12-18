using Test
using Memoize

using aocJulia: helpers


@memoize function number_of_solns(row, counts, curr_count=0)
    # If exhausted row, then check if exhausted counts and no open group
    isempty(row) && return (isempty(counts) & curr_count == 0)
    num_sols = 0
    # If next letter is a "?", we branch
    possible = row[1] == '?' ? ".#" : row[1]
    for c in possible
        if c == '#'
            # Extend current group
            num_sols += number_of_solns(row[2:end], counts, curr_count + 1)
        else
            if curr_count > 0
                # If we were in a group that can be closed, close it
                if !isempty(counts) && counts[1] == curr_count
                    num_sols += number_of_solns(row[2:end], counts[2:end])
                end
            else
                # If we are not in a group, move on to next symbol
                num_sols += number_of_solns(row[2:end], counts)
            end
        end
    end
    return num_sols
end


function compute(s)
    rows = split(chomp(s), '\n')
    valid_combs = 0
    for (row, counts) in map(x -> split(x, ' '), rows)
        counts = parse.(Int, split(counts, ','))
        # Simplify input -- remove all uneccessary groups, add extra dot at the end
        row = replace(row * ".",  r"^\.*" => "", r"\.+" => ".")
        valid_combs += number_of_solns(row, counts)
    end
    return valid_combs
end


INPUT_S = """???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1"""
EXPECTED = 21

@test compute(INPUT_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))

@time println(compute(INPUT_TXT))