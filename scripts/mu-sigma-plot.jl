using DrWatson; @quickactivate

using Revise, Glob
foreach(includet, glob("*.jl", srcdir()))

using DelimitedFiles
using Plots, LaTeXStrings

dist = "normal"
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


Φ = readdlm(datadir("mu-sigma-gamma.csv"), ',')
sublinear = heatmap(
        P[:μ],
        P[:σ],
        Φ,
        dpi=500,
        grid=false,
        xlabel=L"\mu N",
        ylabel=L"\sigma \sqrt{N}",
        #c=cgrad(:Greys, rev=true)
    )

begin
    Φ = readdlm(datadir("mu-sigma-normal.csv"), ',')
    sublinear = heatmap(
        P[:μ],
        P[:σ],
        Φ,
        dpi=500,
        grid=false,
        xlabel=L"\mu N",
        ylabel=L"\sigma \sqrt{N}",
        #c=cgrad(:Greys, rev=true)
    )
end

    #= critical line for gaussian approximation =#
    μ_critical, σ_critical = critical_line_gauss(P, μ_range=(0.01:0.25:1.26))
    plot!(μ_critical, σ_critical,
        labels=false,
        linewidth=4,
        linecolor=:red,
        grid=false,
        yticks=[0, 0.6, 1.2],
        xticks=[0, 0.6, 1.2],
        size=(600, 400),
    )

    #= critical line =#
    μ_critical, σ_critical = critical_line(P, μ_range=(0.01:0.2:1.25),
        n_max=1e1)
    plot!(μ_critical, σ_critical,
        labels=false,
        linewidth=4,
        linecolor=:green,
        grid=false,
        ylims=[0.0, 1.2],
        xlims=[0.0, 1.2],
        yticks=[0, 0.6, 1.2],
        xticks=[0, 0.6, 1.2],
        size=(600, 400),
    )
    savefig(plotsdir("mu-sigma-$dist"))
end