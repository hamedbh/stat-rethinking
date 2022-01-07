data {
  int<lower=0> n;
  vector[n] height;
  vector[n] left; 
  vector[n] right; 
}

parameters {
  real a; 
  real<lower=0> bR; 
  real bL; 
  real<lower=0> sigma;
}

model {
  vector[n] mu; 
  a ~ normal(10, 100); 
  bR ~ normal(2, 10); 
  bL ~ normal(2, 10); 
  sigma ~ exponential(1); 
  for (i in 1:n) {
    mu[i] = a + (bR * right[i]) + (bL * left[i]); 
  }
  height ~ normal(mu, sigma); 
}

generated quantities{
    vector[n] log_lik;
    vector[n] mu;
    for (i in 1:n) {
        mu[i] = a + (bR * right[i]) + (bL * left[i]); 
    }
    for (i in 1:n) {
      log_lik[i] = normal_lpdf(height[i] | mu[i], sigma); 
    }
}
