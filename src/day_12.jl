"""
Can ???????????????????? match 3,3,1 :
20? <> 0+. 3# 1+. 3# 1+. 1# 0+.
the sum of all sections must be 20

sizes can be described as [a, 3, b, 3, c, 1, d]
where: a, d >= 0 and b, c >= 1

also, a + b + c + d + 7 = 20 => a + b + c + d = 13

if we iterate in sequence a, b, c, d, we can write these constraints:
- a in 0:(20 - 3-3-1 - 1-1)
- b in 1:(20-a-3 - -3-1 -1)
- c in 1:(20-a-3-b-3 -1)
- d = 13 - a - b - c

L = 20
Q = 7
L - Q = 13
????????????????????
...........###.###.# max a = 11
###............###.# max b = 12, when a = 0
.###...........###.# max b = 11, when a = 1
###.###............# max c = 12, when a = 0, b = 1
###.###.#........... max d = 11, when a = 0, b = 1, c = 1

In general, for a given list of runs R = [r_1 r_2 ... r_n] and total length L,
we have a "reservation" of Q = r_1+r_2+...+r_n `#` chars.

This means that the first gap g_1 is constrained in 0:(L-Q-n+1)
The second gap g_2 is constrained in 1:(L-Q-n+2-g_1)
The third gap g_3 is constrained in 1:(L-Q-n+3-g_1-g_2)
... and so on, until
The last gap g_n+1 is in fact equal to L - Q - g_1-g_2-...-g_n

The pattern is, for i < n:
min{g_i} = i == 1 ? 0 : 1
max{g_i} = L - Q - n + i - sum(g_[1:i-1])
"""

function iterate_gaps(fn, num_springs, runs)
    # The amount of reserved `#` and `.` chars
    n = length(runs)
    reserved = sum(runs)

    # Prepare the iterators for the gaps (except the last one, whose value is a function of the others)
    gap_iterators = []
    acc_gap = 0
    for (index, _) in enumerate(runs)
        min_value = index == 1 ? 0 : 1
        max_value = num_springs - reserved - n + index - acc_gap
        push!(gap_iterators, Iterators.Stateful(min_value:max_value))
        acc_gap += min_value
    end

    while true
        # Current iteration
        gaps = [(peek(iter) for iter in gap_iterators)..., 0]
        gaps[end] = num_springs - reserved - sum(gaps)
        fn(gaps)
        
        # Prepare next iteration, by advancing the right-most non-exhausted iterator
        advanced = false
        for gap_i in n:-1:1
            first(gap_iterators[gap_i])
            if !isempty(gap_iterators[gap_i])
                # Write new iterators for gaps after that
                acc_gap = sum(peek(iter) for iter in gap_iterators[1:gap_i])
                for gap_j in (gap_i+1):n
                    min_value = gap_j == 1 ? 0 : 1
                    max_value = num_springs - reserved - n + gap_j - acc_gap
                    gap_iterators[gap_j] = Iterators.Stateful(min_value:max_value)
                    acc_gap += min_value
                end

                advanced = true
                break
            end
        end

        if !advanced
            break
        end
    end
end

function check_gaps_are_possible(springs::AbstractString, gaps::Vector{Int}, runs::Vector{Int})::Bool
    acc = 1
    for (gap, run) in zip(gaps, runs)
        gap_candidate_str = springs[acc:acc+gap-1]
        acc += gap
        if contains(gap_candidate_str, '#')
            # println("failed because $gap_candidate_str is not a gap")
            return false
        end

        run_candidate_str = springs[acc:acc+run-1]
        acc += run
        if contains(run_candidate_str, '.')
            # println("failed because $run_candidate_str is not a run")
            return false
        end
    end

    gap_candidate_str = springs[acc:end]
    if contains(gap_candidate_str, '#')
        # println("failed because $gap_candidate_str is not a run")
        return false
    end

    true
end

lines = readlines("data/day_12")

total_possible = 0
for line in lines
    springs, runs_str = split(line, ' ')
    runs = map(split(runs_str, ',')) do run
        parse(Int, run)
    end
    @show springs, runs

    num_possible = 0
    iterate_gaps(length(springs), runs) do gaps
        # @show gaps

        if check_gaps_are_possible(springs, gaps, runs)
            num_possible += 1
            # println("is possible!")
        end
    end

    @show num_possible
    global total_possible += num_possible
end

@show total_possible

