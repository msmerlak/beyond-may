using DrWatson, Glob, Revise
@quickactivate
foreach(includet, glob("*.jl", srcdir()))

using Plots, LaTeXStrings

P = Dict{Symbol, Any}(
        :scaled => false,
        :μ => .1,
        :σ => .1,
        :β => 1.,
        :γ => 1.,
        :b0 => 1e-5,
        :threshold => false,
        :z => 0.,
        :K => 1.,
        :order => 2,
        :dist => "normal",
        :N => 1,
        :symm => false,
    );

plot()
P[:S] = 10:10:50
for α in .8:.1:1.2
        P[:α] = α
        s = []
        d = []
        for p in expand(P)
            evolve!(p)
            push!(s, survival(p))
            push!(d, dominant(p))
        end
        scatter!(s, d)
end
current()



spec = plot(legend = :topleft)
for α in .8:.1:1.2
        P[:α] = α
        for p in expand(P)
            evolve!(p; trajectory = true)
            s = spectrum(p)
            p[:converged] && scatter!(s; label = "α = $(p[:α])", markers = :auto, marker_z = p[:richness])
        end
end
vline!([0]; color = :black, label = false)
current()
