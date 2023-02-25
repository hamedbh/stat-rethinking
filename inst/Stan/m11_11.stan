data {
  int n; 
  array[n] int cid; 
  array[n] real P; 
  array[n] int Y; 
}

parameters {
  vector[2] a;
  vector<lower=0>[2] b;
  real<lower=0> g;
}

model {
  vector[n] lambda; 
  a ~ normal(1, 1); 
  b ~ exponential(1);
  g ~ exponential(1);
  for (i in 1:n) {
    lambda[i] = (exp(a[cid[i]]) * (P[i]^b[cid[i]])) / g;
  }
  Y ~ poisson(lambda); 
}

generated quantities {
  vector[n] lambda; 
  vector[n] log_lik; 
  for (i in 1:n) {
    lambda[i] = (exp(a[cid[i]]) * (P[i]^b[cid[i]])) / g;
  }
  for (i in 1:n) {
    log_lik[i] = poisson_lpmf(Y[i] | lambda[i]);
  }
}
