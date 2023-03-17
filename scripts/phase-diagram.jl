using Pkg
Pkg.add("DrWatson")

using DrWatson
@quickactivate
Pkg.instantiate()

using Glob, Revise
foreach(includet, glob("*.jl", srcdir()))

using ProgressMeter, ThreadsX
using Plots, LaTeXStrings
gr(label = false)
using Contour

function plot_contour_line!(plt, ϕ, P; level = 0.9, label)

    c = Contour.contours(
    P[:α], 
    P[:β],
    Matrix(reshape(ϕ, length(P[:α]), length(P[:β]))'),
    [level]
    )
    
    for cl in levels(c)
        # for line in lines(cl)
            plot!(plt, coordinates(lines(cl)[1])..., lw = 2, ls = :dash, label = label)
        # end
    end
    return current()

end

P = Dict{Symbol, Any}(
        :scaled => false,
        :S => 20,
        :μ => .01:.1:2.,
        :σ => .001:.05:.5,
        :k => .75,
        :a => 1,
        :b => 1,
        :b0 => 10.,
        :threshold => false,
        :z => 0.1,
        :K => 10.,
        :order => 2,
        :dist => "normal",
        :N => 4,
        :symm => false,
    );

begin
    ϕ = ThreadsX.collect(diversity!(p) for p in expand(P));

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
current()
savefig(plotsdir("phase-diag"))