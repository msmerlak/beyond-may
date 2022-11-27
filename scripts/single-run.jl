using DrWatson, Glob, Revise
@quickactivate
foreach(includet, glob("*.jl", srcdir()))

using Plots, LaTeXStrings

p = Dict{Symbol, Any}(
    :scaled => false,
    :S => 50,
    :μ => .8,
    :σ => .05,
    :k => 1,
    :a => 1,
    :b => 1,
    :b0 => 0.,
    :threshold => false,
    :λ => 0,
    :z => 0,
    :K => .3,
    :order => 2,
    :dist => "normal",
    :N => 5,
    :symm => false,
    :seed => 1
);

evolve!(p; trajectory = true);

#trajectories
plot(
    p[:trajectory],
    ylabel = L"B_i(t)",
    xlabel = L"t",
    linewidth = 1,
    legend = false,
    grid = false,
    palette = :blues
)