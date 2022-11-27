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