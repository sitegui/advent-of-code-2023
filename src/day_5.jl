contents_str = read("data/day_5", String)
contents_str *= "\n\n"

seeds_str, rest_str = match(r"^seeds: ([^\n]*)\n\n(.*)$"s, contents_str)

seeds = map(eachmatch(r"\d+", seeds_str)) do seed
    parse(Int, seed.match)
end

struct MapRange
    start_destination::Int
    start_source::Int
    length::Int
end

old_values = seeds

for map_match in eachmatch(r"\w+-to-\w+ map:\n(.*?)\n\n"s, rest_str)
    ranges = []
    for line in split(map_match[1], '\n')
        integers = map(s -> parse(Int, s), split(line, ' '))
        push!(ranges, MapRange(integers...))
    end
    println(ranges)

    new_values = []
    for value in old_values
        found = false
        for range in ranges
            offset = value - range.start_source

            if 0 <= offset < range.length
                new_value = range.start_destination + offset
                println("Translated $value to $new_value")
                push!(new_values, new_value)
                found = true
            end
        end

        if !found
            push!(new_values, value)
        end
    end
    global old_values = new_values
end

println(old_values)
println(minimum(old_values))