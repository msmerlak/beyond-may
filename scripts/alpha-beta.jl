@show Threads.nthreads()

using Pkg
Pkg.instantiate()

using DrWatson; @quickactivate

using Glob, Revise
foreach(includet, glob("*.jl", srcdir()))

using Plots, LaTeXStrings
gr(label = false, grid = false)
using DelimitedFiles


for dist in ("normal", "gamma")
    function σ_critical(α, β = 1)

        @show (α, β)
        p = Dict{Symbol, Any}(
            :scaled => true,
            :S => 100,
            :μ => .5,
            :α => α,
            :β => β,
            :γ => 1.,
            :extinction_threshold => 1e-4,
            :dist => dist,
            :N => 100,
        );
        

        for σ in 0.0001:.01:5
            p[:σ] = σ
            s = stability!(p)
            s < .5 && return σ
        end
    end

    A = .1:.05:2.
    B = .1:.05:2.
    Σ = [β > α ? σ_critical(α, β) : 0 for α in A, β in B]
    
    writedlm(datadir("alpha-beta-$dist.csv"), Σ, ',')

    p = heatmap(A, B, Σ', label = L"\sigma_c")
    xlabel!(L"\alpha")
    ylabel!(L"\beta")
    savefig(p, plotsdir("alpha-beta-$dist"))
end
