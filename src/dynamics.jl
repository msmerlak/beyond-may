using DifferentialEquations
using Random, Distributions
using LinearAlgebra

## dynamical system

function F!(f, x, p)
    x .= ppart.(x)
    pop = p[:r] .* x.^p[:k] - p[:z] .* x

    X = tensorpower(x.^p[:b], p[:order] - 1)
    comm = - x.^p[:a] .* map(a -> a ⋅ X, p[:A])
    f .= pop + comm
end
## solving

MAX_TIME = 1e4
MAX_ABUNDANCE = 1e4

converged(ϵ = 1e-7) = TerminateSteadyState(ϵ)

blowup() = DiscreteCallback((u, t, integrator) -> maximum(u) > MAX_ABUNDANCE, terminate!)

function evolve!(p; trajectory=false)

    if !haskey(p, :rng)
        p[:rng] = MersenneTwister(p[:seed])
    end
    if !haskey(p, :A)
        add_interactions!(p)
    end
    if !haskey(p, :r)
        add_growth_rates!(p)
    end
    if !haskey(p, :x0)
        add_initial_condition!(p)
    end

    pb = ODEProblem(
        ODEFunction(
            (f, x, p, t) -> F!(f, x, p) #in-place F faster
            # jac=(j, x, p, t) -> J!(j, x, p) #specify jacobian speeds things up
        ),
        fill(0.1, p[:S]), #initial condition
        (0.0, MAX_TIME),
        p
    )

    sol = solve(pb,
        callback=CallbackSet(converged(), blowup()),
        save_on=trajectory #don't save whole trajectory, only endpoint
    )
    p[:equilibrium] = sol.retcode == :Terminated ? sol.u[end] : NaN
    p[:converged] = (sol.retcode == :Terminated && maximum(p[:equilibrium]) < MAX_ABUNDANCE)
    p[:richness] = sum(sol.u[end] .> p[:b0] * p[:threshold])
    p[:diversity] = p[:richness] == 0 ? 0 : Ω(sol.u[end] .* (sol.u[end] .> p[:b0] * p[:threshold]))

    if trajectory
        p[:trajectory] = sol
    end

end

function add_initial_condition!(p)
    p[:x0] = rand(p[:rng], Uniform(2, 10), p[:S])
end

function equilibria!(p)
    if !haskey(p, :rng) 
        p[:rng] = MersenneTwister(p[:seed])
    end
    if !haskey(p, :a)
        add_interactions!(p)
    end
    if !haskey(p, :r)
        add_growth_rates!(p)
    end

    equilibria = Vector{Float64}[]
    sizehint!(equilibria, p[:N])

    Threads.@threads for _ in 1:p[:N]
        add_initial_condition!(p)
        pb = ODEProblem(
            ODEFunction(
                (f, x, p, t) -> F!(f, x, p); #in-place F faster
                jac=(j, x, p, t) -> J!(j, x, p) #specify jacobian speeds things up
            ),
            p[:x0],
            (0.0, MAX_TIME),
            p
        )
        sol = solve(pb,
            callback=CallbackSet(TerminateSteadyState(1e-3), blowup()),
            save_on=false #don't save whole trajectory, only endpoint
        )
        push!(equilibria, sol.u[end])
    end
    p[:equilibria] = uniquetol(equilibria, atol=0.1)
    p[:num_equilibria] = length(p[:equilibria])
    p[:num_interior_equilibria] = sum(map(x -> all(x .> p[:b0] * p[:threshold]), p[:equilibria]))

    return p[:num_equilibria]
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

    A = [rand(p[:rng], dist, Tuple(fill(p[:S], p[:order] - 1))) for _ in 1:p[:S]]
    for i in 1:p[:S]
        A[i][fill(i, p[:order] - 1)...] = 1/p[:K]
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