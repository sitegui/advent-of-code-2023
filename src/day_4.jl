function parse_ints(text)
    ints = Set()

    for match in eachmatch(r"[0-9]+", text)
        push!(ints, parse(Int, match.match))
    end

    ints
end

total = 0
for row in readlines("data/day_4")
    start_index = findfirst(':', row)
    split_index = findfirst('|', row)

    winning_numbers = parse_ints(row[start_index:split_index])
    my_numbers = parse_ints(row[split_index:end])
    number_score = length(intersect(winning_numbers, my_numbers))

    score = number_score > 0 ? 2 ^ (number_score - 1) : 0

    global total += score
end

println(total)