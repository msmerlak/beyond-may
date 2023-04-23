using DrWatson; @quickactivate

using ForwardDiff
J_numerical(p) = ForwardDiff.jacobian(y -> F(y, p), p[:equilibrium])

d(f) = x -> ForwardDiff.derivative(f, x)
function J_analytical(p)
    f(x) = x^p[:α]
    g(x) = - x^p[:β]
    h(x) = x^p[:γ]
    @assert p[:converged]

    X = p[:equilibrium]
    L = @. g(X)
    R = @. d(h)(X)
    M = @. d(f)(X) - d(g)(X)*f(X)/g(X) + (p[:μₛ] - p[:μ])*g(X)*d(h)(X)
    S = p[:A] - (p[:μₛ] - p[:μ])*I

    return diagm(M) + diagm(L)*S*diagm(R)
end

using LinearAlgebra
function spectrum(p)
    if p[:converged]
        return eigen(J_numerical(p)).values
    else
        @warn "Didn't converge!"
    end
end
dominant(p) = maximum(real, spectrum(p))

function ahmadian(p)
    f(x) = x^p[:α]
    g(x) = - x^p[:β]
    h(x) = x^p[:γ]
    @assert p[:converged]
    X = p[:equilibrium]
    L = @. g(X)
    R = @. d(h)(X)
    M = @. d(f)(X) - d(g)(X)*f(X)/g(X) + (p[:μₛ] - p[:μ])*g(X)*d(h)(X)
    S = p[:A] - (p[:μₛ] - p[:μ])*I
    
    Σ = spectrum(p)
    τ(x, y) = sum(@. (L*R)^2/abs(x + y*im - M)^2 )
    X = range(minimum(real.(Σ)), maximum(real.(Σ)), length = 100)
    Y = range(minimum(imag.(Σ)), maximum(imag.(Σ)), length = 100)
    contour(1.5*X, 1.5*Y; levels = [1/var(S), 2/var(S)], lw = 2)
    
    scatter!(spectrum(p); alpha = .2, label = false)
end
