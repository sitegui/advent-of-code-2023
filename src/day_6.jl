parseInt(s) = parse(Int, s)

lines = readlines("data/day_6")
times = map(parseInt, split(lines[1], r"\s+")[2:end])
distance_records = map(parseInt, split(lines[2], r"\s+")[2:end])

println(times)
println(distance_records)

function total_distance(press_time, total_time)
    speed = press_time
    (total_time - press_time) * speed
end

answer = 1
for (time, record) in zip(times, distance_records)
    possible_ways_to_beat = 0
    for press_time in 0:time
        if total_distance(press_time, time) > record
            possible_ways_to_beat += 1
        end
    end

    println(possible_ways_to_beat)
    global answer *= possible_ways_to_beat
end

print(answer)