using DrWatson, Glob, Revise
@quickactivate
foreach(include, glob("*.jl", srcdir()))

using ProgressMeter, Suppressor, ThreadsX
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
        p[:μ], 
        p[:σ],
        reshape(ϕ, length(p[:μ]), length(p[:σ]))',
        dpi = 500,
        alpha = 1.,
        grid = false,
        xlabel = L"\mu N",
        ylabel = L"\sigma \sqrt{N}",
        c=cgrad(:Reds, rev=true),
        ylims=[.0,.5],
        xlims=[.0,1.25],
    )
#end

#= critical line for gaussian approximation =#
    μ_critical, σ_critical = critical_line_gauss(p, μ_range=(.01:.25:1.26))
    plot!(μ_critical, σ_critical,
    labels = false,
    linewidth = 4,
    linecolor = :black,
    grid = false,
    ylims=[.0,.5],
    xlims=[.01,1.25]
    )

#= critical line =#
    μ_critical, σ_critical = critical_line(p, μ_range=(.05:.2:1.25),
    n_max = 1e2)
    plot!(μ_critical, σ_critical,
    labels = false,
    linewidth = 4,
    linecolor = :black,
    grid = false,
    ylims=[.0,.5],
    xlims=[.01,1.25]
    )