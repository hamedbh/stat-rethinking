psis_with_relative_eff <- function(m) {
  ll_draws <- m$draws("log_lik")
  p <- ll_draws |> 
    loo::psis(
      r_eff = loo::relative_eff(ll_draws)
    ) |> 
    pluck("diagnostics", "pareto_k")
  p
}
