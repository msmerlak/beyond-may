
function diversity!(p)
    # run N simulates and append results to p
    diversity = Vector{Float64}(undef, p[:N])
    p[:rng] = MersenneTwister() # no seed here

    for i in 1:p[:N]
        add_interactions!(p)
        add_initial_condition!(p)
        evolve!(p)
       
        diversity[i] = p[:diversity]
        
    #=     q = p[:equilibrium]/sum(p[:equilibrium])
        diversity[i] = 1/(sum(q.^2) * p[:S]) =#
    end

    return mean(diversity)
end

function full_coexistence!(p)
    # run N simulates and append results to p
    full_coexistence = Vector{Float64}(undef, p[:N])
    p[:rng] = MersenneTwister()

    for i in 1:p[:N]
        add_interactions!(p)
        add_initial_condition!(p)
        evolve!(p)
        # full_coexistence[i] = p[:converged] && p[:richness] == p[:S] ? 1 : 0
        full_coexistence[i] = p[:richness] == p[:S] ? 1 : 0
    end

    return mean(full_coexistence)
end