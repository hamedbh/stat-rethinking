data {
  int n; 
  int cid[n]; 
  real P[n]; 
  int Y[n]; 
}

parameters {
  real a;
}

model {
  real lambda; 
  a ~ normal(3, 0.5); 
  lambda = a; 
  lambda = exp(lambda); 
  Y ~ poisson(lambda); 
}

generated quantities {
  real lambda; 
  vector[n] log_lik; 
  lambda = a; 
  lambda = exp(lambda); 
  for (i in 1:n) {
    log_lik[i] = poisson_lpmf(Y[i] | lambda);
  }
}
