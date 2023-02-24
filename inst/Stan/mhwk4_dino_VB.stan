data {
  int n; 
  array[n] int sp_id; 
  array[n] int age; 
  vector[n] mass;
}

parameters {
  vector[6] S;
  vector<lower = 0>[6] k;
  real<lower = 0> sigma;
}

model {
  vector[n] mu; 
  S ~ normal(1, 0.5); 
  k ~ exponential(1); 
  sigma ~ exponential(1);
  for (i in 1:n) {
    mu[i] = S[sp_id[i]] * (1 - exp(-k[sp_id[i]] * age[i]));
  }
  mass ~ normal(mu, sigma); 
}

generated quantities {
  vector[n] log_lik;
  vector[n] mu;
  for (i in 1:n) {
    mu[i] = S[sp_id[i]] * (1 - exp(-k[sp_id[i]] * age[i]));
  }
  for (i in 1:n) {
    log_lik[i] = normal_lpdf(mass[i] | mu[i], sigma);
  }
}
