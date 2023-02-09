data {
  int n; 
  int admit[n]; 
  int applications[n]; 
  int gid[n]; 
}

parameters {
  vector[2] a; 
}

model {
  vector[n] p; 
  a ~ normal(0, 1.5); 
  for (i in 1:n) {
    p[i] = inv_logit(a[gid[i]]);
  }
  admit ~ binomial(applications, p);
}

generated quantities {
  vector[n] p; 
  vector[n] log_lik; 
  for (i in 1:n) {
    p[i] = inv_logit(a[gid[i]]);
  }
  for (i in 1:n) {
    log_lik[i] = binomial_lpmf(admit[i] | applications[i], p[i]); 
  }
}
