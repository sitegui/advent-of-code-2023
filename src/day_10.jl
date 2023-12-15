lines = readlines("data/day_10")

maze = Array{Char}(undef, length(lines[1]), length(lines))

for (i, line) in enumerate(lines)
    maze[:, i] .= collect(line)
end

@show maze

struct Walk
    current
    last_step
end

function calculate_next_position(walk::Walk) :: Walk
    current_char = maze[walk.current]
    
    if current_char == '|'
        steps_in = [CartesianIndex(0, 1), CartesianIndex(0, -1)]
    elseif current_char == '-'
        steps_in = [CartesianIndex(1, 0), CartesianIndex(-1, 0)]
    elseif current_char == 'L'
        steps_in = [CartesianIndex(0, 1), CartesianIndex(-1, 0)]
    elseif current_char == 'J'
        steps_in = [CartesianIndex(0, 1), CartesianIndex(1, 0)]
    elseif current_char == '7'
        steps_in = [CartesianIndex(0, -1), CartesianIndex(1, 0)]
    elseif current_char == 'F'
        steps_in = [CartesianIndex(0, -1), CartesianIndex(-1, 0)]
    end
    # @show steps_in

    if walk.last_step == steps_in[1]
        next_step = CartesianIndex(-steps_in[2][1], -steps_in[2][2])
    elseif walk.last_step == steps_in[2]
        next_step = CartesianIndex(-steps_in[1][1], -steps_in[1][2])
    end
    # @show next_step

    Walk(walk.current + next_step, next_step)

end

start = findfirst(maze .== 'S')

possible_start_steps = [
    (CartesianIndex(1, 0), '-', 'J', '7'),
    (CartesianIndex(-1, 0), '-', 'L', 'F'),
    (CartesianIndex(0, 1), '|', 'J', 'L'),
    (CartesianIndex(0, -1), '|', '7', 'F'),
]

animals = []
for (next_step, valid_char_1, valid_char_2, valid_char_3) in possible_start_steps
    local next_position = start + next_step

    if checkbounds(Bool, maze, next_position)
        char = maze[next_position]
        if char == valid_char_1 || char == valid_char_2 || char == valid_char_3
            push!(animals, Walk(next_position, next_step))
        end
    end
end

animal_1 = animals[1]
animal_2 = animals[2]

@show animal_1
@show animal_2

visited_animal_1 = Set()
num_steps = 0
while true
    push!(visited_animal_1, animal_1.current)
    global num_steps += 1

    global animal_1 = calculate_next_position(animal_1)
    global animal_2 = calculate_next_position(animal_2)

    @show animal_1
    @show animal_2

    if animal_2.current in visited_animal_1
        break
    end
end

@show num_steps
