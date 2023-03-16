using DrWatson, Glob, Revise
@quickactivate
foreach(includet, glob("*.jl", srcdir()))

using Plots, LaTeXStrings

p = Dict{Symbol, Any}(
    :scaled => false,    
    :S => 100,
    :μ => 0.1,
    :σ => 0.05,
    :α => .7,
    :β => 1.2,
    :γ => 1.,
    :extinction_threshold => 1e-2,
    :z => 0.,
    :K => 1e4,
    :dist => "normal",
    :N => 10,
    # :symm => false,
    :seed => rand(UInt)
);

@time diversity!(p)

evolve!(p; trajectory = true);

#trajectories
plot(
    p[:trajectory],
    ylabel = L"B_i(t)",
    xlabel = L"t",
    linewidth = 1,
    legend = false,
    grid = false,
    palette = :blues,
    # yaxis = :log
)
