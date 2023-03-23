using DrWatson, Glob, Revise
@quickactivate
foreach(includet, glob("*.jl", srcdir()))

using ProgressMeter, ThreadsX
using Plots, LaTeXStrings
gr(label = false, grid = false)
using Contour

function plot_contour_line!(plt, ϕ, P; level = 0.5, label)
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
        :μₛ => true,
        :σ => 1e-4,
        :α => 0.25:.25:2.5,
        :β => 0.25:.25:2.5,
        :γ => 1.,
        :threshold => false,
        :dist => "normal",
        :N => 1,
    );

plt = plot(x->x, xlims = (0, 2.5), color = :black, lw = 2)
xlabel!(L"\alpha")
ylabel!(L"\beta")
for σ ∈ (1e-3, 5e-3, 1e-2) 
    P[:σ] = σ
    ϕ = ThreadsX.collect(diversity!(p) for p in expand(P));
    plot_contour_line!(plt, ϕ, P; label = "σ = $(P[:σ])")
end
current()
#savefig(plotsdir("alpha-beta"))

#= alternative  =#
P = Dict{Symbol, Any}(
        :scaled => true,
        :S => 50,
        :μ => 1.,
        :μₛ => true,
        :σ => .1,
        :α => 1.,
        :β => 1.25,
        :γ => 1.,
        :threshold => false,
        :dist => "normal",
        :N => 1,
    );

plt = plot(x->x, xlims = (0, 2), color = :black, lw = 4,     label = latexstring("σ_c = 0"))
xlabel!(L"\alpha")
ylabel!(L"\beta")
for β ∈ 1.5:.5:2.5 
    P[:β] = β
    σₘ = round(σ_crit_gauss(P), digits = 1)
    plot!(x-> β-1+x, 
    xlims = (0, 2), 
    ylims = (0, 2), 
    lw = 4,
#    fillrange = x -> β-1.25+x,
#    fillalpha = .5,
    palette = cgrad(:Reds_4, rev=false),
    label = latexstring("σ_c = $(σₘ)"), 
    legend = :bottomright,
    )
end
current()

#= σ critical =#
p = Dict{Symbol, Any}(
        :scaled => true,
        :S => 50,
        :μ => 1.,
        :μₛ => true,
        :σ => .1,
        :α => 1.,
        :β => 1.25,
        :γ => 1.,
        :threshold => false,
        :dist => "normal",
        :N => 1,
    );

B = 1.5:.5:3.
σₘ = ones(length(B))
for (i, β) ∈ enumerate(B)
    p[:β] = β
    σₘ[i] = σ_crit_gauss(p)
end

σₘ

plot(B, σₘ, 
lw = 4,
lc = :black)
