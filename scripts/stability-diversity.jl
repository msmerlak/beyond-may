using DrWatson
@quickactivate

using Glob, Revise
foreach(includet, glob("*.jl", srcdir()))

using ProgressMeter, ThreadsX
using Plots, LaTeXStrings

P = Dict{Symbol, Any}(
        :scaled => false,
        :S => 2:5:100,
        :μ => 0.,
        :σ => .1,
        :k => 1.,
        :a => 1,
        :b => 1,
        :b0 => 1.,
        :threshold => false,
        :z => 0.1,
        :K => 1.,
        :order => 4,
        :dist => "normal",
        :N => 2,
        :symm => false,
    );

ϕ = ThreadsX.collect(
    full_coexistence!(p) for p in expand(P)
    );

plot(
    P[:S],
    ϕ
)