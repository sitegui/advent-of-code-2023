file_contents = readlines("data/day_2")
total_value = 0
for row in file_contents
    game_start = findfirst(": ", row)

    game_name = row[1:game_start[1] - 1]
    game_id = parse(Int, game_name[findlast(' ', game_name):end])

    hands = row[game_start[2] + 1:end]
    game_is_invalid = false
    for hand in split(hands, "; ")
        for cube_color in split(hand, ", ")
            cube, color = split(cube_color, ' ')
            cube = parse(Int, cube)

            if color == "green" && cube > 13
                game_is_invalid = true
            elseif color == "red" && cube > 12
                game_is_invalid = true
            elseif color == "blue" && cube > 14
                game_is_invalid = true
            end
        end
    end

    if !game_is_invalid
        println("Game $game_id is invalid")
        global total_value += game_id
    end
end

println("Total value is: ", total_value)