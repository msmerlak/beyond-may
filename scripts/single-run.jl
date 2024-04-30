using DrWatson, Glob, Revise
@quickactivate
foreach(include, glob("*.jl", srcdir()))

using Plots, LaTeXStrings

#= Unstructured =#

stab = Float64[]

σₑ=.075:.001:.2
for (i,_) in enumerate(σₑ)

    p = Dict{Symbol,Any}(
    :scaled => false,
    :S => 100,
    :μ => .01,
    :μₛ => .01,
    :σ => .01,
    :α => rand(Normal(1., σₑ[i]),100),
    :β => rand(Normal(1.5,σₑ[i]),100),
    :γ => rand(Normal(1., σₑ[i]),100),
    :x0 => 1. *ones(100),
    :extinction_threshold => 1e-6,
    :dist => "gamma",
    :N => 100,
    :seed => rand(UInt)
    );

    push!(stab, stability!(p))

end

plot(σₑ, stab,
lw = 2,
legend = false,
xlabel = L"\sigma_e",
ylabel = L"\textrm{Probability \ of \ stability}",
)

#= --- =#

p = Dict{Symbol,Any}(
    :scaled => false,
    :S => 100,
    :μ => .01,
    :μₛ => .01,
    :σ => .01,
    :α => 1.,
    :β => 1.5,
    :γ => 1.,
    #:x0 => 1.,
    :extinction_threshold => 1e-6,
    :dist => "gamma",
    :N => 100,
    :seed => rand(UInt)
    );

evolve!(p; trajectory=true)


#= trajectories =#
plot(
    p[:trajectory],
    ylabel=L"x_i(t)",
    xlabel=L"t",
    #yscale=:log,
    linewidth=1,
    legend=false,
    grid=false,
)

#= density distribution =#
p_eq = p[:trajectory].u[end]
stephist(p_eq,
    normalize=true,
    alpha=0.5,
    color=:green,
    ylabel=L"P(x_*)",
    xlabel=L"x_*",
    label=false,
    grid=false,
    fill=true,
)

a, b, c, Λ = Cavity_Λ(p)

X=[x for x in .9*minimum(p_eq):.001:1.1*maximum(p_eq)]
plot!(X,[P_n(x, b, c, p) for x in X],
labels = false, #"cavity - gaussian",
linewidth = 2,
alpha = 1,
linecolor = :black,
grid = false,
size = (600,200),
)


p[:converged]

#= cavity solution with gaussian approximation =#
X = [x for x in 0.9*minimum(p_eq):0.0001:1.1*maximum(p_eq)]
plot!(X, [pdf(P_gauss(p), x) for x in X],
    labels=false, #"cavity - gaussian",
    linewidth=2,
    alpha=1,
    linecolor=:black,
    linestyle=:dash,
    grid=false
)

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