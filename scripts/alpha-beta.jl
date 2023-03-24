using DrWatson
@quickactivate

using Glob, Revise
foreach(includet, glob("*.jl", srcdir()))

using Plots, LaTeXStrings
gr(label = false, grid = false)

function σ_critical(α, β = 1)
    p = Dict{Symbol, Any}(
        :scaled => true,
        :S => 100,
        :μ => .5,
        :α => α,
        :β => β,
        :γ => 1.,
        :extinction_threshold => 1e-4,
        :dist => "gamma",
        :N => 4,
    );

    for σ in 0.0001:.01:5
        p[:σ] = σ
        s = stability!(p)
        s < .9 && return σ
    end
end

Σ = [β > α ? σ_critical(α, β) : 0 for α in .1:.1:1., β in .1:.1:1.]

Σ = [σ_critical(α, β) for α in .1:.1:1., β in .1:.1:1.]

using Arrow