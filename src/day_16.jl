lines = readlines("data/day_16")

grid = Matrix{Char}(undef, length(lines[1]), length(lines))
for (index, line) in enumerate(lines)
    grid[:, index] .= collect(line)
end

@enum Direction Right=1 Down Left Up

# `true` where there is a light in a given direction
light_beans = falses(size(grid)..., 4)

function apply_beam(grid, light_beans, pos, dir, level=0)
    prefix = repeat("  ", level)
    while true
        char = get(grid, pos, nothing)
        # println("$(prefix)At $pos+$dir, char=$char")
        if isnothing(char)
            # Out of bounds
            return
        end

        if light_beans[pos, Int(dir)]
            # Already considered
            # println("$(prefix)Stop because already considered")
            return
        end
        light_beans[pos, Int(dir)] = true

        if char == '/'
            dir = Dict(
                Right => Up,
                Down => Left,
                Left => Down,
                Up => Right,
            )[dir]
        elseif char == '\\'
            dir = Dict(
                Right => Down,
                Down => Right,
                Left => Up,
                Up => Left,
            )[dir]
        elseif char == '-' && (dir == Up || dir == Down)
            dir = Right
            apply_beam(grid, light_beans, advance(pos, Left), Left, level+1)
        elseif char == '|' && (dir == Right || dir == Left)
            dir = Up
            apply_beam(grid, light_beans, advance(pos, Down), Down, level+1)
        end

        pos = advance(pos, dir)
    end
end

function advance(pos, dir)
    if dir == Right
        pos + CartesianIndex(1, 0)
    elseif dir == Down
        pos + CartesianIndex(0, 1)
    elseif dir == Left
        pos + CartesianIndex(-1, 0)
    elseif dir == Up
        pos + CartesianIndex(0, -1)
    end
end

apply_beam(grid, light_beans, CartesianIndex(1, 1), Right)

is_energized = reduce(light_beans, dims=3, init=false) do a, b
    a || b
end

@show sum(is_energized)