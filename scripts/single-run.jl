using DrWatson, Glob, Revise
@quickactivate
foreach(includet, glob("*.jl", srcdir()))

using Plots, LaTeXStrings

p = Dict{Symbol, Any}(
    :scaled => false,
    :S => 50,
    :μ => 0.,
    :σ => .1,
    :k => .75,
    :a => 1,
    :b => 1,
    :b0 => .01,
    :threshold => true,
    :z => 0.1,
    :K => 1.,
    :order => 4,
    :dist => "normal",
    :N => 1,
    :symm => false,
    :seed => rand(UInt)
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