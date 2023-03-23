using DrWatson
@quickactivate

using Glob, Revise
foreach(includet, glob("*.jl", srcdir()))

using Plots, LaTeXStrings
gr(label = false, grid = false)

function σ_critical(α, β = 1)
    p = Dict{Symbol, Any}(
        :scaled => true,
        :S => 50,
        :μ => .5,
        :α => α,
        :β => β,
        :γ => 1.,
        :extinction_threshold => 1e-4,
        :dist => "gamma",
        :N => 1,
    );

    for σ in 0.01:.1:5.
        p[:σ] = σ
        s = stability!(p)
        s < .9 && return σ
    end
end
 
α_range = .1:.1:1.
@time map(σ_critical, α_range)