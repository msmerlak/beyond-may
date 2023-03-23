using StatsBase
using Random, Distributions, Statistics
using DifferentialEquations
using LinearAlgebra
using QuadGK
using HCubature
using NLsolve
using SpecialFunctions

#= expression for density distribution with gaussian approximation (γ=1) =#
function P_gauss(p)
    @unpack μ, σ, α, β, S = p
    μ = p[:scaled] ? μ : μ*S
    σ = p[:scaled] ? σ : σ*sqrt(S) 
    e1 = μ^(1/(α-β-1))
    e2 = e1^2/(1-(1/(α-β))^2*(μ*e1)^(2*(1-(α-β))/(α-β))*σ^2)
    #ϕ = e2>0 ? (1+erf((e1)/sqrt(2*(e2-e1^2))))/2 : 1
    return e2>0 ? Normal(e1, sqrt(e2-e1^2)) : Normal(e1, 0) #(e1, e2>0 ? e2 : 0, ϕ, e2>0 ? Normal(e1,sqrt(e2-e1^2)) : Normal(e1,0))
end

#= expression for density distribution (γ=1) =#
function P_n(n, e1_n, e2_n, p)
    @unpack μ, σ, α, β = p
    μ = p[:scaled] ? μ : μ*S
    σ = p[:scaled] ? σ : σ*sqrt(S)
    return abs(α-β)*n^(α-β-1)/(sqrt(2*π*σ^2*e2_n))*
        exp(-(n^(α-β)-μ*e1_n)^2/(2*σ^2*e2_n))
end

#= cavity calculation for fraction of positive equilibriums 
and first two moments of the equilibrium distribution given μ and σ. =#
function Cavity(p;
    Iter = 2000, #number of iteration
    rela = .01, #relax parameter for fixed point
    tol = 1e-9, #requested tolerance for numerical integrator
    n_max = 1e4, #upper bound for integration
    n_min = p[:threshold], #lower bound for integration
    e1_init = (p[:scaled] ? 1/p[:μ] : 1/p[:μ]/p[:S]), #initial guess for e1_n
    e2_init = (p[:scaled] ? 1/p[:μ] : 1/p[:μ]/p[:S]) #initial guess for e1_n
    )

    ϕ_n = ones(Iter+1) #fraction of survivals
    e1_n = e1_init*ones(Iter+1) #<n>
    e2_n = e2_init*ones(Iter+1) #<n²>

    for i in 1:Iter
    #    ϕ_new = first(quadgk(x -> P_n(x, e1_n[i], e2_n[i], p) , n_min, n_max, rtol=tol))
        e1_new = first(quadgk(x -> x*P_n(x, e1_n[i], e2_n[i], p) , n_min, n_max, rtol=tol))
        e2_new = first(quadgk(x -> x*x*P_n(x, e1_n[i], e2_n[i], p) , n_min, n_max, rtol=tol))

    #    ϕ_n[i+1] = (1-rela)*ϕ_n[i] + rela*ϕ_new
        e1_n[i+1] = (1-rela)*e1_n[i] + rela*e1_new
        e2_n[i+1] = (1-rela)*e2_n[i] + rela*e2_new
    end
    ϕ_n_eq, e1_n_eq, e2_n_eq = ϕ_n[Iter], e1_n[Iter], e2_n[Iter]
    return (ϕ_n_eq, e1_n_eq, e2_n_eq)
end

#= critical σ, returns σ_cirit(μ), e1(μ,σ_crit), e1(μ,σ_crit) =#
function σ_crit(p;
    Iter = 2000, #number of iteration
    rela = .01, #relax parameter for fixed point
    tol = 1e-9, #requested tolerance for numerical integrator
    e1_init = (p[:scaled] ? 1/p[:μ] : 1/p[:μ]/p[:S]), #initial guess for e1_n
    e2_init = (p[:scaled] ? 1/p[:μ] : 1/p[:μ]/p[:S]), #initial guess for e1_n
    σc_init = (p[:scaled] ? .1*p[:μ] : .1*p[:μ]*p[:S]), #initial guess for σ_c
    n_max = 1e3, #upper bound for integration
    n_min = p[:threshold], #lower bound for integration
    )
    @unpack μ, σ, α, β = p
    ϕ_n = ones(Iter+1) 
    e1_n = e1_init*ones(Iter+1)
    e2_n = e2_init*ones(Iter+1) 
    σc = σc_init*ones(Iter+1) 
    for i in 1:Iter
        p[:σ] = σc[i]
#        ϕ_new = first(quadgk(x -> P_n(x, e1_n[i], e2_n[i], p) , n_min, n_max, rtol=tol))
        e1_new = first(quadgk(x -> x*P_n(x, e1_n[i], e2_n[i], p) , n_min, n_max, rtol=tol))
        e2_new = first(quadgk(x -> x*x*P_n(x, e1_n[i], e2_n[i], p) , n_min, n_max, rtol=tol))
        σc_new = abs(α-β)^(1/2)*((first(quadgk(x -> P_n(x, e1_n[i], e2_n[i], p)*x^(2*(β-α+1)),
        n_min, n_max, rtol=tol))))^(-1/2)

        
        #ϕ_n[i+1] = (1-rela)*ϕ_n[i] + rela*ϕ_new
        e1_n[i+1] = (1-rela)*e1_n[i] + rela*e1_new
        e2_n[i+1] = (1-rela)*e2_n[i] + rela*e2_new
        σc[i+1] = (1-rela)*σc[i] + rela*σc_new
    end
    
    σc_eq, ϕ_n_eq, e1_n_eq, e2_n_eq = σc[Iter], ϕ_n[Iter], e1_n[Iter], e2_n[Iter]
    return (σc_eq, ϕ_n_eq, e1_n_eq, e2_n_eq)
end

#= critical σ, variant with gaussian approximation =#
function σ_crit_gauss(p;
    Iter = 2000, #number of iteration
    rela = .01, #relax parameter for fixed point
    tol = 1e-9, #requested tolerance for numerical integrator
    σc_init = (p[:scaled] ? .1*p[:μ] : .1*p[:μ]*p[:S]), #initial guess for σ_c
    n_max = 1e2, #upper bound for integration
    n_min = 0, #lower bound for integration
    )
    @unpack μ, σ, α, β = p
    σc = σc_init*ones(Iter+1)     
    for i in 1:Iter
        p[:σ] = σc[i]
        σc_new = abs(α-β)*((first(quadgk(x -> pdf(P_gauss(p), x)*x^(2*(β-α+1)) ,
            n_min, n_max, rtol=tol))))^(-1/2)
        σc[i+1] = (1-rela)*σc[i] + rela*σc_new
    end
    σc_eq = σc[Iter]
    return σc_eq
end

#= critical line in μ - σ space =#
function critical_line(p;
    μ_range = (.005:.005:.1),
    n_max = 1e3,
    )
    σc_line = ones(length(μ_range)) 
    for (i,μ) in enumerate(μ_range)
        p[:μ] = μ
        σc_line[i] = first(σ_crit(p; n_max))
        @show σc_line
    end
    return μ_range, σc_line
end

#= critical line in μ - σ space for gaussian approximation =#
function critical_line_gauss(p;
    μ_range = (.005:.005:.1),
    )
    σc_line = ones(length(μ_range)) 
    for (i,μ) in enumerate(μ_range)
        p[:μ] = μ
        σc_line[i] = σ_crit_gauss(p)
        @show σc_line
    end
    return μ_range, σc_line
end