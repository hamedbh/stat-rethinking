data {
  int<lower=0> n;
  vector[n] doy; 
  vector[n] temp; 
}

parameters {
  real a; 
  real bT; 
  real<lower=0> sigma;
}

model {
  vector[n] mu;
  sigma ~ exponential(1); 
  bT ~ normal(0, 0.5); 
  a ~ normal(0, 0.2); 
  for (i in 1:n) {
    mu[i] = a + (bT * temp[i]); 
  }
  doy ~ normal(mu, sigma);
}

generated quantities {
  vector[n] log_lik; 
  vector[n] mu;
  for (i in 1:n) {
    mu[i] = a + (bT * temp[i]); 
  }
  for (i in 1:n) {
    log_lik[i] = normal_lpdf(doy[i] | mu[i], sigma); 
  }
}
