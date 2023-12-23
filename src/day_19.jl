struct MyCondition
    category::String
    operator::String
    value::Int
end

struct Rule
    condition::Union{MyCondition, Nothing}
    target::String
end

struct Workflow
    name::String
    rules::Array{Rule}
end

function parse_workflow(line::String)::Workflow
    name, rules_str = match(r"^(\w+)\{(.*)\}$", line)

    rules = []
    for rule_str in split(rules_str, ",")
        condition_str, target = match(r"^(?:(.*):)?(\w+)$", rule_str)
        condition = nothing
        if !isnothing(condition_str)
            category, operator, value_str = match(r"^(.)(.)(\d+)$", condition_str)
            condition = MyCondition(category, operator, parse(Int, value_str))
        end
        push!(rules, Rule(condition, target))
    end

    Workflow(name, rules)
end

function parse_part(line::String)::Dict{String, Int}
    categories_str,  = match(r"^\{(.*)\}$", line)
    part = Dict()
    for name_value_str in split(categories_str, ',')
        name, value_str = match(r"^(.)=(\d+)$", name_value_str)
        part[name] = parse(Int, value_str)
    end
    part
end

function execute(part::Dict{String, Int}, workflow_by_name::Dict{String, Workflow}, name::String)::Bool
    workflow = workflow_by_name[name]

    for rule in workflow.rules
        if isnothing(rule.condition) || check(rule.condition, part)
            if rule.target == "A"
                return true
            elseif rule.target == "R"
                return false
            else
                return execute(part, workflow_by_name, rule.target)
            end
        end
    end
end

function check(condition::MyCondition, part::Dict{String, Int})::Bool 
    part_value = part[condition.category]

    if condition.operator == ">"
        part_value > condition.value
    elseif condition.operator == "<"
        part_value < condition.value
    else
        error("Invalid condition $condition")
    end
end

workflow_by_name::Dict{String, Workflow} = Dict()
parsing_workflows = true
accepted_total = 0
for line in readlines("data/day_19")
    if isempty(line)
        global parsing_workflows = false
        continue
    end

    if parsing_workflows
        @show worflow = parse_workflow(line)
        workflow_by_name[worflow.name] = worflow
    else
        @show part = parse_part(line)
        if execute(part, workflow_by_name, "in")
            @show part_total = sum(values(part))
            global accepted_total += part_total
        end
    end
end

@show accepted_total