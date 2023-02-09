data {
  int<lower=0> n;
  vector[n] doy; 
  vector[n] temp; 
}

parameters {
  real a; 
  real<lower=0> sigma;
}

model {
  sigma ~ exponential(1); 
  a ~ normal(0, 0.2); 
  doy ~ normal(a, sigma);
}

generated quantities {
  vector[n] log_lik; 
  for (i in 1:n) {
    log_lik[i] = normal_lpdf(doy[i] | a, sigma); 
  }
}
