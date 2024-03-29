data {
  int n; 
  array[n] int cid; 
  array[n] real P; 
  array[n] int Y; 
}

parameters {
  vector[2] a;
  vector[2] b;
}

model {
  vector[n] lambda; 
  a ~ normal(3, 0.5); 
  b ~ normal(0, 0.2); 
  for (i in 1:n) {
    lambda[i] = exp(a[cid[i]] + (b[cid[i]] * P[i])); 
  }
  Y ~ poisson(lambda); 
}

generated quantities {
  vector[n] lambda; 
  vector[n] log_lik; 
  for (i in 1:n) {
    lambda[i] = exp(a[cid[i]] + (b[cid[i]] * P[i])); 
  }
  for (i in 1:n) {
    log_lik[i] = poisson_lpmf(Y[i] | lambda[i]);
  }
}
