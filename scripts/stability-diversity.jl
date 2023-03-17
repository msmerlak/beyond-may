using DrWatson
@quickactivate

using Glob, Revise
foreach(includet, glob("*.jl", srcdir()))

using ProgressMeter, ThreadsX
using Plots, LaTeXStrings

P = Dict{Symbol, Any}(
        :scaled => false,
        :S => 2:5:100,
        :μ => 0.1,
        :σ => .05,
        :α => .7,
        :β => 1,
        :γ => 1,
        :extinction_threshold => 1e-2,
        :z => 0.,
        :K => 1e4,
        :dist => "normal",
        :N => 2,
        # :symm => false,
    );

ϕ = ThreadsX.collect(
    diversity!(p) for p in expand(P)
    );

plot(
    P[:S],
    ϕ
)