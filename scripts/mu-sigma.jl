using DrWatson
@quickactivate

using Glob, Revise
foreach(includet, glob("*.jl", srcdir()))

using ThreadsX
using Plots, LaTeXStrings
using DelimitedFiles

for dist in ("normal", "gamma")
    P = Dict{Symbol,Any}(
        :scaled => true,
        :S => 100,
        :μ => 0.01:0.02:1.0,
        :σ => 0.01:0.02:0.4,
        :α => 0.5,
        :β => 1.0,
        :γ => 1.0,
        :extinction_threshold => 1e-4,
        :dist => dist,
        :N => 100,
        :seed => rand(UInt)
    )


    ϕ = ThreadsX.collect(stability!(p) for p in expand(P))
    Φ = reshape(ϕ, length(P[:μ]), length(P[:σ]))'
    writedlm(datadir("mu-sigma-$dist.csv"), Φ, ',')

end
