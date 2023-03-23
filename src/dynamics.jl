using DrWatson; @quickactivate
include(srcdir("utils.jl"))

using DifferentialEquations
using Random, Distributions
using LinearAlgebra

## dynamical system
function F(x, p)
    x .= ppart.(x)
    pop = x.^p[:α]
    comm = - x.^p[:β] .* (p[:A] * x.^p[:γ])
    return pop + comm
end

function F!(f, x, p)
    x .= ppart.(x)
    pop = x.^p[:α]
    comm = - x.^p[:β] .* (p[:A] * x.^p[:γ])
    f .= pop + comm
end

J(x, p) = ForwardDiff.jacobian(y -> F(y, p), x)

#= solving =#

MAX_TIME = 1e5
MAX_ABUNDANCE = 1e3

converged(ϵ = 1e-4) = TerminateSteadyState(ϵ)
blowup(max_abundance = MAX_ABUNDANCE) = DiscreteCallback((u, t, integrator) -> maximum(u) > max_abundance, terminate!)

function evolve!(p; trajectory=false)

    if !haskey(p, :seed)
        p[:seed] = rand(UInt32)
    end

    if !haskey(p, :rng)
        p[:rng] = MersenneTwister(p[:seed])
    end
    if !haskey(p, :A)
        add_interactions!(p)
    end
    if !haskey(p, :x0)
        add_initial_condition!(p)
    end

    pb = ODEProblem(
        ODEFunction(
            (f, x, p, t) -> F!(f, x, p) 
        ),
        p[:x0], 
        (0.0, MAX_TIME),
        p
    )

    sol = solve(pb,
        callback=CallbackSet(converged(), blowup()),
        save_on=trajectory 
    )
    p[:equilibrium] = sol.retcode == SciMLBase.ReturnCode.Terminated ? sol.u[end] : NaN
    p[:converged] = sol.retcode == SciMLBase.ReturnCode.Terminated && maximum(p[:equilibrium]) < MAX_ABUNDANCE

    survivors = sol.u[end] .> p[:extinction_threshold]
    p[:richness] = sum(survivors)

    q = p[:equilibrium]/sum(p[:equilibrium])
    p[:diversity] = 1/(p[:S] * sum(q.^2))

    if trajectory
        p[:trajectory] = sol
    end

end

function add_initial_condition!(p)
    p[:b0] = rand(p[:rng], Uniform(2, 10), p[:S])
end

function add_interactions!(p)
    (m, s) = p[:scaled] ? (p[:μ] / p[:S], p[:σ] / sqrt(p[:S])) : (p[:μ], p[:σ])


    if p[:dist] == "normal"
        dist = normal(m, s)
    elseif p[:dist] == "uniform"
        dist = Uniform(max(0.0, m - s), min(2m, m + s))
    elseif p[:dist] == "gamma"
        dist = gamma(m, s)
    end
    
    A = rand(p[:rng], dist, (p[:S], p[:S]))

    if haskey(p, :symm) && p[:symm]
        A = (A + A')/2
    end

    !haskey(p, :μₛ) && (p[:μₛ] = p[:μ])
    A[diagind(A)] .= p[:scaled] ? p[:μₛ] / p[:S] : p[:μₛ]
    p[:A] = A
end

