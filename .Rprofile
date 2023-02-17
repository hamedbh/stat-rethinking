source("renv/activate.R")
try(
  {
    library(conflicted)
    conflicted::conflict_prefer("extract", "rstan")
    conflicted::conflict_prefer("filter", "dplyr")
    conflicted::conflict_prefer("lag", "dplyr")
    conflicted::conflict_prefer("map", "purrr")
    conflicted::conflict_prefer("set_names", "purrr")
    conflicted::conflict_prefer("stan", "rstan")
    options(mc.cores = parallel::detectCores())
    rstan_options(auto_write = TRUE)
  },
  silent = TRUE
)
