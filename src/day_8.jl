using Base.Iterators

lines = readlines("data/day_8")

step_stream = Iterators.Stateful(cycle(lines[1]))

paths = Dict()
for line in lines[3:end]
    name, left, right = match(r"(\w+) = \((\w+), (\w+)\)", line)
    paths[name] = (left, right)
end

num_steps = 0
at = "AAA"
while at != "ZZZ"
    global num_steps += 1
    step = popfirst!(step_stream)
    global at = paths[at][step == 'L' ? 1 : 2]
end

println(paths)
println(num_steps)