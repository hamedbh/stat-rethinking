data{
  int<lower = 1> n; 
  array[n] real y;
}

parameters{
  real a1;
  real a2; 
  real<lower=0> sigma; 
}

model{
  real mu; 
  mu = a1 + a2; 
  y ~ normal(mu, sigma); 
  a1 ~ normal(1, 10); 
  a2 ~ normal(1, 10); 
  sigma ~ exponential(1); 
}
