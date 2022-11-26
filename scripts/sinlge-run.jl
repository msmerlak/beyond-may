using DrWatson, Glob
@quickactivate
foreach(include, glob("*.jl", srcdir()))


using ProgressMeter, Suppressor, DataFrames
using Plots, LaTeXStrings

P = Dict{Symbol, Any}(
    :scaled => false,
    :S => 20,
    :μ => .1,
    :σ => .005,
    :k => 1.,
    :b0 => 1.,
    :K => 5*ones(20),
    :λ => 0,
    :z => 0, #10^(-1/4),
    :r => 1, #rand(LogNormal(1,.08),100),
    #:dist_r => LogNormal(1,.1),
    :N => 1,
    :threshold => false,
    :dist => "normal",
    :symm => false,
    :seed => 17,
);

#plot multi log, init. cond. [.06,6]

#P[:K]=P[:r].^(-4)
#P[:r]=P[:K].^(-1/4)

#P[:μ]*=P[:r]/P[:S] #mode(P[:dist_r])/P[:S]
#P[:σ]*=P[:μ]
#P[:K]*=P[:r]/(P[:σ]*sqrt(P[:S]+P[:μ]))
evolve!(P; trajectory = true);

#trajectories
plot!(P[:trajectory],
ylabel = L"B_i(t)",
xlabel = L"t",
yscale = :log,
#yticks = [10^(-3),10^(-2),10^(-1), 10^(0), 10, 10^2, 10^3],
#ylims = [.025,.65],
#xlims = [0,250],
linewidth = 3,
legend = false,
alpha = 1,
grid = false,
palette = :blues, 
#palette = :YlOrBr_5,
)

#savefig("SM-log-species-abd-sigma.svg")

# plot sub multi, init. cond. [.3,.6]
P = Dict{Symbol, Any}(
    :scaled => false,
    :S => 15,
    :μ => .1,
    :σ => .01,
    :k => .75,
    :b0 => 1.,
    :K => 10^20*ones(P[:S]),
    :λ => 0,
    :z => 10^(-1/4),
    :r => 1, #rand(LogNormal(1,.08),100),
    #:dist_r => LogNormal(1,.1),
    :N => 1,
    :threshold => false,
    :dist => "normal",
    :symm => false,
    :seed => 8,
);

# abunancies
histogram!([(P[:equilibrium])],
normalize=true,
alpha = .5,
color = :gray,
ylabel = L"P(b^*)",
xlabel = L"b^* \textrm{(log \ scale)}",
label = false,
grid = false,
#ylims = [0,1.1],
#xlims = [-3,3],
#xticks = [-3,-2,-1,0,1,2,3],
)

plot!([i for i in 0:5], [P[:k]/(1+P[:K]*P[:S]*P[:μ]/P[:r]) for i in 0:5],
linewidth = 2,
linestyle = :dash,
linecolor = :gray,
)

X=[n for n in -1.:.01:3]
plot!((X),[pdf(Normal(P_n_log(P).μ, P_n_log(P).σ), n) for n in X],
#plot!((X),[pdf(P_n_log(P), n) for n in X],
labels="cavity",
linewidth = 2,
linecolor = :black,
grid = false,
#xlims = [10^(-3),10^3],
#xticks = [10^-3,10^-2,10^-1,10^0,10^1,10^2,10^3],
)

# cavity solution with gaussian approximation
X=[n for n in .5*minimum(P[:equilibrium]):.0001:1.5*maximum(P[:equilibrium])]
plot!(X,[pdf(last(P_n_gauss(P)) ,n) for n in X],
labels="cavity - gaussian",
linewidth = 2,
alpha = 1,
linecolor = :red,
)

plot!(X,[P_n_mix(n, P) for n in X],
labels="cavity - mixed",
linewidth = 2,
alpha = 1,
linecolor = :black,
linestyle = :dash,
)

# cavity solution
ϕ, uno, due = Cavity(P, n_max=1000)
X=[n for n in .5*minimum(P[:equilibrium]):.0001:1.5*maximum(P[:equilibrium])]
plot!(X,[P_n(n,uno,due,P) for n in X],
labels="cavity",
alpha = 1,
linewidth = 2,
linecolor = :black,
)

savefig("cavity+mixed+gaussian-s100.svg")

function f!(F, x)
    F[1] = 1-P[:S]*P_n(x[1], uno, due, P)/ϕ
end
n_max_new = nlsolve(f!, [1.]).zero[1]

# richness
P[:richness]/P[:S]
gauss_approx_ϕ(P, n_max=1000)

# spectrum
boundary(P, overprint=false)

# critical line
μ_critical, σ_critical = critical_line(P, μ_range=(.01:.1:1.21))
plot!(μ_critical, σ_critical,
labels = false,
linewidth = 4,
linecolor = COLOR_SUB35,
ylims=[.00,.117],
#xlims=[.02,1.]
)

plot!(μ_critical, .05*σ_critical.^0,
labels = false,
linewidth = 4,
linecolor = COLOR_LOG35,
#ylims=[0.01,.12],
#xlims=[.1,1.2]
)

# critical line for gaussian approximation
μ_critical, σ_critical = critical_line_gauss(P, μ_range=(.01:.4:1.21))
plot!(μ_critical, σ_critical,
labels = false,
linewidth = 4,
linecolor = COLOR_LOG35,
linestyle = :dash,
ylims=[.0,.117],
#xlims=[.02,1.6]
)

# critical line for gaussian approximation with alternative method
μ_critical, σ_critical = alternative_crit_σ(P, μ_range=(.01:.01:1.2))
plot!(μ_critical, .5*σ_critical,
labels = false,
linewidth = 4,
linecolor = COLOR_SUB35,
#ylims=[1.,20.],
#xlims=[.02,1.6]
)

#savefig("papers/onofrio/fig/no-threshold-phase-space.svg")