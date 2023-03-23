using DrWatson, Glob, Revise
@quickactivate
foreach(includet, glob("*.jl", srcdir()))

using ProgressMeter, Suppressor, ThreadsX
using Plots, LaTeXStrings

p = Dict{Symbol, Any}(
        :scaled => true,
        :S => 50,
        :μ => .01:.1:1.21,
        :μₛ => true,
        :σ => .01:.1:1.21,
        :α => .5,
        :β => 3.,
        :γ => 1,
        :x0 => .1,
        :threshold => false,
        :dist => "normal",
        :N => 1,
        :symm => false,
        :seed => rand(UInt)
    );

#begin
    ϕ = ThreadsX.collect(diversity!(q) for q in expand(p));

    sublinear = heatmap(
        p[:μ], 
        p[:σ],
        reshape(ϕ, length(p[:μ]), length(p[:σ]))',
        dpi = 500,
        alpha = 1.,
        grid = false,
        xlabel = L"\mu N",
        ylabel = L"\sigma \sqrt{N}",
        c=cgrad(:Greys, rev=true),
        ylims=[.0,.4],
        xlims=[.0,1.2],
    )
#end

#= critical line for gaussian approximation =#
    μ_critical, σ_critical = critical_line_gauss(p, μ_range=(.01:.25:1.26))
    plot!(μ_critical, σ_critical,
    labels = false,
    linewidth = 4,
    linecolor = :red,
    grid = false,
    ylims=[.0,1.2],
    xlims=[.0,1.2],
    yticks = [0, 0.6, 1.2],
    xticks = [0, 0.6, 1.2],
    size = (600,400),
    )

#= critical line =#
    μ_critical, σ_critical = critical_line(p, μ_range=(.01:.2:1.25),
    n_max = 1e1)
    plot!(μ_critical, σ_critical,
    labels = false,
    linewidth = 4,
    linecolor = :green,
    grid = false,
    ylims=[.0,1.2],
    xlims=[.0,1.2],
    yticks = [0, 0.6, 1.2],
    xticks = [0, 0.6, 1.2],
    size = (600,400),
    )