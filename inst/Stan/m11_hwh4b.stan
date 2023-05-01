data {
  int<lower=1> n_G;
  int<lower=1> n;
  array[n] int<lower=0> A;
  array[n] int<lower=0> Y;
  array[n] int<lower=1, upper=n_G> G;
}

parameters {
  vector[n_G] bG;
  real a;
}

model {
  bG ~ normal(0, 0.5);
  a ~ normal(0, 0.5);
  
  for (i in 1:n) {
    Y[i] ~ binomial_logit(A[i], bG[G[i]] + a);
  }
}

generated quantities {
  vector[n] log_lik;
  
  for (i in 1:n) {
    log_lik[i] = binomial_logit_lpmf(Y[i] | A[i], bG[G[i]] + a);
  }
}
