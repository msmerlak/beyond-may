using DrWatson, Glob, Revise
@quickactivate
foreach(includet, glob("*.jl", srcdir()))

using Plots, LaTeXStrings

P = Dict{Symbol, Any}(
    :scaled => false,
    :μ => .1,
    :σ => .001,
    :k => 1,
    :a => 1,
    :b => 1,
    :b0 => .01,
    :threshold => false,
    :z => 0.1,
    :K => 1.,
    :order => 2,
    :dist => "normal",
    :N => 1,
    :symm => false,
    :seed => rand(UInt)
);

P[:S] = 50:20:150


plot(legend = :topleft)
for k in .8:.1:1.2
        P[:k] = k
        mean_diag = []
        mean_offdiag = []
        for p in expand(P)
            evolve!(p)
            if p[:converged]
                j = J(p[:equilibrium], p)
                push!(mean_diag, mean(diag(j)))
                push!(mean_offdiag, mean(offdiag(j)))
                # plot!(offdiag(j); seriestype = :stephist, label = "S = $(p[:S])")    
            end
        end
        plot!(mean_diag ./ mean_offdiag, label = "k/a = $(p[:k]/p[:a])")
end
current()

