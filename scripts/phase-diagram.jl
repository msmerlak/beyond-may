using Pkg
Pkg.add("DrWatson")

using DrWatson
@quickactivate

Pkg.instantiate()

using Glob, Revise
foreach(includet, glob("*.jl", srcdir()))

using ProgressMeter, ThreadsX
using Plots, LaTeXStrings

P = Dict{Symbol,Any}(
    :scaled => false,
    :S => 100,
    :μ => 0.01,
    :σ => 0.0001, 
    :α => 0.5:0.1:1.5, 
    :β => 0.5:0.1:1.5, 
    :γ => 1.0, 
    :b0 => 1.0, 
    :threshold => false, 
    :z => 0.0,
    :K => 0.001,
    :order => 2,
    :dist => "normal",
    :N => 10,
    :symm => false,
);
ϕ = ThreadsX.collect(diversity!(p) for p in expand(P));

sublinear = heatmap(P[:α], P[:β], reshape(ϕ, length(P[:α]), length(P[:β]))', dpi=500, alpha=1.0, grid=false,
    xlabel=L"\alpha",
    ylabel=L"\beta",
    title=L"\textrm{Stability \,\, in \,\, parameter \,\, space}"
)
plot!(
    x -> x
)

