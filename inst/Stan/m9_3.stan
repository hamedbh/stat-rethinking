data{
  int<lower = 1> n; 
  real y[n]; 
}

parameters{
  real alpha; 
  real<lower=0> sigma; 
}

transformed parameters{
  real mu; 
  mu = alpha; 
}

model{
  y ~ normal(mu, sigma); 
  alpha ~ normal(1, 10); 
  sigma ~ exponential(1); 
}
