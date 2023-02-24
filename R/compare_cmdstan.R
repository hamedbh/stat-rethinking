compare_cmdstan <- function(...,
                            n = 1000,
                            refresh = 0,
                            warn = TRUE,
                            result_order = c(1, 5, 3, 6, 2, 4),
                            log_lik = "log_lik") {
  L <- list(...)
  if (is.list(L[[1]]) && length(L) == 1)
    L <- L[[1]]
  if (length(L) == 1)
    stop("Need more than one model to compare.")
  mnames <- (match.call(expand.dots = FALSE)$...) |>
    as.list() |>
    map_chr(rlang::as_label)
  mnames
  # func <- match.arg(func)
  # the_func <- strinf("loo::%s", func)
  classes <- map(L, class)
  classes_checked <- map_lgl(classes, ~ identical(.x, classes[[1]]))
  if (!(all(classes_checked)) & warn == TRUE) {
    warning("Not all model fits of same class.\nThis is usually a bad idea, because it implies they were fit by different algorithms.\nCheck yourself, before you wreck yourself.")
  }
  # Initially I had commented out the nobs block from McElreath's code, as there
  # wasn't an obvious way to make it work. For now have used the length of
  # `log_lik` as a fairly reliable means of checking whether all models have the
  # same number of observations.
  nobs_list <- try(
    map_dbl(L, ~ .x$metadata()[["stan_variable_sizes"]][["log_lik"]])
  )
  if (any(nobs_list != nobs_list[1]) & warn == TRUE) {
    nobs_out <- paste(mnames, nobs_list, "\n")
    nobs_out <- concat(nobs_out)
    warning(concat("Different numbers of observations found for at least two models.\nModel comparison is valid only for models fit to exactly the same observations.\nNumber of observations for each model:\n",
                   nobs_out))
  }
  dSE_matrix <- matrix(NA, nrow = length(L), ncol = length(L))
  IC_list_pw <- map(L, ~ .x$loo())
  p_list <- map_dbl(IC_list_pw, ~ sum(.x[["pointwise"]][, "p_loo"]))
  se_list <- map_dbl(IC_list_pw, ~ .x[["estimates"]][3, 2])
  IC_list <- map_dbl(IC_list_pw, ~ sum(.x[["pointwise"]][, "looic"]))
  colnames(dSE_matrix) <- mnames
  rownames(dSE_matrix) <- mnames
  for (i in seq_len(length(L) - 1)) {
    for (j in seq((i + 1), length(L))) {
      ic_ptw1 <- IC_list_pw[[i]][["pointwise"]][, "looic"]
      ic_ptw2 <- IC_list_pw[[j]][["pointwise"]][, "looic"]
      dSE_matrix[i, j] <- as.numeric(
        sqrt(length(ic_ptw1) * var(ic_ptw1 - ic_ptw2))
      )
      dSE_matrix[j, i] <- dSE_matrix[i, j]
    }
  }
  IC_list <- unlist(IC_list)
  dIC <- IC_list - min(IC_list)
  w_IC <- ICweights(IC_list)
  topm <- which(dIC == 0)
  dSEcol <- dSE_matrix[, topm]
  result <- tibble(
    model = mnames,
    PSIS = IC_list, 
    SE = se_list,
    dPSIS = dIC,
    dSE = dSEcol,
    pPSIS = p_list,
    weight = w_IC
  ) |> 
    arrange(PSIS)
  new("compareIC", result, dSE = dSE_matrix)
}
