precis_cmdstan <- function(mod, ..., variables = NULL, drop_lp = TRUE) {
  assertthat::assert_that(
    all(inherits(mod, c("CmdStanMCMC", "CmdStanFit", "R6"), which = TRUE))
  )
  out <- mod$summary(
    variables = variables,
    c("mean", "sd", "quantile2", "rhat", "ess_bulk", "ess_tail")
  )
  if (isTRUE(drop_lp)) {
    out <- out |> 
      filter(variable != "lp__")
  }
  out
}
