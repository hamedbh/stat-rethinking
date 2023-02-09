data {
  int<lower = 0> n; 
  vector[n] happiness; 
  vector<lower = 0, upper = 1>[n] A; 
  int mid[n];
}

parameters {
  real a; 
  real bA; 
  real<lower = 0> sigma;
}

model{
  vector[n] mu; 
  sigma ~ exponential(1); 
  bA ~ normal(0, 2); 
  a ~ normal(0, 1); 
  for (i in 1:n) {
    mu[i] = a + (bA * A[i]); 
  }
  happiness ~ normal(mu, sigma); 
}

generated quantities {
  vector[n] log_lik; 
  vector[n] mu; 
  for (i in 1:n) {
    mu[i] = a + (bA * A[i]); 
  }
  for (i in 1:n) {
    log_lik[i] = normal_lpdf(happiness[i] | mu[i], sigma); 
  }
}
