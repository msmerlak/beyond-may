using DifferentialEquations
using Random, Distributions
using LinearAlgebra
using ForwardDiff

#= dynamical system =#

function F!(f, x, p)
    x .= ppart.(x)
    pop = x.^p[:α]
    comm = - x.^p[:β] .* contract(p[:A], x.^p[:γ])

    f .= pop + comm
end

function F(x, p)
    x .= ppart.(x)
    pop = x.^p[:α]
    comm = - x.^p[:β] .* contract(p[:A], x.^p[:γ])

    return pop + comm
end

J(x, p) = ForwardDiff.jacobian(y -> F(y, p), x)

#= solving =#

MAX_TIME = 1e5
MAX_ABUNDANCE = 1e5

converged(ϵ = 1e-5) = TerminateSteadyState(ϵ)

blowup() = DiscreteCallback((u, t, integrator) -> maximum(u) > MAX_ABUNDANCE, terminate!)

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
            (f, x, p, t) -> F!(f, x, p) #in-place F faster
            # jac=(j, x, p, t) -> J!(j, x, p) #specify jacobian speeds things up
        ),
        ones(p[:S]).*p[:x0], #initial condition
        (0.0, MAX_TIME),
        p
    )

    sol = solve(pb,
        callback=CallbackSet(converged(), blowup()),
        save_on=trajectory #don't save whole trajectory, only endpoint
    )

    p[:equilibrium] = sol.retcode == :Terminated ? sol.u[end] : NaN
    p[:converged] = sol.retcode == :Terminated && maximum(p[:equilibrium]) < MAX_ABUNDANCE

    survivors = sol.u[end] .> p[:threshold]

    p[:richness] = sum(survivors)
    p[:diversity] = p[:richness] == 0 ? 0 : Ω(sol.u[end] .* (sol.u[end] .> p[:threshold]))

#=  q = p[:equilibrium]/sum(p[:equilibrium])
    p[:diversity] = 1/(p[:S] * sum(q.^2))  =#

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

    A = rand(p[:rng], dist, (p[:S],p[:S]))
    A[diagind(A)] = A[diagind(A)]*p[:μₛ]
    p[:A] = A
end