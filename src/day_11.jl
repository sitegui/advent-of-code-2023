galaxies = []

populated_i = Set()
populated_j = Set()
for (j, line) in enumerate(readlines("data/day_11"))
    for (i, char) in enumerate(collect(line))
        if char == '#'
            push!(galaxies, CartesianIndex(i, j))
            push!(populated_i, i)
            push!(populated_j, j)
        end
    end
end

@show galaxies
@show populated_i, populated_j

function calculate_shifts(populated)
    shifts = []
    shift = 0
    for i in 1:maximum(populated)
        if !(i in populated)
            shift += 1
        end
        push!(shifts, shift)
    end
    shifts
end

shift_by_i = calculate_shifts(populated_i)
shift_by_j = calculate_shifts(populated_j)
@show shift_by_i
@show shift_by_j

function apply_shift(galaxy)
    shift_i = shift_by_i[galaxy[1]]
    shift_j = shift_by_j[galaxy[2]]
    galaxy + CartesianIndex(shift_i, shift_j)
end

total = 0
for (index, g1) in enumerate(galaxies), g2 in galaxies[index+1:end]
    shifted_g1 = apply_shift(g1)
    shifted_g2 = apply_shift(g2)

    delta_i = shifted_g1[1] - shifted_g2[1]
    delta_j = shifted_g1[2] - shifted_g2[2]
    distance = abs(delta_i) + abs(delta_j)
    global total += distance

    # @show g1, shifted_g1
    # @show g2, shifted_g2
    # @show distance
end

@show total