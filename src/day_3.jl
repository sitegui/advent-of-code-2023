filename = "data/day_3"

bytes_content = read(filename)
width = findfirst(c -> c == UInt8('\n'), bytes_content)
println(size(bytes_content))
println(width)
println(bytes2hex(UInt8('.')))
bytes_grid = reshape(bytes_content, (width, :))
println(size(bytes_grid))
# println(bytes_grid)

string_content = read(filename, String)

function is_symbol(c)
    # println("Check is_symbol for $c")
    !((c >= UInt8('0') && c <= UInt8('9')) || c == UInt8('.') || c == UInt8('\n'))
end

function is_symbol(grid, pos)
    # println("Check is_symbol at $pos")

    checkbounds(Bool, grid, pos) && is_symbol(grid[pos])
end

function has_symbol_near(grid, start, length)
    x = CartesianIndex((1, 0))
    y = CartesianIndex((0, 1))

    if is_symbol(grid, start - x)
        return true
    end

    if is_symbol(grid, start + x * length)
        return true
    end

    for k = -1:length
        if is_symbol(grid, start + x * k + y) || is_symbol(grid, start + x * k - y)
            return true
        end
    end

    return false
end

total = 0
for match in eachmatch(r"[0-9]+", string_content)
    match_start = CartesianIndex((match.offset % width, match.offset ÷ width + 1))

    # println(match.offset, match_start, length(match.match), match)
    if has_symbol_near(bytes_grid, match_start, length(match.match))
        global total += parse(Int, match.match)
        println("$match is a part number in $match_start")
    end
end

println(total)