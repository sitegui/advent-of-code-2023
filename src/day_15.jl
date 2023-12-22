function hash(text)
    h = 0
    for c in text
        h = mod((h + Int(c)) * 17, 256)
    end
    h
end

values = split(readlines("data/day_15")[1], ',')

total = 0
for value in values
    hashed = hash(value)
    @show hashed
    global total += hashed
end

@show total