data {
  int n; 
  array[n] int y; 
  array[n] real tau; 
  array[n] int monastery; 
}

parameters {
  real a; 
  real b; 
}

model {
  vector[n] lambda; 
  a ~ normal(0, 1); 
  b ~ normal(0, 1); 
  for (i in 1:n) {
    lambda[i] = exp(tau[i] + a + (b * monastery[i])); 
  }
  y ~ poisson(lambda); 
}

generated quantities {
  vector[n] lambda; 
  vector[n] log_lik; 
  for (i in 1:n) {
    lambda[i] = exp(tau[i] + a + (b * monastery[i])); 
  }
  for (i in 1:n) {
    log_lik[i] = poisson_lpmf(y[i] | lambda[i]); 
  }
}
