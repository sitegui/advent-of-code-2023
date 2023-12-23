n = 800
grid = falses(n, n)

pos = CartesianIndex(n ÷ 2, n ÷ 2)
grid[pos] = true

dir_to_delta = Dict(
    "R" => CartesianIndex(1, 0),
    "L" => CartesianIndex(-1, 0),
    "U" => CartesianIndex(0, -1),
    "D" => CartesianIndex(0, 1),
)

for line in readlines("data/day_18")
    dir_str, steps_str = match(r"^(.) (\d+)", line)
    steps = parse(Int, steps_str)
    dir = dir_to_delta[dir_str]

    for _ in 1:steps
        global pos += dir
        grid[pos] = true
    end
end

interior = CartesianIndex(n ÷ 2, 1)
crossed_walls = 0
while true
    if grid[interior]
        global crossed_walls += 1
    end

    global interior += CartesianIndex(0, 1)

    if !grid[interior] && crossed_walls % 2 == 1
        break
    end
end

function print_zoom(center, size=20)
    center_i, center_j = (center[1], center[2])
    min_i = max(center_i - size, 1)
    min_j = max(center_j - size, 1)
    max_i = min(center_i + size, n)
    max_j = min(center_j + size, n)
    for j in min_j:max_j
        row = map(grid[min_i:max_i, j]) do c c ? '#' : '.' end
        println(join(row, ""))
    end
end

# print_zoom(interior, n)

@show interior
@show sum(grid)

places_to_fill = [interior]
grid[interior] = true
new_places_to_fill = []

while !isempty(places_to_fill)
    # @show length(places_to_fill)
    global new_places_to_fill = []

    for place in places_to_fill
        for delta in values(dir_to_delta)
            new_place = place + delta

            if !checkbounds(Bool, grid, new_place)
                print_zoom(new_place, 100)
            end

            if !grid[new_place]
                grid[new_place] = true
                push!(new_places_to_fill, new_place)
            end
        end
    end

    global places_to_fill = new_places_to_fill
end

@show sum(grid)