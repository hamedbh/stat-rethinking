data {
  int n; 
  array[n] int cid; 
  array[n] real P; 
  array[n] int Y; 
}

parameters {
  real a;
}

model {
  real lambda; 
  a ~ normal(3, 0.5); 
  lambda = exp(a); 
  Y ~ poisson(lambda); 
}

generated quantities {
  real lambda; 
  vector[n] log_lik; 
  lambda = exp(a); 
  for (i in 1:n) {
    log_lik[i] = poisson_lpmf(Y[i] | lambda);
  }
}
