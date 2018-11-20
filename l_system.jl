module L_System

using DataStructures, PyPlot

struct System
    start::String
    rules::Dict{Char,String}
    d_vars::Array{Char,1}
    d_opt::Dict{Char,String}
    a_inc_vars::Array{Char,1}
    a_dec_vars::Array{Char,1}
    a_inc::Float64
    a_dec::Float64
    s_app_vars::Array{Char,1}
    s_pop_vars::Array{Char,1}
end

function generate_sequence(rules::Dict{Char,String}, sequence::String, N::Int64=3)
    for i in 1:N
        new_sequence = ""
        for c in sequence
            new_sequence *= rules[c]
        end
        sequence = new_sequence
    end

    return sequence
end

function plot_system(system::System, sequence::String; x_org::Float64=1.0, y_org::Float64=0.0, l::Float64=1.0, a::Float64=90.0)
    stack = Stack{NTuple{4,Float64}}()
    fig = figure()
    for c in sequence
        if c in system.d_vars
            x = x_org + l * cos(a*pi / 180)
            y = y_org + l * sin(a*pi / 180)
            plot([x_org, x], [y_org, y], system.d_opt[c])
            x_org = x
            y_org = y
        end
        if c in system.s_app_vars
            push!(stack, (x_org, y_org, l, a))
        end
        if c in system.s_pop_vars
            x_org, y_org, l, a = pop!(stack)
        end
        if c in system.a_inc_vars
            a += system.a_inc
        end
        if c in system.a_dec_vars
            a -= system.a_dec
        end
    end

    axis("equal")
    axis("off")
    return fig
end

plant_system = System("X", Dict(('X'=>"F+[[X]-X]-F[-FX]+X"), ('F'=>"FF"), ('['=>"["), (']'=>"]"), ('+'=>"+"), ('-'=>"-")), ['F'], Dict(('F'=>"g-")), ['+'], ['-'], 25.0, 25.0, ['['], [']'])
plant_sequence = generate_sequence(plant_system.rules, plant_system.start, 5)
plant_fig = plot_system(plant_system, plant_sequence)
savefig("plots/plant.png")

tree_system = System("0", Dict(('0'=>"1[0]0"), ('1'=>"11"), ('['=>"["), (']'=>"]")), ['0', '1'], Dict(('0'=>"r-"), ('1'=>"g-")), ['['], [']'], 45.0, 45.0, ['['], [']'])
tree_sequence = generate_sequence(tree_system.rules, tree_system.start, 10)
tree_fig = plot_system(tree_system, tree_sequence)
savefig("plots/tree.png")

show()

end