data{
  int<lower = 1> n; 
  real y[n]; 
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
  a1 ~ normal(1, 1000); 
  a2 ~ normal(1, 1000); 
  sigma ~ exponential(1); 
}
