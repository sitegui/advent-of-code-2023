function compact(items)
    for start_roll in 1:length(items)
        if items[start_roll] == 'O'
            for rolling in start_roll-1:-1:1
                if items[rolling] == '.'
                    items[rolling], items[rolling+1] = items[rolling+1], items[rolling]
                else
                    break
                end
            end
        end
    end
end

lines = readlines("data/day_14")

grid = Matrix{Char}(undef, length(lines[1]), length(lines))
for (index, line) in enumerate(lines)
    grid[:, index] .= collect(line)
end

total_load = 0
for column_i in 1:size(grid, 1)
    column = grid[column_i, :]
    compact(column)

    for (index, char) in enumerate(column)
        if char == 'O'
            global total_load += length(column) - index + 1
        end
    end
end

@show total_load