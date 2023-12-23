@enum Pulse Low High

mutable struct FlipFlop
    is_on::Bool
    targets::Array{String}
end

struct Conjunction
    pulse_by_input::Dict{String, Pulse}
    targets::Array{String}
end

struct Broadcast
    targets::Array{String}
end

struct Activation
    pulse::Pulse
    source::String
    target::String
end

mod_by_name = Dict()
for line in readlines("data/day_20")
    kind, name, targets_str = match(r"^([%&])?(\w+) -> (.*)$", line)
    targets = split(targets_str, ", ")
    mod = if isnothing(kind)
        Broadcast(targets)
    elseif kind == "%"
        FlipFlop(false, targets)
    elseif kind == "&"
        Conjunction(Dict(), targets)
    else
        error("Invalid module $line")
    end
    mod_by_name[name] = mod
end

# Remember low for all `Conjunction` inputs
for (name, mod) in mod_by_name
    for target in mod.targets
        target_mod = get(mod_by_name, target, nothing)
        if target_mod isa Conjunction
            target_mod.pulse_by_input[name] = Low
        end
    end
end

next_activations::Array{Activation} = []
low_pulses = 0
high_pulses = 0

function activate(activation::Activation, mod::FlipFlop)
    if activation.pulse == Low
        mod.is_on = !mod.is_on
        pulse = mod.is_on ? High : Low
        chain_activation(activation, pulse, mod.targets)
    end
end

function activate(activation::Activation, mod::Conjunction)
    mod.pulse_by_input[activation.source] = activation.pulse
    pulse = all(pulse == High for pulse in values(mod.pulse_by_input)) ? Low : High
    chain_activation(activation, pulse, mod.targets)
end

function activate(activation::Activation, mod::Broadcast)
    chain_activation(activation, activation.pulse, mod.targets)
end

function chain_activation(source_activation::Activation, pulse::Pulse, targets::Array{String})
    source = source_activation.target
    for target in targets
        push!(next_activations, Activation(pulse, source, target))
    end

    if pulse == Low
        global low_pulses += length(targets)
    else
        global high_pulses += length(targets)
    end
end

function press_button()
    global next_activations = [Activation(Low, "", "broadcaster")]
    global low_pulses = 1
    global high_pulses = 0

    while !isempty(next_activations)
        activation = popfirst!(next_activations)
        mod = get(mod_by_name, activation.target, nothing)
    
        if !isnothing(mod)
            activate(activation, mod)
        end
    end

    (low_pulses, high_pulses)
end

# Return the state for all flip-flops and conjunctions
function get_state()
    state = Dict()
    for (name, mod) in mod_by_name
        if mod isa FlipFlop
            state[name] = mod.is_on
        elseif mod isa Conjunction
            state[name] = Dict(mod.pulse_by_input)
        end
    end
    state
end

# @show get_state()
all_low = 0
all_high = 0
for _ in 1:1000
    x = press_button()
    global all_low += x[1]
    global all_high += x[2]
end
@show all_low, all_high
@show all_low * all_high
# @show get_state()