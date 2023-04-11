data {
  int<lower=0> n;             // number of observations
  array[n] int<lower=0> S;    // outcome variable
  vector[n] C;                // predictor variable for tree cover
  vector[n] A;                // predictor variable for forest age
}

parameters {
  real a;                     // intercept
  real bC;                    // coefficient for C
  real bA;                    // coefficient for A
}

model {
  // priors
  a    ~ normal(3, 0.5);
  bC   ~ normal(0, 0.5);
  bA   ~ normal(0, 0.5);

  // likelihood
  for (i in 1:n) {
    S[i] ~ poisson_log(a + (bC * C[i]) + (bA * A[i]));
  }
}

generated quantities {
  vector[n] log_lik;
  real total_log_lik;
  total_log_lik = 0;
  for (i in 1:n) {
    log_lik[i] = poisson_log_lpmf(S[i] | a + (bC * C[i]) + (bA * A[i]));
    total_log_lik += log_lik[i];
  }
}
