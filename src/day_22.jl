mutable struct Block
    id::Int
    base::CartesianIndex
    size::CartesianIndex
end

# Read input
blocks = []
lines = readlines("data/day_22")
for (id, line) in enumerate(lines)
    base_str, top_str = split(line, '~')
    base_values = map(x -> parse(Int, x), split(base_str, ','))
    top_values = map(x -> parse(Int, x), split(top_str, ','))
    # Note: adding 1 to uses 1-base indexes in Julia
    base = CartesianIndex(base_values...) + CartesianIndex(1, 1, 1)
    top = CartesianIndex(top_values...) + CartesianIndex(1, 1, 1)
    push!(blocks, Block(id, base, top - base))
end
@show size(blocks)

# Iterate each block, starting from the lowest ones (smallest z)
# For each one, find where they will settle
sort!(blocks, by=b -> b.base[3])
max_x = maximum(block.base[1] + block.size[1] for block in blocks)
max_y = maximum(block.base[2] + block.size[2] for block in blocks)
max_z = maximum(block.base[3] + block.size[3] for block in blocks)
@show max_x, max_y, max_z
ground_id = typemax(Int)
settled_ids = zeros(Int, max_x, max_y, max_z)
settled_ids[:, :, 1] .= ground_id
above_blocks_by_block::Dict{Int, Set{Int}} = Dict()
below_blocks_by_block::Dict{Int, Set{Int}} = Dict()

function block_is_resting(block)
    any(settled_ids[
        block.base[1]:block.base[1] + block.size[1],
        block.base[2]:block.base[2] + block.size[2],
        block.base[3] - 1,
    ] .!= 0)
end

function mark_block_as_settled(block)
    settled_ids[
        block.base[1]:block.base[1]+block.size[1],
        block.base[2]:block.base[2]+block.size[2],
        block.base[3]:block.base[3]+block.size[3],
    ] .= block.id

    below_blocks = Set(settled_ids[
        block.base[1]:block.base[1] + block.size[1],
        block.base[2]:block.base[2] + block.size[2],
        block.base[3] - 1,
    ])
    for below_id in below_blocks
        if below_id != 0 && below_id != ground_id
            push!(get!(Set, above_blocks_by_block, below_id), block.id)
        else
            delete!(below_blocks, below_id)
        end
    end
    below_blocks_by_block[block.id] = below_blocks
end

for block in blocks
    # println("starting at $block")
    while !block_is_resting(block)
        block.base -= CartesianIndex(0, 0, 1)
    end

    # println("settled at $block")
    mark_block_as_settled(block)
end

# Detect which blocks can be disintegrated
boom_count = 0
for block in blocks
    above_blocks = get(above_blocks_by_block, block.id, Set())
    can_disintegrate = all(length(below_blocks_by_block[above_block]) > 1 for above_block in above_blocks)
    if can_disintegrate
        println("Can disintegrated $(block.id)")
        global boom_count += 1
    end
end
@show boom_count