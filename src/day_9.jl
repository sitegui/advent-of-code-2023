lines = readlines("data/day_9")

parseInt = x -> parse(Int, x)

grand_total = 0
for line in lines
    values = map(parseInt, split(line, ' '))

    all_diffs = [values]
    while true
        diffs = all_diffs[end][2:end] .- all_diffs[end][1:end-1]
        push!(all_diffs, diffs)
        if all(diffs .== 0)
            break
        end
    end

    new_value = 0
    for diffs in all_diffs
        new_value += diffs[end]
    end

    @show values
    @show all_diffs
    @show new_value

    global grand_total += new_value
end

println(grand_total)