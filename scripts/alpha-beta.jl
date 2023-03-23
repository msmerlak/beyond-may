using DrWatson
@quickactivate

using Glob, Revise
foreach(includet, glob("*.jl", srcdir()))

using ThreadsX
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
        :scaled => true,
        :S => 10,
        :μ => .5,
        :σ => .7,
        :α => 0.1:.1:1.5,
        :β => 0.1:.1:1.5,
        :γ => 1.,
        :extinction_threshold => 1e-4,
        :dist => "gamma",
        :N => 5,
    );

ϕ = ThreadsX.collect(stability!(p) for p in expand(P));
contour(P[:α], 
P[:β],
    Matrix(reshape(ϕ, length(P[:α]), length(P[:β]))')
    )


plt = plot()    
plot_contour_line!(plt, ϕ, P; label = "σ = $(P[:σ])")

plt = plot(x->x, xlims = (0, 1), color = :black, lw = 2)
xlabel!(L"\alpha")
ylabel!(L"\beta")
for σ ∈ (0.01, .3, .5) 
    P[:σ] = σ
    ϕ = ThreadsX.collect(stability!(p) for p in expand(P));
    plot_contour_line!(plt, ϕ, P; label = "σ = $(P[:σ])")
end
current()
savefig(plotsdir("alpha-beta"))