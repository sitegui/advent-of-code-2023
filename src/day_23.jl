import DataStructures.PriorityQueue
using DataStructures

lines = readlines("data/day_23")

grid = Matrix{Char}(undef, length(lines[1]), length(lines))
for (index, line) in enumerate(lines)
    grid[:, index] .= collect(line)
end

struct WalkState
    pos::CartesianIndex
    visited::Set{CartesianIndex}
    distance::Int
end

start_col = findfirst(grid[:, 1] .== '.')
end_col = findfirst(grid[:, end] .== '.')
start_state = WalkState(
    CartesianIndex((start_col, 2)),
    Set([CartesianIndex(start_col, 1)]),
    1
)
target = CartesianIndex((end_col, size(grid)[2]))

function walk_to(state::WalkState, next_pos::CartesianIndex)::Pair{WalkState, Int}
    new_visited = copy(state.visited)
    push!(new_visited, next_pos)
    new_state = WalkState(next_pos, new_visited, state.distance + 1)
    new_state => new_state.distance
end

function explore(start_state::WalkState, target::CartesianIndex)::Int
    best = 0
    pending_states = PriorityQueue{WalkState, Int}(Base.Order.Reverse)
    enqueue!(pending_states, start_state, start_state.distance)

    while !isempty(pending_states)
        state = dequeue!(pending_states)
        # @show state.pos, state.distance

        if state.pos == target
            println("Found exit in $(state.distance) steps")
            best = max(best, state.distance)
            continue
        end

        left = state.pos + CartesianIndex((-1, 0))
        right = state.pos + CartesianIndex((1, 0))
        up = state.pos + CartesianIndex((0, -1))
        down = state.pos + CartesianIndex((0, 1))
    
        if (grid[left] == '.' || grid[left] == '<') && !(left in state.visited)
            enqueue!(pending_states, walk_to(state, left))
        end
        if (grid[right] == '.' || grid[right] == '>') && !(right in state.visited)
            enqueue!(pending_states, walk_to(state, right))
        end
        if (grid[up] == '.' || grid[up] == '^') && !(up in state.visited)
            enqueue!(pending_states, walk_to(state, up))
        end
        if (grid[down] == '.' || grid[down] == 'v') && !(down in state.visited)
            enqueue!(pending_states, walk_to(state, down))
        end 
    end

    best
end

@show explore(start_state, target)