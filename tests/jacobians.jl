using Test
using DrWatson, Glob, Revise
@quickactivate
foreach(includet, glob("*.jl", srcdir()))

p = Dict{Symbol, Any}(
    :scaled => false,    
    :S => 10,
    :μ => 1e-3,
    :μₛ => 1e-4,
    :σ => 0.05,
    :α => .5,
    :β => 1.,
    :γ => 1.,
    :extinction_threshold => 1e-2,
    :z => 0.,
    :dist => "gamma",
    :N => 1,
    :seed => rand(UInt)
);

evolve!(p; trajectory = false);
@test J_analytical(p) ≈ J_numerical(p) atol=1e-3