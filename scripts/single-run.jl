using DrWatson, Glob, Revise
@quickactivate
foreach(includet, glob("*.jl", srcdir()))

using Plots, LaTeXStrings

p = Dict{Symbol, Any}(
    :scaled => true,
    :S => 100,
    :μ => 1.,
    :μₛ => false,
    :σ => .1,
    :α => 1,
    :β => 1.5,
    :γ => 1,
    :x0 => .1,
    :threshold => false,
    :dist => "gamma",
    :N => 1,
    :symm => false,
    :seed => rand(UInt)
);

evolve!(p; trajectory = true);

p[:converged]

#= trajectories =#
plot(
    p[:trajectory],
    ylabel = L"x_i(t)",
    xlabel = L"t",
    yscale = :log,
    linewidth = 1,
    legend = false,
    grid = false,
)

#= density distribution =#
p_eq = p[:trajectory].u[end]
histogram(p_eq,
    normalize = true,
    alpha = .5,
    color = :green,
    ylabel = L"P(x_*)",
    xlabel = L"x_*",
    label = false,
    grid = false,
)

#= cavity solution with gaussian approximation =#
X=[x for x in .9*minimum(p_eq):.0001:1.1*maximum(p_eq)]
plot!(X,[pdf(P_gauss(p), x) for x in X],
labels = false, #"cavity - gaussian",
linewidth = 2,
alpha = 1,
linecolor = :black,
linestyle = :dash,
grid = false
)

a, b, c = Cavity(p)

X=[x for x in .9*minimum(p_eq):.01:1.1*maximum(p_eq)]
plot!(X,[P_n(x, b, c, p) for x in X],
labels = false, #"cavity - gaussian",
linewidth = 2,
alpha = 1,
linecolor = :black,
grid = false,
size = (600,200)
)