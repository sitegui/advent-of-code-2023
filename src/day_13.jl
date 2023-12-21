function check_is_mirror(grid, vertical)
    # `before_range` iterates from the vertical cut towards the first column
    before_range = vertical:-1:1
    after_range = vertical+1:size(grid, 1)

    for (before, after) in zip(before_range, after_range)
        if grid[before, :] != grid[after, :]
            return false
        end
    end

    true
end

function summarize_pattern(lines)
    println("summarize_pattern")
    num_rows = length(lines)
    num_columns = length(lines[1])
    @show num_rows, num_columns
    grid = Matrix{Char}(undef, num_columns, num_rows)
    for (index, line) in enumerate(lines)
        grid[:, index] .= collect(line)
    end

    summary = 0

    for mirror_column in 1:num_columns-1
        if check_is_mirror(grid, mirror_column)
            println("Found vertical mirror at $mirror_column")
            summary += mirror_column
        end
    end

    grid = permutedims(grid)
    for mirror_row in 1:num_rows-1
        if check_is_mirror(grid, mirror_row)
            println("Found horizontal mirror at $mirror_row")
            summary += 100 * mirror_row
        end
    end

    summary
end

lines = readlines("data/day_13")

# >987
# >1051
# <159671
# ?32795
# 34100

summary = 0
pattern_lines = []
for line in lines
    if line == ""
        global summary += summarize_pattern(pattern_lines)
        global pattern_lines = []
    else
        push!(pattern_lines, line)
    end
end

summary += summarize_pattern(pattern_lines)

@show summary