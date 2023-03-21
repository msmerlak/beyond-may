using LinearAlgebra

function ahmadian(μ, σ)
    N = size(A.M, 1)
    X = inv(A.L)
    Y = inv(A.R)
    M(z) = X*(z*I-A.M)*Y
    τ(x, y) = tr(M(x + y*im)*M(x + y*im)')
    plot(eigen(A.M + A.L * ))
end