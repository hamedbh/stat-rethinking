data {
  int<lower=1> n_D;
  int<lower=1> n_G;
  int<lower=1> n;
  array[n] int<lower=0> A;
  array[n] int<lower=0> Y;
  array[n] int<lower=1, upper=n_D> D;
  array[n] int<lower=1, upper=n_G> G;
}

parameters {
  vector[n_D] bD;
  vector[n_G] bG;
}

model {
  bD ~ normal(0, 0.5);
  bG ~ normal(0, 0.5);
  
  for (i in 1:n) {
    Y[i] ~ binomial_logit(A[i], bD[D[i]] + bG[G[i]]);
  }
}

generated quantities {
  vector[n] log_lik;
  
  for (i in 1:n) {
    log_lik[i] = binomial_logit_lpmf(Y[i] | A[i], bD[D[i]] + bG[G[i]]);
  }
}
