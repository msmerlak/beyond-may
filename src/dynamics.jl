using DifferentialEquations
using Random, Distributions
using LinearAlgebra

## dynamical system

function F!(f, x, p)
    x .= ppart.(x)
    pop = p[:r] .* x.^p[:α] - p[:z] .* x
    if p[:threshold] pop[x .< p[:b0]] .= 0 end
    comm = - x.^p[:β] .* contract(p[:A], x.^p[:γ])

    f .= pop + comm
end

function F(x, p)
    x .= ppart.(x)
    pop = p[:r] .* x.^p[:α] - p[:z] .* x
    if p[:threshold] pop[x .< p[:b0]] .= 0 end
    comm = - x.^p[:β] .* contract(p[:A], x.^p[:γ])

    return pop + comm
end

## solving

MAX_TIME = 1e3
MAX_ABUNDANCE = 1e3

converged(ϵ = 1e-5) = TerminateSteadyState(ϵ)
blowup(max_abundance = MAX_ABUNDANCE) = DiscreteCallback((u, t, integrator) -> maximum(u) > max_abundance, terminate!)

function evolve!(p; trajectory=false)

    !haskey(p, :seed) && (p[:seed] = rand(UInt32))
    !haskey(p, :rng) && (p[:rng] = MersenneTwister(p[:seed]))
    !haskey(p, :A) && add_interactions!(p)
    !haskey(p, :r) && add_growth_rates!(p)
    !haskey(p, :x0) && add_initial_condition!(p)

    pb = ODEProblem(
        ODEFunction(
            (f, x, p, t) -> F!(f, x, p)
        ),
        ones(p[:S]), #initial condition
        (0.0, MAX_TIME),
        p
    )

    sol = solve(pb,
        callback=CallbackSet(converged(), blowup()),
        save_on=trajectory #don't save whole trajectory, only endpoint
    )
    p[:equilibrium] = sol.retcode == :Terminated ? sol.u[end] : NaN
    p[:converged] = (sol.retcode == :Terminated && maximum(p[:equilibrium]) < MAX_ABUNDANCE)
    p[:richness] = sum(sol.u[end] .> p[:b0])
    p[:diversity] = p[:richness] == 0 ? 0 : Ω(sol.u[end] .* (sol.u[end] .> p[:b0]))

    if trajectory
        p[:trajectory] = sol
    end

end

function add_initial_condition!(p)
    p[:x0] = rand(p[:rng], Uniform(2, 10), p[:S])
end

function add_interactions!(p)
    # add a random interactions to p, the dict of parameters
    (m, s) = p[:scaled] ? (p[:μ] / p[:S], p[:σ] / sqrt(p[:S])) : (p[:μ], p[:σ])

    if p[:dist] == "normal"
        dist = Normal(m, s)
    elseif p[:dist] == "uniform"
        dist = Uniform(max(0.0, m - s), min(2m, m + s))
    elseif p[:dist] == "gamma"
        dist = Gamma(m^2 / s^2, s^2 / m)
    end

    A = rand(
        p[:rng], dist, Tuple(fill(p[:S], p[:order]))
    )
    for i in 1:p[:S]
        A[fill(i, p[:order])...] = 1/p[:K]
    end
    p[:A] = A
end


function add_growth_rates!(p)
    if haskey(p, :dist_r)
        p[:r] = rand(p[:rng], p[:dist_r], p[:S])
    else
        p[:r] = ones(p[:S])
    end
end


function diversity!(p)
    # run N simulates and append results to p
    diversity = Vector{Float64}(undef, p[:N])
    p[:rng] = MersenneTwister()

    for i in 1:p[:N]
        add_interactions!(p)
        add_growth_rates!(p)
        add_initial_condition!(p)
        evolve!(p)
        diversity[i] = p[:diversity]
    end
    ù
    return mean(diversity)
end

function full_coexistence!(p)
    # run N simulates and append results to p
    full_coexistence = Vector{Float64}(undef, p[:N])
    p[:rng] = MersenneTwister()

    for i in 1:p[:N]
        add_interactions!(p)
        add_growth_rates!(p)
        add_initial_condition!(p)
        evolve!(p)
        # full_coexistence[i] = p[:converged] && p[:richness] == p[:S] ? 1 : 0
        full_coexistence[i] = p[:richness] == p[:S] ? 1 : 0
    end

    return mean(full_coexistence)
end