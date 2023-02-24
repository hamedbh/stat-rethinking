data{
  int<lower = 1> n; 
  array[n] real y; 
}

parameters{
  real mu; 
  real<lower=0> sigma; 
}

model{
  y ~ normal(mu, sigma); 
  mu ~ normal(1, 10); 
  sigma ~ exponential(1); 
}
