const GaussianProcessRegressor_ = skgp(:GaussianProcessRegressor)
@sk_reg mutable struct GaussianProcessRegressor <: MMI.Deterministic
    kernel::Any               = nothing
    alpha::Union{Float64,AbstractArray} = 1.0e-10
    optimizer::Any            = "fmin_l_bfgs_b"
    n_restarts_optimizer::Int = 0
    normalize_y::Bool         = false
    copy_X_train::Bool        = true
    random_state::Any         = nothing
end
MMI.fitted_params(model::GaussianProcessRegressor, (fitresult, _, _)) = (
    X_train = fitresult.X_train_,
    y_train = fitresult.y_train_,
    kernel  = fitresult.kernel_,
    L       = fitresult.L_,
    alpha   = fitresult.alpha_,
    log_marginal_likelihood_value = fitresult.log_marginal_likelihood_value_
    )

meta(GaussianProcessRegressor,
    input   = Table(Continuous),
    target  = AbstractVector{Continuous},
    weights = false,
    human_name   = "Gaussian process regressor"
    )

# ============================================================================
const GaussianProcessClassifier_ = skgp(:GaussianProcessClassifier)
@sk_clf mutable struct GaussianProcessClassifier <: MMI.Probabilistic
    kernel::Any           = nothing
    optimizer::Any        = "fmin_l_bfgs_b"
    n_restarts_optimizer::Int = 0
    copy_X_train::Bool    = true
    random_state::Any     = nothing
    max_iter_predict::Int = 100::(_ > 0)
    warm_start::Bool      = false
    multi_class::String   = "one_vs_rest"::(_ in ("one_vs_one", "one_vs_rest"))
end
MMI.fitted_params(m::GaussianProcessClassifier, (f, _, _)) = (
    kernel    = f.kernel_,
    log_marginal_likelihood_value = f.log_marginal_likelihood_value_,
    classes   = f.classes_,
    n_classes = f.n_classes_
    )
meta(GaussianProcessClassifier,
    input   = Table(Continuous),
    target  = AbstractVector{<:Finite},
    weights = false,
    human_name   = "Gaussian process classifier"
    )
