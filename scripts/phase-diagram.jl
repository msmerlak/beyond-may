using Pkg
Pkg.add("DrWatson")

using DrWatson
@quickactivate

Pkg.instantiate()

using Glob, Revise
foreach(includet, glob("*.jl", srcdir()))

using ThreadsX
using Plots, LaTeXStrings

P = Dict{Symbol, Any}(
    :scaled => true,
    :S => 100,
    :μ => .01:.1:1.,
    :σ => .01:.1:1.,
    :α => .5,
    :β => 1.,
    :γ => 1.,
    :extinction_threshold => 1e-4,
    :dist => "gamma",
    :N => 5,
    :seed => rand(UInt)
);

begin
    ϕ = ThreadsX.collect(stability!(p) for p in expand(P));

    sublinear = heatmap(
        P[:μ], 
        P[:σ],
        reshape(ϕ, length(P[:μ]), length(P[:σ]))',
        dpi = 500,
        alpha = 1.,
        grid = false,
        xlabel = L"\mu",
        ylabel = L"\sigma",
        title = L"\textrm{Stability \,\, in \,\, parameter \,\, space}"
    )
end
