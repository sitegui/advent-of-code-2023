#=
day_1:
- Julia version: 1.9.4
- Author: sitegui
- Date: 2023-12-02
=#

file_contents = readlines("data/day_1")
total_value = 0
for row in file_contents
    first_digit = nothing
    last_digit = nothing
    for char in row
        if isdigit(char)
            last_digit = parse(Int, char)

            if first_digit == nothing
                first_digit = parse(Int, char)
            end
        end
    end

    row_value = 10 * first_digit + last_digit
    println(row_value)

    global total_value += row_value
end

println("Total value is: ", total_value)