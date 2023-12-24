lines = readlines("data/day_21")

start = nothing
garden_grid = falses(length(lines[1]), length(lines))
for (j, line) in enumerate(lines)
    for (i, char) in enumerate(line)
        if char == '.'
            garden_grid[i, j] = true
        elseif char == 'S'
            garden_grid[i, j] = true
            global start = CartesianIndex(i, j)
        end
    end
end

@show start

deltas = [
    CartesianIndex(1, 0),
    CartesianIndex(-1, 0),
    CartesianIndex(0, -1),
    CartesianIndex(0, 1),
]

reachable = Set([start])

for steps in 1:64
    @show steps
    @show length(reachable)
    new_reachable = Set()

    for pos in reachable
        for delta in deltas
            if get(garden_grid, pos + delta, false)
                push!(new_reachable, pos + delta)
            end
        end
    end

    global reachable = new_reachable
end

@show length(reachable)