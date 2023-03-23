using DrWatson, Glob, Revise
@quickactivate
foreach(includet, glob("*.jl", srcdir()))

using Plots, LaTeXStrings

p = Dict{Symbol, Any}(
    :scaled => true,
    :S => 100,
    :μ => 0.5,
    :σ => .05,
    :α => .5,
    :β => 1.,
    :γ => 1.,
    :extinction_threshold => 1e-4,
    :dist => "gamma",
    :N => 1,
    :seed => rand(UInt)
);

evolve!(p; trajectory = true);
plot(p[:trajectory], label = false)
p[:converged]
p[:equilibrium]


p[:N] = 10
stability!(p)