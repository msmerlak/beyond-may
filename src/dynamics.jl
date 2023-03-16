using DifferentialEquations
using Random, Distributions
using LinearAlgebra
using ForwardDiff

## dynamical system

function F!(f, x, p)
    x .= ppart.(x)
    pop = p[:r] .* x.^p[:α] - p[:z] .* x
    comm = - x.^p[:β] .* contract(p[:A], x.^p[:γ])

    f .= pop + comm
end

function F(x, p)
    x .= ppart.(x)
    pop = p[:r] .* x.^p[:α] - p[:z] .* x
    comm = - x.^p[:β] .* contract(p[:A], x.^p[:γ])

    return pop + comm
end

J(x, p) = ForwardDiff.jacobian(y -> F(y, p), x)

## solving

MAX_TIME = 1e3
MAX_ABUNDANCE = 1e3

converged(ϵ = 1e-3) = TerminateSteadyState(ϵ)

blowup() = DiscreteCallback((u, t, integrator) -> maximum(u) > MAX_ABUNDANCE, terminate!)

function evolve!(p; trajectory=false)
    if !haskey(p, :seed)
        p[:seed] = 1234
    end
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
            (f, x, p, t) -> F!(f, x, p) #in-place 
        ),
        p[:x0], #initial condition
        (0.0, MAX_TIME),
        p
    )

    sol = solve(pb,
        callback=CallbackSet(converged(), blowup()),
        save_on=trajectory #don't save whole trajectory, only endpoint
    )
    p[:equilibrium] = sol.retcode == :Terminated ? sol.u[end] : NaN
    p[:converged] = sol.retcode == :Terminated && maximum(p[:equilibrium]) < MAX_ABUNDANCE/2

    survivors = sol.u[end] .> p[:extinction_threshold]
    
    p[:richness] = sum(survivors)
    q = p[:equilibrium]/sum(p[:equilibrium])
    p[:diversity] = 1/(p[:S] * sum(q.^2))

    if trajectory
        p[:trajectory] = sol
    end

end

function add_initial_condition!(p)
    p[:x0] = rand(p[:rng], Uniform(1, 10), p[:S])
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
    
    order = haskey(p, :order) ? p[:order] : 2
        
    A = rand(
        p[:rng], dist, Tuple(fill(p[:S], order))
    )

    if order == 2 && haskey(p, :symm) && symm
        A = (A + A')/2
    end
    
    # for i in 1:p[:S]
        # A[fill(i, order)...] = p[:μₛ]
    # end
    
    p[:A] = A
end


function add_growth_rates!(p)
    if haskey(p, :dist_r)
        p[:r] = rand(p[:rng], p[:dist_r], p[:S])
    else
        p[:r] = ones(p[:S])
    end
end
