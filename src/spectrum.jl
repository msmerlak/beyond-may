using ForwardDiff
J(x, p) = ForwardDiff.jacobian(y -> F(y, p), x)

function spectrum(p)
    if p[:converged]
        return eigen(J(p[:equilibrium], p)).values
    else
        @warn "Didn't converge!"
    end
end

dominant(p) = maximum(real, spectrum(p))