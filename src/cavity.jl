using StatsBase
using Random, Distributions, Statistics
using DifferentialEquations
using LinearAlgebra
using QuadGK
using HCubature
using NLsolve, Roots
using SpecialFunctions

#= expression for density distribution (γ=1) =#
function P_n(n, e1_n, e2_n, p)
    @unpack μ, σ, α, β, S = p
    μ = (p[:scaled] ? μ/S : μ)
    σ = (p[:scaled] ? σ/S : σ)
    x = max(n,1e-20)
    return abs(α-β)*x^(α-β-1)/(sqrt(2*π*S*((σ^2)*e2_n)))*exp(-(x^(α-β)-S*μ*e1_n)^2/(2*S*((σ^2)*e2_n)))
end

#= cavity calculation for fraction of positive equilibriums 
and first two moments of the equilibrium distribution given μ and σ. =#
function Cavity_Λ(p;
    Iter = 2000, #number of iteration
    rela = .01, #relax parameter for fixed point
    tol = 1e-9, #requested tolerance for numerical integrator
    n_min = p[:extinction_threshold], #lower bound for integration
    Λ_init = p[:S]^(p[:β]-p[:α]), #initial guess for cut-off
    e1_init = (p[:scaled] ? 1/p[:μ] : 1/p[:μ]/p[:S]), #initial guess for e1_n
    e2_init = (p[:scaled] ? 1/p[:μ] : 1/p[:μ]/p[:S]), #initial guess for e1_n
    )

    Λ_n = Λ_init*ones(Iter+1) #cut-off
    e1_n = e1_init*ones(Iter+1) #<n>
    e2_n = e2_init*ones(Iter+1) #<n²>

    for i in 1:Iter
        e1_new = first(quadgk(x -> x*P_n(x, e1_n[i], e2_n[i], p) , n_min, Λ_n[i], rtol=tol))
        e2_new = first(quadgk(x -> x*x*P_n(x, e1_n[i], e2_n[i], p) , n_min, Λ_n[i], rtol=tol))

        g(λ) = 1 - first(quadgk(x -> P_n(x, e1_n[i], e2_n[i], p) , 0, λ, rtol=tol)) - 1/p[:S]

        Λ_new = find_zero(g, (0, Λ_init+1), Bisection())
        
        Λ_n[i+1] = (1-rela)*Λ_n[i] + rela*Λ_new        
        e1_n[i+1] = (1-rela)*e1_n[i] + rela*e1_new
        e2_n[i+1] = (1-rela)*e2_n[i] + rela*e2_new
    end
    e1_n_eq, e2_n_eq, Λ_n_eq = e1_n[Iter], e2_n[Iter], Λ_n[Iter]
    return (e1_n_eq, e2_n_eq, Λ_n_eq)
end

#= cavity calculation for fraction of positive equilibriums 
and first two moments of the equilibrium distribution given μ and σ.
In this case we keep Λ = S^(β-α) constant to speed up computations and avoid to find the right ansatz for initial condition case by case.
The choice is an analitical approximation of the scaling of Λ with S.
It can also be chosen to be a fixed constant 10^2 or 10^3.
Results are not affected by this approximation.=#
function Cavity(p;
    Iter = 2000, #number of iteration
    rela = .01, #relax parameter for fixed point
    tol = 1e-9, #requested tolerance for numerical integrator
    Λ = .001*p[:S]^(p[:β]-p[:α]), #Cut-off for integration
    n_min = p[:extinction_threshold], #lower bound for integration
    e1_init = (p[:scaled] ? 1/p[:μ] : 1/p[:μ]/p[:S]), #initial guess for e1_n
    e2_init = (p[:scaled] ? 1/p[:μ] : 1/p[:μ]/p[:S]) #initial guess for e1_n
    )

    e1_n = e1_init*ones(Iter+1) #<n>
    e2_n = e2_init*ones(Iter+1) #<n²>

    for i in 1:Iter
        e1_new = first(quadgk(x -> x*P_n(x, e1_n[i], e2_n[i], p) , n_min, Λ, rtol=tol))
        e2_new = first(quadgk(x -> x*x*P_n(x, e1_n[i], e2_n[i], p) , n_min, Λ, rtol=tol))

        e1_n[i+1] = (1-rela)*e1_n[i] + rela*e1_new
        e2_n[i+1] = (1-rela)*e2_n[i] + rela*e2_new
    end
    e1_n_eq, e2_n_eq = e1_n[Iter], e2_n[Iter]
    return (e1_n_eq, e2_n_eq)
end

#= critical σ, returns σ_cirit(μ), e1(μ,σ_crit), e1(μ,σ_crit) =#
function σ_crit(p;
    Iter = 2000, #number of iteration
    rela = .01, #relax parameter for fixed point
    tol = 1e-9, #requested tolerance for numerical integrator
    e1_init = (p[:scaled] ? 1/p[:μ] : 1/p[:μ]/p[:S]), #initial guess for e1_n
    e2_init = (p[:scaled] ? 1/p[:μ] : 1/p[:μ]/p[:S]), #initial guess for e1_n
    σc_init = (p[:scaled] ? .1*p[:μ] : .1*p[:μ]*p[:S]), #initial guess for σ_c
    Λ = p[:S]^(p[:β]-p[:α]), #Cut-off for integration
    n_min = p[:extinction_threshold], #lower bound for integration
    )
    @unpack μ, σ, α, β = p
    e1_n = e1_init*ones(Iter+1)
    e2_n = e2_init*ones(Iter+1) 
    σc = σc_init*ones(Iter+1) 
    for i in 1:Iter
        p[:σ] = σc[i]
        e1_new = first(quadgk(x -> x*P_n(x, e1_n[i], e2_n[i], p) , n_min, Λ, rtol=tol))
        e2_new = first(quadgk(x -> x*x*P_n(x, e1_n[i], e2_n[i], p) , n_min, Λ, rtol=tol))
        σc_new = abs(α-β)^(1/2)*((first(quadgk(x -> P_n(x, e1_n[i], e2_n[i], p)*x^(2*(β-α+1)),
        n_min, Λ, rtol=tol))))^(-1/2)

        
        e1_n[i+1] = (1-rela)*e1_n[i] + rela*e1_new
        e2_n[i+1] = (1-rela)*e2_n[i] + rela*e2_new
        σc[i+1] = (1-rela)*σc[i] + rela*σc_new
    end
    
    σc_eq, e1_n_eq, e2_n_eq = σc[Iter], e1_n[Iter], e2_n[Iter]
    return (σc_eq, e1_n_eq, e2_n_eq)
end

#= critical line in μ - σ space =#
function critical_line(p;
    μ_range = (.005:.005:.1),
    Λ = 1e3,
    )
    σc_line = ones(length(μ_range)) 
    for (i,μ) in enumerate(μ_range)
        p[:μ] = μ
        σc_line[i] = first(σ_crit(p; Λ))
        @show σc_line
    end
    return μ_range, σc_line
end

