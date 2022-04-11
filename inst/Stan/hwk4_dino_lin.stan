data {
  int n; 
  int sp_id[n]; 
  int age[n]; 
  vector[n] mass;
}

parameters {
  vector<lower = 0>[6] bA;
  real<lower=0> sigma;
}

model {
  vector[n] mu; 
  sigma ~ exponential(1); 
  bA ~ exponential(5); 
  for (i in 1:n) {
    mu[i] = bA[sp_id[i]] * age[i];
  }
  mass ~ normal(mu, sigma); 
}

generated quantities {
  vector[n] log_lik;
  for (i in 1:n) {
    log_lik[i] = normal_lpdf(mass[i] | bA[sp_id[i]] * age[i], sigma);
  }
}
