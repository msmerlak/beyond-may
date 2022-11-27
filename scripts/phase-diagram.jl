using Pkg
Pkg.add("DrWatson")

using DrWatson
@quickactivate

Pkg.instantiate()

using Glob, Revise
foreach(includet, glob("*.jl", srcdir()))

using ProgressMeter, ThreadsX
using Plots, LaTeXStrings

P = Dict{Symbol, Any}(
        :scaled => false,
        :S => 50,
        :μ => .01:.1:2.,
        :σ => .001:.03:.3,
        :k => 1,
        :a => 1,
        :b => 1,
        :b0 => 0.,
        :threshold => false,
        :λ => 0,
        :z => 0,
        :K => 1.,
        :order => 2,
        :dist => "normal",
        :N => 5,
        :symm => false,
    );


begin
    ϕ = ThreadsX.collect(diversity!(p) for p in expand(P));
    a = reshape(ϕ, length(P[:μ]), length(P[:σ]))

    sublinear = heatmap(
        P[:S] * P[:μ], 
        sqrt(P[:S]) * P[:σ],
        a',
        clims = (0,1),
        legend = :none,
        dpi = 500,
        alpha = 1.,
        c = palette([:white, COLOR_LOG49], 100),
        grid = false,
        xlabel = L"\mu S",
        ylabel = L"\sigma \sqrt{S}",
        title = L"\textrm{Stability \,\, in \,\, parameter \,\, space}"
    )
end