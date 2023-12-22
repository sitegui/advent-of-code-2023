import DataStructures.PriorityQueue
using DataStructures
using Printf

lines = readlines("data/day_17")

heat_grid = Matrix{Int}(undef, length(lines[1]), length(lines))
for (index, line) in enumerate(lines)
    heat_grid[:, index] .= map(collect(line)) do x parse(Int, x) end
end

@enum Direction Right=1 Down Left Up

function advance(pos, dir)
    if dir == Right
        pos + CartesianIndex(1, 0)
    elseif dir == Down
        pos + CartesianIndex(0, 1)
    elseif dir == Left
        pos + CartesianIndex(-1, 0)
    elseif dir == Up
        pos + CartesianIndex(0, -1)
    end
end

turn_right = Dict(
    Right => Down,
    Down => Left,
    Left => Up,
    Up => Right,
)

turn_left = Dict(
    Right => Up,
    Down => Right,
    Left => Down,
    Up => Left,
)

const MAX_STRAIGHT_STEPS = 3

struct State
    pos::CartesianIndex
    straight_steps::Int
    dir::Direction
end

Base.show(io::IO, state::State) = @printf(io, "(%s, %s) %s * %s", state.pos[1], state.pos[2], state.straight_steps, state.dir)

pending_states = PriorityQueue{State, Int}()
initial_state = State(CartesianIndex(1, 1), 1, Right)
lowest_heat_so_far = Dict(initial_state => 0)
enqueue!(pending_states, initial_state, 0)
target = CartesianIndex(size(heat_grid))

iter = 0
while !isempty(pending_states)
    state = dequeue!(pending_states)
    # @show state
    # @show lowest_heat_so_far[state]

    global iter += 1
    if iter == 10
        # break
    end

    if state.pos == target
        @show lowest_heat_so_far[state]
        break
    end

    neighbors = []
    if state.straight_steps < MAX_STRAIGHT_STEPS
        state_straight = State(advance(state.pos, state.dir), state.straight_steps + 1, state.dir)
        push!(neighbors, state_straight)
    end
    turned_right = turn_right[state.dir]
    push!(neighbors, State(advance(state.pos, turned_right), 1, turned_right))
    turned_left = turn_left[state.dir]
    push!(neighbors, State(advance(state.pos, turned_left), 1, turned_left))

    for neighbor in neighbors
        # @show neighbor
        if !checkbounds(Bool, heat_grid, neighbor.pos)
            # println("out of bounds")
            continue
        end

        new_heat = lowest_heat_so_far[state] + heat_grid[neighbor.pos]
        if new_heat < get!(lowest_heat_so_far, neighbor, typemax(Int))
            lowest_heat_so_far[neighbor] = new_heat
            pending_states[neighbor] = new_heat
        end
    end
end
