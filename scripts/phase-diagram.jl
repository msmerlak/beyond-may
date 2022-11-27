using Pkg
Pkg.add("DrWatson")

using DrWatson
@quickactivate

Pkg.instantiate()

using Glob
foreach(include, glob("*.jl", srcdir()))


using ProgressMeter, ThreadsX
using Plots, LaTeXStrings, DelimitedFiles

P = Dict{Symbol, Any}(
        :scaled => true,
        :S => 1000,
        :μ => .01:.01:1.2,
        :σ => .001:.001:.12,
        :k => .75,
        :b0 => 1.,
        :λ => 0,
        :z => 0,
        :K => 1e10,
        :threshold => false,
        :dist => "gamma",
        #:dist_r => Uniform(.01,1),
        :N => 1,
        :symm => false,
    );

# full coexistence

ϕ = ThreadsX.collect(full_coexistence(p) for p in expand(P));
a = reshape(ϕ, length(P[:μ]), length(P[:σ]))

sublinear = heatmap(
    P[:μ], 
    P[:σ],
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

## time averaged diversity

ϕ = ThreadsX.collect(time_avg_diversity(p) for p in expand(P));
a = reshape(ϕ, length(P[:μ]), length(P[:σ]))

sublinear = heatmap(
    P[:μ], 
    P[:σ],
    a',
    clims = (0,1),
    legend = :none,
    dpi = 500,
    alpha = 1.,
    c = palette([:white, COLOR_LOG49], 100),
    grid = false,
    xlabel = L"\mu S ",
    ylabel = L"\sigma\sqrt{S}",
    title = "time-averaged Shannon diversity"
)