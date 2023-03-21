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
        :S => 100,
        :μ => 1e-2,
        # :μₛ => 1e-2,
        :σ => 1e-4,
        :α => 0.1:.1:1.5,
        :β => 0.1:.1:1.5,
        :γ => 1.,
        :extinction_threshold => 1e-4,
        :z => 0.,
        :dist => "normal",
        :N => 10,
    );

plt = plot(x->x, xlims = (0, 1), color = :black, lw = 2)
xlabel!(L"\alpha")
ylabel!(L"\beta")
for σ ∈ (1e-3, 5e-3, 1e-2) 
    P[:σ] = σ
    ϕ = ThreadsX.collect(diversity!(p) for p in expand(P));
    plot_contour_line!(plt, ϕ, P; label = "σ = $(P[:σ])")
end
current()
savefig(plotsdir("phase-diag"))