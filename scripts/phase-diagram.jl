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

function plot_contour_line!(plt, ϕ, P; label, level = .5)
    
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
        :S => 20,
        :μ => 1e-2,
        :σ => 1e-6,
        :α => 0.1:.1:1.5,
        :β => 0.1:.1:1.5,
        :γ => 1.,
        :extinction_threshold => 1e-2,
        :z => 0.,
        :K => 1e8,
        :dist => "normal",
        :N => 2,
    );

P[:σ] = 1e-1
ϕ = ThreadsX.collect(diversity!(p) for p in expand(P));
heatmap(
    P[:α],
    P[:β],
    Matrix(reshape(ϕ, length(P[:α]), length(P[:β]))'),
    xlabel = L"\alpha",
    ylabel = L"\beta"
)
plot!(x -> x)

plt = plot()
for σ ∈ 1e-4:2e-4:1e-3
    P[:σ] = σ
    ϕ = ThreadsX.collect(diversity!(p) for p in expand(P));
    plot_contour_line!(plt, ϕ, P; label = "σ = $(P[:σ])")
end
current()
savefig(plotsdir("phase-diag"))