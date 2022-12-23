using Pkg
Pkg.add("DrWatson")

using DrWatson
@quickactivate

Pkg.instantiate()

using Glob, Revise
foreach(includet, glob("*.jl", srcdir()))

using ProgressMeter, ThreadsX
using Plots, LaTeXStrings
using Contour

function plot_contour_line!(plt, P; label, level = .5)
    
    c = Contour.contours(
    P[:α], 
    P[:β],
    Matrix(reshape(ϕ, length(P[:α]), length(P[:β]))'),
    [level]
    )
    
    for cl in levels(c)
        for line in lines(cl)
            plot!(plt, coordinates(line)...,
            label = label)
        end
    end
    return current()

end

P = Dict{Symbol, Any}(
        :scaled => false,
        :S => 100,
        :μ => .1,
        :σ => .1,
        :α => 0:.1:1.5,
        :β => 0:.1:1.5,
        :γ => 1,
        :b0 => 1e-2,
        :threshold => true,
        :z => 0.,
        :K => 1000.,
        :order => 2,
        :dist => "normal",
        :N => 10,
        :symm => false,
    );

plt = plot()
for σ ∈ .01:.02:.1
    P[:σ] = σ
    ϕ = ThreadsX.collect(diversity!(p) for p in expand(P));
    plot_contour_line!(plt, P; label = "σ = $(P[:σ])")
end
current()
savefig(plotsdir("phase-diag"))